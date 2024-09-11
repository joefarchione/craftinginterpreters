open Core

module Scope = struct 
  type variable_state = 
  | Declare
  | Define
  [@@deriving eq]

  type t = (string, variable_state, String.comparator_witness) Map.t 
  let add t k v  = 
    match Map.add t ~key:k ~data:v with
    | `Ok (v) -> v
    | `Duplicate -> Map.set t ~key:k ~data:v
  let define t (token: Token.t) = add t token.lexeme Define
  let declare t (token:Token.t) = add t token.lexeme Declare

  let status_is_declared (token: Token.t) t = 
    match Map.find t token.lexeme with
    | Some (status) -> equal_variable_state status Declare
    | None -> false

  let status_is_defined (token: Token.t) t = 
    match Map.find t token.lexeme with
    | Some (status) -> equal_variable_state status Define
    | None -> false

  let empty = Map.empty (module String)
  let contains (token:Token.t) t= 
    match Map.find t token.lexeme with
    | Some (_) -> true
    | None -> false

end

module ScopeStack = struct 
  type t = Scope.t list
  let empty = Map.empty (module String) :: []
  let pop  = function | [] -> (None, []) | [x] -> (Some x, []) | hd::tl -> (Some hd, tl)
  let begin_scope (scopes: t) = Scope.empty :: scopes
  let end_scope (t:t) : t  = 
    match t with 
    | _ :: tl -> tl 
    | _  -> t 
  let is_empty t =  List.is_empty t

  let is_defined_in_current_scope (token:Token.t) scopes = 
    match scopes with 
    | [] -> false
    | hd :: _ -> Scope.status_is_defined token hd

  let is_declared_in_current_scope (token: Token.t) scopes = 
    match scopes with 
    | [] -> false
    | hd :: _ -> Scope.status_is_declared token hd

end

module Locals = struct
  type t = (Expression.t, int, String.comparator_witness) Map.t

  let get (expr: Expression.t) (t:t) = 
    match Map.find t expr with
    | Some(v) -> Some v
    | None -> None

  let add (t:t) (k: Expression.t) (v:int)  = 
    match Map.add t ~key:k ~data:v with
    | `Ok (v) -> v
    | `Duplicate -> Map.set t ~key:k ~data:v

end

type t = {
  scopes: ScopeStack.t;
  locals: Locals.t;
}

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

let declare_or_define func (t: t) (name : Token.t) = 
  match t.scopes with 
  | [] -> t
  | hd :: tl -> 
    let hd = func hd name in 
    {t with scopes = hd :: tl}

let declare  (name : Token.t) (t:t)= declare_or_define Scope.declare t name
let define  (name : Token.t) (t:t)= declare_or_define Scope.define t name
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
    |> end_scope
  )
and resolve_stmt (stmt: Statement.t) (t:t) = 
  match stmt with 
  | Block (stmts) -> 
    begin_scope t
    |> resolve stmts 
  | VarDeclaration (v) -> 
    let t = declare v.name t in 
    let t = match v.init with 
    | Some (init) -> resolve_expr init t
    | None -> t in 
    define v.name t
  | FunctionDeclaration (name, params, body) -> 
    declare name t
    |> define name 
    |> resolve_function params body
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
    match expr_opt with
    | Some (e) -> resolve_expr e t
    | None -> t
  )
  | While (condition, body) -> (
    resolve_expr condition t
    |> resolve_stmt body
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
    | Call (callee, _, arguments) -> 
        resolve_expr callee t
        |> fold_resolve_expr arguments
    | Grouping (expr) -> 
      resolve_expr expr t
    | Literal (_) -> t
    | Variable (v) -> (
      if not (ScopeStack.is_empty t.scopes) then
        raise Lox_error.(RunTimeError (v.lexeme, "Can't read local variable in it's own initializer"))
      else
        {t with locals = resolve_local expr v t }
    )
    | _ -> failwith "not implemented"
  )
  | _ -> failwith "not implemented"

and resolve_expr (expr: Expression.t ) (t:t) =
  resolve_stmt (Statement.Expression expr) t

and fold_resolve_stmt (lst: Statement.t list) (t:t)  = 
  List.fold lst ~init:t ~f:(fun s p -> resolve_stmt p s) 

and fold_resolve_expr (lst: Expression.t list) (t:t) = 
  List.fold lst ~init:t ~f:(fun s p -> resolve_expr p s) 

and resolve_function (params: Token.t list) (body: Statement.t list) (t:t) = 
  let t = begin_scope t in 
  List.fold params ~init:t ~f:(fun s p -> declare p s |> define p) 
  |> resolve body
  |> end_scope
