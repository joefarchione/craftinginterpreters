open Core

let (let*) = Result.bind
let matches tag tags = List.mem tag tags

let consume (tokens: Token.t list) (tag: Token.tag) (message: string) = 
  match tokens with 
  | hd :: tl when (Token.equal_tag hd.tag tag) -> (hd, tl)
  | hd :: _ -> raise (Lox_error.ParseError Lox_error.{line=hd.line;lexeme=hd.lexeme;message=message;})
  | [] ->  raise (Lox_error.ParseError Lox_error.{line=(-1); lexeme="EOF";message=message})

let rec evaluate_expr (expr: Expression.t) (env: Environment.t): Value.t * Environment.t = 
  match expr with 
  | Literal (l) ->  l, env
  | BinaryOp (a, o, b) ->  (
    let left, env  = evaluate_expr a env in 
    let right, env = evaluate_expr b env in 
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
    value, env
  )
  | Unary (o, a) -> (
    let right, env  = evaluate_expr a env in 
    let value = 
      match o with 
      | Bang -> Value.LoxBool (Value.is_truthy right)
      | Minus -> Value.LoxNumber (-1.0 *. (Value.float_of right))
      | _ -> raise (Lox_error.EvalError {expr}) in 
    value, env
  )
  | Grouping (e) -> (evaluate_expr e env)
  | Variable (v) -> Environment.get env v, env
  | Assignment (token, expr) -> 
      let value, env = evaluate_expr expr env in 
      let env = Environment.assign env token value in 
      value, env
  | Logical (a, o, b) -> 
    let (left, env) = evaluate_expr a env in
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
    let (callee, env) = evaluate_expr callee env in
    let eval_args = List.map ~f:(fun a -> evaluate_expr a env |> (fun (a, _ ) -> a)) arguments in 
    match callee with 
    | Value.LoxFunction f -> 
      if List.length eval_args = f.arity 
        then (Value.call callee eval_args, env)
      else  raise (Lox_error.EvalError {expr}) 
    | _ ->  raise (Lox_error.EvalError {expr}) 


and primary (tokens:Token.t list) : (Expression.t * Token.t list)  =
  match tokens with 
  | [] -> Lox_error.out_of_tokens ()
  | hd :: tl -> 
    match hd.tag with 
    | Token.FALSE 
    | Token.TRUE 
    | Token.NIL 
    | Token.STRING 
    | Token.NUMBER -> (Expression.(Literal hd.literal), tl)
    | Token.LEFT_PAREN -> (
      let (exprs, rem_tokens) = expression tl in 
      let (_, rem_tokens) = consume rem_tokens RIGHT_PAREN "Expect ')' after expression" in 
      (Expression.(Grouping exprs), rem_tokens)
    )
    | Token.VAR -> (Expression.(Variable hd), tl)
    | Token.FUN -> call tokens
    | _ ->  Lox_error.parse_error_from_token hd "Could not match literal tag"


and call (tokens: Token.t list): (Expression.t * Token.t list) =
  let (expr, rem_tokens) = primary tokens in 
  let (rem_tokens, arguments) = 
    match rem_tokens with 
    (*TODO should this be recurive over while loop pg 148, needed for methods*)
    | hd :: tl when (Token.equal_tag hd.tag Token.LEFT_PAREN) -> finish_call tl [] 
    | _ -> (rem_tokens, [expr]) in 
  let (paren, rem_tokens) = consume rem_tokens Token.RIGHT_PAREN "Expect ')' after arguments" in
  (Expression.Call (expr, paren, arguments), rem_tokens)

and finish_call (tokens: Token.t list) (arguments: Expression.t list) = 
  match tokens with 
  | hd :: tl when (Token.equal_tag hd.tag Token.RIGHT_PAREN) -> tl, arguments
  | _ -> 
    let (argument, rem_tokens) = expression tokens in 
    match rem_tokens with 
    | hd :: tl when Token.equal_tag hd.tag Token.COMMA -> 
      if (List.length arguments) >= 255 then Lox_error.too_many_arguments ();
      finish_call tl (argument :: arguments)
    | _ -> 
      let (_, rem_tokens) = consume rem_tokens Token.RIGHT_PAREN "Expect ')' after arguments" in 
      rem_tokens, arguments


