open Core

exception ReturnError of Value.t

module State = struct
  type t = {
    env: Environment.t;
    resolver: Resolver.t;
  }
  [@@deriving show {with_path = false}]

  let empty = {env=Environment.empty; resolver=Resolver.create ();}
  let print t = Printf.printf "%s" (show t)
end

let lookup_variable token expr (state:State.t) =
  let distance = Resolver.Locals.get expr state.resolver.locals  in
  match distance with
  | Some(d) -> 
      Environment.get_at d token state.env
  | None -> 
      (*TODO this should be looking in global environment but this breaks for functions?*)
      Environment.get token state.env

let state_assign (token:Token.t) (expr:Expression.t) (value: Value.t) (state:State.t) = 
  let distance = Resolver.Locals.get expr state.resolver.locals  in
  let new_env = 
    match distance with
    | Some (d) ->  (
      Environment.assign_at d token.lexeme value state.env
    )
    | None -> Environment.assign_at (List.length state.env) token.lexeme value state.env in 
  {state with env = new_env}

let rec evaluate_expr (expr: Expression.t) (state:State.t): Value.t * State.t = 
  match expr with 
  | Literal (l) ->  l, state
  | BinaryOp (a, o, b) ->  (
    let left, state  = evaluate_expr a state in 
    let right, state = evaluate_expr b state in 
    let value = 
      match (o.tag, left, right) with 
      | (Token.PLUS, LoxString(l), LoxString(r)) ->  (Value.LoxString (l ^ r))
      | (Token.PLUS, LoxNumber (l), LoxNumber (r)) -> (Value.LoxNumber (l +. r))
      | (Token.MINUS, LoxNumber(l), LoxNumber (r)) ->  (Value.LoxNumber (l -. r))
      | (Token.SLASH, LoxNumber(l), LoxNumber (r)) ->  (Value.LoxNumber (l /. r ))
      | (Token.STAR, LoxNumber(l), LoxNumber (r)) -> (Value.LoxNumber (l *. r))
      | (Token.GREATER, LoxNumber(l), LoxNumber (r)) -> (Value.LoxBool Float.(l > r))
      | (Token.GREATER_EQUAL, LoxNumber(l), LoxNumber (r)) -> (Value.LoxBool Float.(l >= r))
      | (Token.LESS, LoxNumber(l), LoxNumber (r)) -> (Value.LoxBool Float.(l < r))
      | (Token.LESS_EQUAL, LoxNumber(l), LoxNumber (r)) -> (Value.LoxBool Float.(l <= r))
      | (Token.BANG_EQUAL, _, _) -> (Value.LoxBool (not (Value.is_equal left right)))
      | (Token.EQUAL_EQUAL, _, _) -> 
        (Value.LoxBool (Value.is_equal left right))
      | _ -> raise (Expression.EvalError expr) in 
    value, state
  )
  | Unary (o, a) -> (
    let right, state  = evaluate_expr a state in 
    let value = 
      match o.tag with 
      | Token.BANG -> Value.LoxBool (not (Value.is_truthy right))
      | Token.MINUS -> Value.LoxNumber (-1.0 *. (Value.float_of right))
      | _ -> raise (Expression.EvalError expr) in 
    value, state
  )
  | Grouping (e) -> (evaluate_expr e state)
  | Variable (token) -> 
      (lookup_variable token.lexeme expr state), state
  | Assignment (token, expr) -> (
      let (value, state) = evaluate_expr expr state in
      (value, state_assign token expr value state)
  )
  | Logical (a, o, b) -> 
    let (left, env) = evaluate_expr a state in
    let (value, env) = 
      match o.tag with 
        | Token.AND -> 
          if not (Value.is_truthy left) then left, env
          else evaluate_expr b env
        | Token.OR -> 
          if (Value.is_truthy left) then left, env
          else evaluate_expr b env 
        | _ -> raise Lox_error.(ParseError {line=o.line; lexeme=o.lexeme; message="ill-formed logical"}) in 
    value, env
  | Call (callee, _, arguments) -> (
    let (callee, env) = evaluate_expr callee state in
    let eval_args = List.map ~f:(fun a -> evaluate_expr a env |> (fun (a, _ ) -> a)) arguments in 
    match callee with 
    | Value.LoxFunction f when List.length eval_args = f.arity -> 
      (Value.call callee eval_args, env)
    | Value.LoxClass _ -> 
      (Value.call callee eval_args, env)
    | Value.LoxInstance _ -> 
      (Value.call callee eval_args, env)
    | _ ->  raise (Expression.EvalError expr) 
  )
  | Get (name, expr) -> (
    let (lox_object, state) = evaluate_expr name state in 
    match lox_object with 
    | LoxInstance i -> 
      Value.get_property expr.lexeme i, state
    | _ -> raise Lox_error.(RunTimeError (expr.lexeme, "Only instances have properties"))
  ) 
  | Set (name, token, value) -> (
    let (lox_object, state) = evaluate_expr name state in 
    match lox_object with 
    | LoxInstance instance -> 
      let (value, state) = evaluate_expr value state in
      let instance = (Value.set_property token.lexeme value instance) in
      let env = 
        match name with 
        | Expression.Variable (v) -> 
          Environment.assign v.lexeme (LoxInstance instance) state.env 
        | _ -> state.env in 
      LoxInstance instance, {state with env = env}
    | _ -> raise Lox_error.(RunTimeError (token.lexeme, "Only instances have fields"))
  )
  | This (token) -> (
    (lookup_variable token.lexeme expr state), state
  )
  | Super (_, loxmethod) -> (
    let distance = Resolver.Locals.get expr state.resolver.locals in 
    match distance with 
    | Some(d) -> (
        let superclass =  
          match Environment.get_at (d-1) "super" state.env with 
          | LoxClass (c) -> c 
          | _ -> failwith "expected class"
        in 
        let lox_object = 
          match Environment.get_at (d-2) "this" state.env  with 
          | LoxInstance (i) -> i
          | _ -> failwith "expected class"
        in
        let lox_method = (
          match Value.find_method_on_class loxmethod.lexeme superclass with
          | Some(Value.LoxMethod (m)) -> m 
          | _ -> failwith "expected method"
        )
        in  
        (Value.LoxFunction (Value.bind_method lox_method lox_object)), state
    )
    | None -> failwith "super not defined in locals"
  )



