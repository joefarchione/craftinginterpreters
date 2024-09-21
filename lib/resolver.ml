open Core

module VariableState = struct 
  type t = 
  | Declare
  | Define
  [@@deriving eq, sexp, show {with_path = false}]
end

module Scope = struct 
  module M = Coremap.SexpEqShowMap(String [@deriving sexp, compare])(VariableState)
  include M

  let add (t:t) (k:string) (v:VariableState.t)  = 
    match Map.add t ~key:k ~data:v with
    | `Ok (v) -> v
    | `Duplicate -> Map.set t ~key:k ~data:v
  let define t (token: Token.t) = add t token.lexeme VariableState.Define
  let declare t (token:Token.t) = add t token.lexeme VariableState.Declare

  let status_is_declared (token: Token.t) t = 
    match Map.find t token.lexeme with
    | Some (status) -> VariableState.equal status VariableState.Declare
    | None -> false

  let status_is_defined (token: Token.t) t = 
    match Map.find t token.lexeme with
    | Some (status) -> VariableState.equal status VariableState.Define
    | None -> false

  let status_at_least_declared token t = (status_is_defined token t) || (status_is_declared token t)

  let empty = Map.empty (module String)
  let contains (token:Token.t) t= 
    match Map.find t token.lexeme with
    | Some (_) -> true
    | None -> false

  let print t = (Printf.printf "%s") (show t)

end

module ScopeStack = struct 
  type t = Scope.t list [@@deriving show {with_path = false}]
  let empty = Scope.empty :: []
  let pop (t:t)  = 
    match t with 
      | [] -> (None, []) 
      | [x] -> (Some x, []) 
      | hd::tl -> (Some hd, tl)

  let peek (t:t) : Scope.t = 
    match t with
    | hd :: _ -> hd
    | _ ->  raise Lox_error.(RunTimeError ("Scope Error", "No next scope"))

  let begin_scope (scopes: t) = Scope.empty :: scopes
  let end_scope (t:t) : t  = 
    match t with 
    | _ :: tl -> tl 
    | []  -> failwith "can't end empty scope"

  let is_empty t =  List.is_empty t

  let is_defined_in_current_scope (token:Token.t) scopes = 
    match scopes with 
    | [] -> false
    | hd :: _ -> Scope.status_is_defined token hd

  let is_declared_in_current_scope (token: Token.t) scopes = 
    match scopes with 
    | [] -> false
    | hd :: _ -> Scope.status_is_declared token hd

  let print t = List.iter t ~f:(fun l -> Scope.print l )

end

module Locals = struct
  module M = Coremap.SexpEqShowMap(Expression)(Int [@deriving sexp])
  include M

  let get (expr: Expression.t) (t:t) = 
    match Map.find t expr with
    | Some(v) -> Some v
    | None -> None

  let add (t:t) (k: Expression.t) (v:int)  = 
    match Map.add t ~key:k ~data:v with
    | `Ok (v) -> v
    | `Duplicate -> Map.set t ~key:k ~data:v

end

type function_type = 
| Function
[@@deriving show {with_path = false}]

type t = {
  scopes: ScopeStack.t;
  locals: Locals.t;
  current_function: function_type option
}
[@@deriving show {with_path = false}]

let print t = Printf.printf "%s" (show t)
let create () = {
  scopes = ScopeStack.empty;
  locals = Locals.empty;
  current_function= None;
}

exception ResolverError of Token.t * string

let pop  = function | [] -> (None, []) | [x] -> (Some x, []) | hd::tl -> (Some hd, tl)
let begin_scope (t: t) = {t with scopes = Scope.empty :: t.scopes}
let end_scope (t:t) : t  = 
  {t with scopes = ScopeStack.end_scope t.scopes}
let is_empty t =  List.is_empty t.scopes
let is_defined_in_current_scope tokens (t:t) = 
  ScopeStack.is_declared_in_current_scope tokens t.scopes

let is_declared_in_current_scope token (t:t) = 
  match t.scopes with 
  | [] -> false
  | hd :: _ -> Scope.status_is_declared token hd

let declare  (name : Token.t) (t:t) = 
  match t.scopes with 
  | [] -> t
  | hd :: tl -> 
    if Scope.contains name hd then 
      raise (ResolverError (name, "Already a variable in this scope with this name"))
    else
      let hd = Scope.declare hd name in 
      {t with scopes = hd :: tl}