and unary (tokens: Token.t list): (Expression.t * Token.t list) =
  match tokens with 
  | hd :: tl when (Token.equal_tag hd.tag Token.BANG) -> 
    let right, rem_tokens  = unary tl in 
    (Unary (Bang, right), rem_tokens)
  | hd :: tl when (Token.equal_tag hd.tag Token.MINUS) -> 
    let right, rem_tokens  = unary tl in 
    (Unary (Minus, right), rem_tokens)
  | _ -> call tokens

and factor (tokens: Token.t list) : (Expression.t * Token.t list) = 
  let (left, rem_tokens) = unary tokens in 
  match rem_tokens with 
  | hd :: tl when (Token.equal_tag hd.tag Token.SLASH) -> 
      let (right, rem_tokens) = unary tl in 
      (BinaryOp (left, Slash, right), rem_tokens)
  | hd :: tl when (Token.equal_tag hd.tag Token.STAR) -> 
      let (right, rem_tokens) = unary tl in 
      (BinaryOp (left, Star, right), rem_tokens)
  | _ -> (left, rem_tokens)


and term (tokens: Token.t list) : (Expression.t * Token.t list) = 
  let (left, rem_tokens) = factor tokens in 
  match rem_tokens with 
  | hd :: tl when (Token.equal_tag hd.tag Token.MINUS) -> 
      let (right, rem_tokens) = factor tl in 
      (BinaryOp (left, Minus, right), rem_tokens)
  | hd :: tl when (Token.equal_tag hd.tag Token.PLUS) -> 
      let (right, rem_tokens) = factor tl in 
      (BinaryOp (left, Plus, right), rem_tokens)
  | _ -> (left, rem_tokens)

and comparison (tokens: Token.t list) : (Expression.t * Token.t list) = 
  let (left, rem_tokens) = term tokens in 
  match rem_tokens with 
  | hd :: tl when (Token.equal_tag hd.tag Token.GREATER) -> 
      let (right, rem_tokens) = term tl in 
      (BinaryOp (left, Greater, right), rem_tokens)
  | hd :: tl when (Token.equal_tag hd.tag Token.GREATER_EQUAL) -> 
      let (right, rem_tokens) = term tl in 
      (BinaryOp (left, Greater_equal, right), rem_tokens)
  | hd :: tl when (Token.equal_tag hd.tag Token.LESS) -> 
      let (right, rem_tokens) = term tl in 
      (BinaryOp (left, Less, right), rem_tokens)
  | hd :: tl when (Token.equal_tag hd.tag Token.LESS_EQUAL) -> 
      let (right, rem_tokens) = term tl in 
      (BinaryOp (left, Less_equal, right), rem_tokens)
  | _ -> (left, rem_tokens)


and equality (tokens: Token.t list) : (Expression.t * Token.t list) = 
  let (left, rem_tokens) = comparison tokens in 
  match rem_tokens with 
  | hd :: tl when (Token.equal_tag hd.tag Token.EQUAL_EQUAL) -> 
      let (right, rem_tokens) = comparison tl in 
      (BinaryOp (left, Equal_equal, right), rem_tokens)
  | hd :: tl when (Token.equal_tag hd.tag Token.BANG_EQUAL) -> 
      let (right, rem_tokens) = comparison tl in 
      (BinaryOp (left, Bang_equal, right), rem_tokens)
  | _  -> (left, rem_tokens)

and logical_and (tokens: Token.t list) : (Expression.t * Token.t list) = 
  let (left, rem_tokens) = equality tokens in 
  match rem_tokens with 
  | hd :: tl when Token.equal_tag hd.tag Token.EQUAL -> 
    let (right, rem_tokens) = equality tl in 
      (Logical (left, Expression.And, right), rem_tokens)
  | _  -> (left, rem_tokens)