let rec evaluate_statement (statement: Statement.t) (state:State.t) :State.t= 
    match statement with 
    | Statement.Expression (expr) -> 
      let _, state = evaluate_expr expr state in 
      state
    | Statement.Print (expr) -> (
      let value, state = evaluate_expr expr state in 
      Value.print value;
      Printf.printf "\n";
      state
    ) 
    | Statement.VarDeclaration {name; init;} -> (
      let value, state = 
        match init with
        | Some (v) -> evaluate_expr v state 
        | None -> LoxNil, state in 
      let env = Environment.define name.lexeme value state.env in 
      {state with env = env}
    )
    | Statement.Block (b) -> (
      let block_state = {state with env = Environment.create_local state.env } in 
      let block_state = evaluate_statements b block_state in 
      {state with env = (Environment.pop block_state.env)}
    )
    | Statement.If (condition, then_branch) -> 
        let eval_condition, _ = evaluate_expr condition state in
        if Value.is_truthy (eval_condition) 
        then 
            let (_, state) = evaluate_expr then_branch state in 
            state
        else
          state
    | Statement.IfElse (condition, then_branch, else_branch) -> 
        let eval_condition, _ = evaluate_expr condition state in
        if Value.is_truthy (eval_condition) 
        then (
          let (_, state) =evaluate_expr then_branch state in 
          state
        )
        else (
          let (_, state) =evaluate_expr else_branch state in 
          state
        )
    | Statement.While (condition, body) -> (
      let rec lox_while condition body state = 
        let (value, state) = evaluate_expr condition state in 
        if Value.is_truthy value then  (
          let (_, state) = evaluate_expr body state in
          lox_while condition body state
        )
        else  (
          state 
        ) in
      lox_while condition body state
    )
    | Statement.ClassDeclaration (token, superclass, method_stmts) ->  (
      let (superclass, state) = (
        match superclass with 
        | Some (s)  -> (
            let (superclass, state) =  evaluate_expr s state in 
            match superclass with 
            | LoxClass (c) -> (Some c, state)
            | _ -> failwith "Superclass must be a class"
        )
        | None -> (None, state)
      ) in 
      let state = {state with env = Environment.define token.lexeme Value.LoxNil state.env} in 
      let env = (
        match superclass with 
        | Some(s) -> 
          let env = Environment.create_local state.env in 
          Environment.define "super" (LoxClass(s)) env
        | None -> state.env
      )
      in
      let state = {state with env = env} in 
      let methods = 
        List.fold method_stmts ~init:Value.ClassFields.empty 
          ~f:(fun acc m -> 
            match m with  
            | FunctionDeclaration (name, params, body) -> 
              Value.ClassFields.set name.lexeme (create_lox_method name params body state) acc
            | _ -> failwith "only expected function declaratations here"
          ) in 

      let arity = (
        match Value.ClassFields.find "init" methods with
        | Some (Value.LoxFunction(f)) -> f.arity
        | _ -> 0
      ) in 
      let klass = Value.(LoxClass {name=token.lexeme; superclass; arity = arity ;methods = methods;}) in 
      let env = (
        match superclass with 
        | Some(_) -> Environment.pop state.env
        | None -> state.env
      )
      in
      let env = Environment.define token.lexeme klass env in
      {state with env = env}
    )
    | Statement.FunctionDeclaration (name, params, body) ->  (
      let lox_function = create_lox_function name params body state in 
      let env = Environment.define name.lexeme lox_function state.env in 
      {state with env = env}
    )
    | Statement.For (init, condition, increment, body) -> (
      (*NOTE locals mapping does not have UUID for objects like java :( Need to implement for loop in ocaml*)
      let for_state = {state with env = Environment.create_local state.env} in 
      let for_state = match init with 
      | Some (i) -> evaluate_statement i for_state
      | None -> for_state in 

      let rec lox_for condition body state = 
        let (value, state) = evaluate_expr condition state in 
        if Value.is_truthy value then  (
          let state = evaluate_statement body state in 
          let state = 
            match increment with 
            | Some (i) -> let (_, state) = evaluate_expr i state in state
            | None -> state in 
          lox_for condition body state
        )
        else  (
          state 
        ) in
      lox_for condition body for_state
    )
    | Statement.Return (expr) -> 
      match expr with 
      | Some (e) -> 
        let (value, _) = evaluate_expr e state in 
        raise (ReturnError value)
      | None  -> raise (ReturnError Value.LoxNil)

and create_lox_function (name: Token.t) (params: Token.t list) (body: Statement.t list) (state: State.t) = 
    let func_env = Environment.create_local state.env in
    let call_func (args: Value.t list) : Value.t = 
      let closure = 
        match (List.fold2 params args ~init:func_env ~f:(fun acc p a -> Environment.define p.lexeme a acc)) with 
        | Ok (e) -> e
        | Unequal_lengths -> Lox_error.too_few_arguments_supplied () in 

      try (
        let _ = evaluate_statements body {state with env = closure} in 
        Value.LoxNil
      )
      with 
        | ReturnError (v) -> v in 
    Value.LoxFunction {name = name.lexeme; arity = List.length params; callable = call_func}

and create_lox_method (name: Token.t) (params: Token.t list) (body: Statement.t list) (state: State.t) = 
    (* let global_env = Environment.get_global state.env in 
    let func_env = Environment.create_local [global_env] in *)
    let call_func (instance: Value.lox_instance) (args: Value.t list) : Value.t = 
      let closure = 
        Environment.create_local state.env
        |> Environment.define "this" (Value.LoxInstance(instance)) in 
      let closure = 
        match (List.fold2 params args ~init:closure ~f:(fun acc p a -> Environment.define p.lexeme a acc)) with 
        | Ok (e) -> e
        | Unequal_lengths -> Lox_error.too_few_arguments_supplied () in 

      try (
        let _ = evaluate_statements body {state with env = closure} in 
        if String.equal name.lexeme "init" then 
          Environment.get_at 0 "this" closure
        else
          Value.LoxNil
      )
      with 
        | ReturnError (v) -> (
          if String.equal name.lexeme "init" then 
            Environment.get_at 0 "this" closure
          else
            v
        ) in 
    Value.LoxMethod {name = name.lexeme; arity = List.length params; callable = call_func}
and evaluate_statements (stmts: Statement.t list) (state: State.t) : State.t = 
  List.fold 
    stmts
    ~init:state
    ~f:(fun state stmt -> evaluate_statement stmt state)

and interpret text = (
  try 
  let state = State.empty in
  let statements = 
    Lexer.scan_text text
    |> Parser.parse in 
  let resolver = Resolver.resolve statements state.resolver in 
  ignore (evaluate_statements statements {state with resolver = resolver});
  with 
    | Lox_error.ParseError (e) -> Printf.printf "message='%s' at line %d for lexeme='%s'" e.message e.line e.lexeme 
    | Expression.EvalError (e) -> Printf.printf "invalid expression %s" (Expression.show e)
    | Lox_error.RunTimeError (a, _) ->  Printf.printf "runtime error: %s" a
    | Resolver.ResolverError (msg) ->  Printf.printf "resover error: %s"  msg
    | Lox_error.TooFewArgumentsSupplied (e) -> Printf.printf "%s" e
    | Lox_error.TooManyArgumentsSupplied (e) -> Printf.printf "%s" e
)

let prompt () : unit = (
  let rec repl (state: State.t) = (
    Printf.printf ">> %!";
    match In_channel.input_line In_channel.stdin with
    | None -> failwith "Exiting command line"
    | Some line -> (
      let statements = 
        Lexer.scan_text line
        |> Parser.parse in 
      let resolver = Resolver.resolve statements state.resolver in 
      let state = evaluate_statements statements {state with resolver = resolver} in 
      repl state
    ) 
  ) in 
  let state = State.empty in
  repl state
)