let define  (name : Token.t) (t:t)= 
  match t.scopes with 
  | [] -> t
  | hd :: tl -> 
    let hd = Scope.define hd name in 
    {t with scopes = hd :: tl}

let rec resolve_local_i (i:int) (expr: Expression.t) (token: Token.t) (t:t) : Locals.t = 
  match t.scopes with
  | [] -> t.locals
  | hd :: _ when Scope.contains token hd -> Locals.add t.locals expr i
  | _ :: tl -> resolve_local_i (i+1) expr token {t with scopes = tl}

let resolve_local (expr: Expression.t) (token: Token.t) (t: t) = resolve_local_i 0 expr token t

let rec resolve (resolvees: Statement.t list) (t:t) = 
  match resolvees with 
  | [] -> t
  | hd :: tl -> (
    resolve_stmt hd t
    |> resolve tl
  )
and resolve_stmt (stmt: Statement.t) (t:t) = 
  match stmt with 
  | Block (stmts) -> 
    begin_scope t
    |> resolve stmts 
    |> end_scope
  | VarDeclaration (v) -> 
    let t = declare v.name t in 
    let t = match v.init with 
    | Some (init) -> resolve_expr init t
    | None -> t in 
    define v.name t
  | FunctionDeclaration (name, params, body) -> 
    declare name t
    |> define name 
    |> resolve_function params body Function
  | ClassDeclaration (name, _) -> 
      declare name t
      |> define name
  | If (condition, thenbranch) -> 
    resolve_expr condition t
    |> resolve_stmt thenbranch
  | IfElse (condition, thenbranch, elsebranch) -> 
    resolve_expr condition t
    |> resolve_stmt thenbranch
    |> resolve_stmt elsebranch
  | Print (expr) -> 
    resolve_expr expr t
  | Return (expr_opt) -> (
    match t.current_function with 
    | None -> raise Lox_error.(RunTimeError ("return", "Can't return from top-level code"))
    | Some (Function) -> 
      match expr_opt with
      | Some (e) -> resolve_expr e t
      | None -> t
  )
  | While (condition, body) -> (
    resolve_expr condition t
    |> resolve_stmt body
  )
  | For (init, condition, increment, body) -> (
      let t = 
        match init with 
        | Some (i) -> resolve_stmt i t
        | None -> t in 

      let t = 
        resolve_expr condition t
        |> resolve_stmt body in 

      match increment with
      | Some (i) -> resolve_expr i t
      | None -> t
  )
  | Expression (expr) -> (
    match expr with 
    | Assignment (token, expr)  -> (
      let t = resolve_expr expr t in 
      let locals = resolve_local expr token t in 
      {t with locals = locals}
    )
    | Unary (_, right) -> 
      resolve_expr right t
    | BinaryOp (left, _, right) -> 
        resolve_expr left t
        |> resolve_expr right
    | Logical (left, _, right) -> 
        resolve_expr left t
        |> resolve_expr right
    | Call (callee, _, arguments) -> 
        resolve_expr callee t
        |> fold_resolve_expr arguments
    | Grouping (expr) -> 
      resolve_expr expr t
    | Literal (_) -> t
    | Variable (v) -> (
      if (not (ScopeStack.is_empty t.scopes)
        && (
          let scope = ScopeStack.peek t.scopes in 
          Scope.status_is_declared v scope
        )
      ) then
        raise Lox_error.(RunTimeError (v.lexeme, "Can't read local variable in it's own initializer"))
      else
        {t with locals = resolve_local expr v t }
    )
    | Get (name, _) -> 
      resolve_expr name t
    | _ -> failwith "expression not implemented"
  )

and resolve_expr (expr: Expression.t ) (t:t) =
  resolve_stmt (Statement.Expression expr) t

and fold_resolve_stmt (lst: Statement.t list) (t:t)  = 
  List.fold lst ~init:t ~f:(fun s p -> resolve_stmt p s) 

and fold_resolve_expr (lst: Expression.t list) (t:t) = 
  List.fold lst ~init:t ~f:(fun s p -> resolve_expr p s) 

and resolve_function (params: Token.t list) (body: Statement.t list) (f_type: function_type) (t:t) = 
  let enclosing_function = t.current_function in 
  let t = begin_scope t in 
  let t = {t with current_function = Some f_type} in 
  let t = 
    List.fold params ~init:t ~f:(fun s p -> declare p s |> define p) 
    |> resolve body
    |> end_scope in 
  {t with current_function = enclosing_function}