and logical_or (tokens: Token.t list) : (Expression.t * Token.t list) = 
  let (left, rem_tokens) = logical_and tokens in 
  match rem_tokens with 
  | hd :: tl when Token.equal_tag hd.tag Token.OR -> 
    let (right, rem_tokens) = logical_and tl in 
      (Logical (left, Expression.Or, right), rem_tokens)
  | _  -> (left, rem_tokens)
  
and assignment (tokens: Token.t list): (Expression.t * Token.t list) = 
  let (left, rem_tokens) = logical_or tokens in
  match (left, rem_tokens) with 
  | (Expression.Variable (v), hd::tl) when (Token.equal_tag hd.tag Token.EQUAL) -> 
    let (value, rem_tokens) = assignment tl in 
    (Expression.Assignment (v, value), rem_tokens)
  | (_, _) -> (left, rem_tokens)

and expression tokens = equality tokens

type eval_result = (Value.t, Expression.t) result

let rec evaluate_statement (statements: Statement.t list) (env: Environment.t) : Environment.t  = 
  match statements with
  | [] -> env
  | hd:: tl -> (
      match hd with 
      | Statement.Expression (expr) -> 
        ignore (evaluate_expr expr env);
        evaluate_statement tl env
      | Statement.Print (expr) -> (
        let value, env = evaluate_expr expr env in 
        (Printf.printf "%s") (Value.to_string value);
        evaluate_statement tl env
      ) 
      | Statement.VarDeclaration {name; init;} -> (
        let value, env = evaluate_expr init env in 
        let env = Environment.assign env name value in 
        evaluate_statement tl env
      )
      | Statement.Block (b) -> (
        let local_scope = Environment.create_local env in 
        let _ = evaluate_statement b local_scope in 
        env
      )
      | Statement.If (condition, then_branch) -> 
        let _ = (
          if Value.is_truthy (evaluate_expr condition env |> (fun (expr, _) -> expr)) 
          then ignore (evaluate_statement [then_branch] env)) in 
        env
      | Statement.IfElse (condition, then_branch, else_branch) -> 
        let _ = (
          if Value.is_truthy (evaluate_expr condition env |> (fun (expr, _) -> expr)) 
          then ignore(evaluate_statement [then_branch] env)
          else ignore(evaluate_statement [else_branch] env)) in 
        env
      | Statement.While (condition, body) -> 
        ignore (interpret_while condition body env);
        env
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
        ignore (evaluate_statement [body] env);
        env
      | Statement.FunctionDeclaration (name, params, body) -> 
        let global_env = Environment.get_global env in 
        let func_env = Environment.create_local global_env in
        let call_func (args: Value.t list) : Value.t = 
          let closure = List.fold2 params args ~init:func_env ~f:(fun acc p a -> Environment.define acc p.lexeme a) in 
          let closure = match closure with 
          | Ok (e) -> e
          | Unequal_lengths -> Lox_error.too_few_arguments_supplied () in 
          try 
            ignore (evaluate_statement body closure);
            Value.LoxNil 
          with 
            | Lox_error.ReturnError (v) -> v in 
        let env = Environment.define func_env name.lexeme (Value.LoxFunction {name = name.lexeme; arity = List.length params; callable = call_func}) in 
        env
      | Statement.Return (expr) -> 
        match expr with 
        | Some (e) -> 
          let (value, _) = evaluate_expr e env in 
          raise (Lox_error.ReturnError value)
        | None  -> raise (Lox_error.ReturnError Value.LoxNil)
  )

and statements (tokens: Token.t list) (stmts: Statement.t list)  = 
  match tokens with
  | [] -> (stmts, tokens)
  | _ -> 
    let (stmt, rem_tokens) = statement tokens in 
    statements rem_tokens (stmt :: stmts)

