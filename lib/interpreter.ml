open Core

type state = {
  env: Environment.t;
  resolver: Resolver.t;
}

let lookup_variable token expr state =
  let distance = Resolver.Locals.get expr state.resolver.locals  in
  match distance with
  | Some(v) -> Environment.get_at v token state.env
  | None -> Environment.get (Environment.get_global state.env) token

let state_assign (token:Token.t) (expr:Expression.t) (value: Value.t) (state:state) = 
  let distance = Resolver.Locals.get expr state.resolver.locals  in
  match distance with
  | Some(v) -> Environment.assign_at v token value state.env
  | None -> 
    let global_env = Environment.get_global state.env in 
    Environment.assign global_env token value

let rec evaluate_expr (expr: Expression.t) (state: state): Value.t * state = 
  match expr with 
  | Literal (l) ->  l, state
  | BinaryOp (a, o, b) ->  (
    let left, state  = evaluate_expr a state in 
    let right, state = evaluate_expr b state in 
    let value = 
      match (o, left, right) with 
      | (Plus, LoxString(l), LoxString(r)) ->  (Value.LoxString (l ^ r))
      | (Plus, LoxNumber (l), LoxNumber (r)) ->   (Value.LoxNumber (l +. r))
      | (Minus, LoxNumber(l), LoxNumber (r)) ->  (Value.LoxNumber (l -. r))
      | (Slash, LoxNumber(l), LoxNumber (r)) -> (Value.LoxNumber (l /.r ))
      | (Star, LoxNumber(l), LoxNumber (r)) -> (Value.LoxNumber (l *. r))
      | (Greater, LoxNumber(l), LoxNumber (r)) -> (Value.LoxBool Float.(l > r))
      | (Greater_equal, LoxNumber(l), LoxNumber (r)) -> (Value.LoxBool Float.(l >= r))
      | (Less, LoxNumber(l), LoxNumber (r)) -> (Value.LoxBool Float.(l < r))
      | (Less_equal, LoxNumber(l), LoxNumber (r)) -> (Value.LoxBool Float.(l <= r))
      | (Bang_equal, _, _) -> (Value.LoxBool (not (Value.is_equal left right)))
      | (Equal_equal, _, _) -> (Value.LoxBool (Value.is_equal left right))
      | _ -> raise (Lox_error.EvalError {expr}) in 
    value, state
  )
  | Unary (o, a) -> (
    let right, state  = evaluate_expr a state in 
    let value = 
      match o with 
      | Bang -> Value.LoxBool (Value.is_truthy right)
      | Minus -> Value.LoxNumber (-1.0 *. (Value.float_of right))
      | _ -> raise (Lox_error.EvalError {expr}) in 
    value, state
  )
  | Grouping (e) -> (evaluate_expr e state)
  | Variable (v) -> (lookup_variable v expr state), state
  | Assignment (token, expr) -> 
      let value, state = evaluate_expr expr state in 
      let env = state_assign token expr value state in 
      value, {state with env = env}
  | Logical (a, o, b) -> 
    let (left, env) = evaluate_expr a state in
    let (value, env) = 
      match o with 
        | And -> 
          if not (Value.is_truthy left) then left, env
          else evaluate_expr b env
        | Or -> 
          if (Value.is_truthy left) then left, env
          else evaluate_expr b env in 
    value, env
  | Call (callee, _, arguments) -> 
    let (callee, env) = evaluate_expr callee state in
    let eval_args = List.map ~f:(fun a -> evaluate_expr a env |> (fun (a, _ ) -> a)) arguments in 
    match callee with 
    | Value.LoxFunction f -> 
      if List.length eval_args = f.arity 
        then (Value.call callee eval_args, env)
      else  raise (Lox_error.EvalError {expr}) 
    | _ ->  raise (Lox_error.EvalError {expr}) 

let rec evaluate_statement (statements: Statement.t list) (state: state) : state= 
  match statements with
  | [] -> state
  | hd:: tl -> (
      match hd with 
      | Statement.Expression (expr) -> 
        ignore (evaluate_expr expr state);
        evaluate_statement tl state
      | Statement.Print (expr) -> (
        let value, state = evaluate_expr expr state in 
        (Printf.printf "%s") (Value.to_string value);
        evaluate_statement tl state
      ) 
      | Statement.VarDeclaration {name; init;} -> (
        let value, state = 
          match init with
          | Some (v) -> evaluate_expr v state 
          | None -> LoxNil, state in 
        let env = Environment.assign state.env name value in 
        evaluate_statement tl {state with env = env}
      )
      | Statement.Block (b) -> (
        let local_scope = Environment.create_local state.env in 
        let _ = evaluate_statement b {state with env = local_scope} in 
        state
      )
      | Statement.If (condition, then_branch) -> 
        let _ = (
          if Value.is_truthy (evaluate_expr condition state |> (fun (expr, _) -> expr)) 
          then ignore (evaluate_statement [then_branch] state)) in 
        state
      | Statement.IfElse (condition, then_branch, else_branch) -> 
        let _ = (
          if Value.is_truthy (evaluate_expr condition state |> (fun (expr, _) -> expr)) 
          then ignore(evaluate_statement [then_branch] state)
          else ignore(evaluate_statement [else_branch] state)) in 
        state
      | Statement.While (condition, body) -> 
        ignore (interpret_while condition body state);
        state
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
        ignore (evaluate_statement [body] state);
        state
      | Statement.FunctionDeclaration (name, params, body) -> 
        let global_env = Environment.get_global state.env in 
        let func_env = Environment.create_local global_env in
        let call_func (args: Value.t list) : Value.t = 
          let closure = List.fold2 params args ~init:func_env ~f:(fun acc p a -> Environment.define acc p.lexeme a) in 
          let closure = match closure with 
          | Ok (e) -> e
          | Unequal_lengths -> Lox_error.too_few_arguments_supplied () in 
          try 
            ignore (evaluate_statement body {state with env = closure});
            Value.LoxNil 
          with 
            | Lox_error.ReturnError (v) -> v in 
        let env = Environment.define func_env name.lexeme (Value.LoxFunction {name = name.lexeme; arity = List.length params; callable = call_func}) in 
        {state with env = env}
      | Statement.Return (expr) -> 
        match expr with 
        | Some (e) -> 
          let (value, _) = evaluate_expr e state in 
          raise (Lox_error.ReturnError value)
        | None  -> raise (Lox_error.ReturnError Value.LoxNil)
  )

and interpret_while condition body env = 
  let (value, env) = evaluate_expr condition env in 
  if Value.is_truthy value then 
    let env = evaluate_statement [body] env in 
    ignore (interpret_while condition body env);
  else ()

and interpret tokens = 
  let statements = Parser.parse tokens in 
  evaluate_statement statements