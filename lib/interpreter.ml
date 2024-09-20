open Core

module State = struct
  type t = {
    env: Environment.t;
    resolver: Resolver.t;
  }

  let empty = {env=Environment.empty; resolver=Resolver.create ();}
end

let lookup_variable token expr (state:State.t) =
  let distance = Resolver.Locals.get expr state.resolver.locals  in
  match distance with
  | Some(v) -> 
      Environment.get_at v token state.env
  | None -> 
      (*TODO this should be looking in global environment but this breaks for functions?*)
      Environment.get token state.env

let state_assign (token:Token.t) (expr:Expression.t) (value: Value.t) (state:State.t) = 
  let distance = Resolver.Locals.get expr state.resolver.locals  in
  let new_env = 
    match distance with
    | Some (d) ->  Environment.assign_at d token value state.env
    | None -> Environment.assign_at (List.length state.env) token value state.env in 
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
      | (Token.EQUAL_EQUAL, _, _) -> (Value.LoxBool (Value.is_equal left right))
      | _ -> raise (Lox_error.EvalError {expr}) in 
    value, state
  )
  | Unary (o, a) -> (
    let right, state  = evaluate_expr a state in 
    let value = 
      match o.tag with 
      | Token.BANG -> Value.LoxBool (Value.is_truthy right)
      | Token.MINUS -> Value.LoxNumber (-1.0 *. (Value.float_of right))
      | _ -> raise (Lox_error.EvalError {expr}) in 
    value, state
  )
  | Grouping (e) -> (evaluate_expr e state)
  | Variable (v) -> 
      (lookup_variable v expr state), state
  | Assignment (token, expr) -> 
      evaluate_expr expr state 
      |> (fun (value, state) -> 
        (value, state_assign token expr value state)) 
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
  | Call (callee, _, arguments) -> 
    let (callee, env) = evaluate_expr callee state in
    let eval_args = List.map ~f:(fun a -> evaluate_expr a env |> (fun (a, _ ) -> a)) arguments in 
    match callee with 
    | Value.LoxFunction f when List.length eval_args = f.arity -> 
      (Value.call callee eval_args, env)
    | _ ->  raise (Lox_error.EvalError {expr}) 

let rec evaluate_statement (statement: Statement.t) (state:State.t) :State.t= 
    match statement with 
    | Statement.Expression (expr) -> 
      let _, state = evaluate_expr expr state in 
      state
    | Statement.Print (expr) -> (
      let value, state = evaluate_expr expr state in 
      Value.print value;
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
      let _  = evaluate_statements b state in 
      state
    )
    | Statement.If (condition, then_branch) -> 
        let eval_condition, _ = evaluate_expr condition state in
        if Value.is_truthy (eval_condition) 
        then 
            evaluate_statement then_branch state
        else
          state
    | Statement.IfElse (condition, then_branch, else_branch) -> 
        let eval_condition, _ = evaluate_expr condition state in
        if Value.is_truthy (eval_condition) 
        then evaluate_statement then_branch state
        else evaluate_statement else_branch state
    | Statement.While (condition, body) -> 
      interpret_while condition body state
    | Statement.For (init, condition, increment, body) -> 
      let body = 
        match increment with
        | Some (i) -> Statement.Block [body; (Statement.Expression (i))]
        | None -> Statement.Block [body] in 
      let body = 
        match condition with 
        | Some (c) ->  Statement.While (c, body)
        | None -> Statement.While (Expression.Literal (Value.LoxBool true), body) in 
      let body = 
        match init with 
        | Some (i) -> Statement.Block [i; body]
        | None -> body in
      evaluate_statement body state
    | Statement.FunctionDeclaration (name, params, body) -> 
      let global_env = Environment.get_global state.env in 
      let func_env = Environment.create_local [global_env] in
      let call_func (args: Value.t list) : Value.t = 
        let closure = 
          match (List.fold2 params args ~init:func_env ~f:(fun acc p a -> Environment.define p.lexeme a acc)) with 
          | Ok (e) -> e
          | Unequal_lengths -> Lox_error.too_few_arguments_supplied () in 

        try 
          ignore (evaluate_statements body {state with env = closure});
          Value.LoxNil 
        with 
          | Lox_error.ReturnError (v) -> v in 
      let env = Environment.define name.lexeme (Value.LoxFunction {name = name.lexeme; arity = List.length params; callable = call_func}) state.env in 
      {state with env = env}
    | Statement.Return (expr) -> 
      match expr with 
      | Some (e) -> 
        let (value, _) = evaluate_expr e state in 
        raise (Lox_error.ReturnError value)
      | None  -> raise (Lox_error.ReturnError Value.LoxNil)

and evaluate_statements (stmts: Statement.t list) (state: State.t) = 
  List.fold 
    stmts
    ~init:state
    ~f:(fun state stmt -> evaluate_statement stmt state)

and interpret_while condition body state = 
  let (value, state) = evaluate_expr condition state in 
  if Value.is_truthy value then 
    evaluate_statement body state 
    |> interpret_while condition body 
  else 
    state

and interpret text = 
  let state = State.empty in
  let statements = 
    Lexer.scan_text text
    |> Parser.parse in 
  Statement.print_statements statements;
  let resolver = Resolver.resolve statements state.resolver in 
  ignore (evaluate_statements statements {state with resolver = resolver});
  ()
  (* with 
  | Lox_error.ParseError (e) -> Lox_error.report_parse_error e *)

let%test "function_call" = 
  ignore (
    let text = "
    fun add(a, b) {
      print a + b;
    }
    
    add(1, 2);

    " in  
    interpret text
  );
  true