and statement (tokens: Token.t list)  = 
  match tokens with
  | [] -> Lox_error.out_of_tokens ()
  | hd :: tl  -> 
    let (stmt, rem_tokens) = 
      match hd.tag with
      | Token.PRINT
      | Token.VAR -> var_declaration tl
      | Token.LEFT_BRACE -> block tl []
      | Token.IF -> if_statement tl
      | Token.FUN -> function_statement tl "function"
      | Token.RETURN -> return_statement tl
      | _ -> expression_statement tokens in
    stmt, rem_tokens

and print_statement (tokens: Token.t list) =
  let (value, rem_tokens) = expression tokens in
  let (_, rem_tokens) = consume rem_tokens Token.SEMICOLON "Expect ';' after value" in 
  (Statement.Print value, rem_tokens)

and expression_statement (tokens: Token.t list) =
  let (value, rem_tokens) = expression tokens in
  let (_, rem_tokens) = consume rem_tokens Token.SEMICOLON "Expect ';' after value" in 
  (Statement.Expression value, rem_tokens)

and var_declaration (tokens: Token.t list) = 
  let (name, rem_tokens)  = consume tokens Token.IDENTIFIER "Expect variable name" in 
  let (init, rem_tokens) = 
    match rem_tokens with 
    | hd :: tl when (Token.equal_tag hd.tag Token.EQUAL) -> expression tl
    | hd :: _ -> Lox_error.parse_error_from_token hd "Expected '=' after variable name"
    | [] -> Lox_error.out_of_tokens () in
  let (_, rem_tokens)  = consume rem_tokens Token.SEMICOLON "Expect variable name" in 
  (Statement.VarDeclaration {name = name; init=init; }, rem_tokens)

and block (tokens: Token.t list) (stmts: Statement.t list) = 
  match tokens with 
  | hd :: tl when (not (Token.equal_tag hd.tag Token.RIGHT_BRACE)) -> 
    let (stmt, rem_tokens) = var_declaration tl in 
    block rem_tokens (stmt :: stmts)
  | hd :: tl when (Token.equal_tag hd.tag Token.RIGHT_BRACE) ->
    (Statement.Block stmts, tl)
    | hd :: _ -> Lox_error.parse_error_from_token hd "Expect '}' after block"
    | [] -> Lox_error.out_of_tokens () 

and if_statement (tokens: Token.t list) = 
  let (_, rem_tokens) = consume tokens Token.LEFT_PAREN "Expect '(' after 'if'" in
  let (condition, rem_tokens) = expression rem_tokens in 
  let (_, rem_tokens) = consume rem_tokens Token.RIGHT_PAREN "Expect ')' after 'if'" in
  let (then_branch, rem_tokens) = statement rem_tokens in 

  match rem_tokens with 
  | hd::tl when (Token.equal_tag hd.tag Token.ELSE) -> 
    let (else_branch, rem_tokens) = statement tl in 
    (Statement.IfElse (condition, then_branch, else_branch), rem_tokens)
  | _ -> (Statement.If (condition, then_branch), rem_tokens)

and while_statement (tokens: Token.t list) = 
  let (_, rem_tokens) = consume tokens Token.LEFT_PAREN "Expect '(' after 'while'" in 
  let (condition, rem_tokens) = expression rem_tokens in 
  let (_, rem_tokens) = consume rem_tokens Token.RIGHT_PAREN "Expect ')' after 'while'" in 
  let (body, rem_tokens) = statement rem_tokens in 
  (Statement.While (condition, body)), rem_tokens

and for_statement (tokens: Token.t list): Statement.t * Token.t list = 
  let (_, rem_tokens) = consume tokens Token.LEFT_PAREN "Expect '(' after 'for'" in 

  let a_b_to_somea_b (a,b) = Some a, b in 

  let (init, rem_tokens) = 
    match rem_tokens with 
    | hd :: tl when Token.equal_tag hd.tag Token.SEMICOLON -> None, tl
    | hd :: tl when Token.equal_tag hd.tag Token.VAR -> 
      var_declaration tl |> a_b_to_somea_b
    | _ -> expression_statement rem_tokens |> a_b_to_somea_b in

  let (condition, rem_tokens) = 
    match rem_tokens with 
    | hd :: _ when not (Token.equal_tag hd.tag Token.SEMICOLON) -> 
      expression rem_tokens |> a_b_to_somea_b
    | _ -> None, rem_tokens in

  let (_, rem_tokens) = consume rem_tokens Token.SEMICOLON "Expect ';' after loop condition" in 

  let (increment, rem_tokens) = 
    match rem_tokens with 
    | hd :: _ when not (Token.equal_tag hd.tag Token.RIGHT_PAREN) -> 
      expression tokens|> a_b_to_somea_b
    | _ -> None, rem_tokens in 

  let (_, rem_tokens) = consume rem_tokens Token.RIGHT_PAREN "Expect ')' after for clauses" in 

  let (body, rem_tokens) = statement rem_tokens in 
  (Statement.For (init, condition, increment, body)), rem_tokens

and function_statement (tokens: Token.t list) (kind: string): (Statement.t * Token.t list) =
  let message = (Printf.sprintf "Expect %s name") kind in 
  let (name, rem_tokens) = consume tokens Token.IDENTIFIER message in 
  let message = (Printf.sprintf "Expect '(' after %s name") kind in 
  let (_, rem_tokens) = consume rem_tokens Token.LEFT_PAREN message in 

  let rec collect_parameters (tokens: Token.t list) (parameters: Token.t list) = 
    match tokens with 
    | hd :: tl when (Token.equal_tag hd.tag Token.COMMA) -> 
        if List.length parameters >= 255 then Printf.printf "Can't have more than 255 parameters";
        let (parameter, rem_tokens) = consume tl Token.IDENTIFIER message in 
        collect_parameters rem_tokens (parameter::parameters)
    | _  -> (parameters, rem_tokens) in 

  let (parameters, rem_tokens) = 
    consume rem_tokens Token.IDENTIFIER message 
    |> (fun (p, t) -> collect_parameters t [p]) in 

  let message = (Printf.sprintf "Expect ')' after parameters") in 
  let (_, rem_tokens) = consume rem_tokens Token.RIGHT_PAREN message  in 
  let message = (Printf.sprintf "Expect '{' after parameters") in 
  let (_, rem_tokens) = consume rem_tokens Token.LEFT_BRACE message  in 
  let (body, rem_tokens) = block rem_tokens [] in 
  let body = match body with | Statement.Block (b) -> b | _ -> [body;] in 
  Statement.FunctionDeclaration (name, parameters, body), rem_tokens

and return_statement (tokens: Token.t list) : (Statement.t * Token.t list) =
  let (expr, rem_tokens)  = 
    match tokens with
    | hd :: tl when Token.equal_tag hd.tag Token.SEMICOLON -> None, tl
    | _ -> expression tokens |> (fun (e, t) -> Some e, t) in 

  let message = (Printf.sprintf "Expect ';' after return value") in 
  let (_, rem_tokens) = consume rem_tokens Token.SEMICOLON message  in 
  Statement.Return expr, rem_tokens

and interpret_while condition body env = 
  let (value, env) = evaluate_expr condition env in 
  if Value.is_truthy value then 
    let env = evaluate_statement [body] env in 
    ignore (interpret_while condition body env);
  else ()

and interpret tokens = 
  let statements, _ = statements tokens [] in 
  evaluate_statement statements

let rec synchronize (tokens: Token.t list) = 
  match tokens with 
  | [] -> []
  | hd :: tl  -> 
    match hd.tag with 
    | Token.SEMICOLON -> tokens
    | Token.CLASS
    | Token.FUN
    | Token.VAR
    | Token.FOR
    | Token.IF
    | Token.WHILE
    | Token.PRINT
    | Token.RETURN -> tokens
    | _ -> synchronize tl
  

