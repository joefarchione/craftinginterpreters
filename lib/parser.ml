open Core

let (let*) = Result.bind
let matches tag tags = List.mem tag tags

let consume (tokens: Token.t list) (tag: Token.tag) (message: string) = 
  match tokens with 
  | hd :: tl when (Token.equal_tag hd.tag tag) -> (hd, tl)
  | _ -> failwith message
     
let rec primary (tokens:Token.t list) : (Expression.t * Token.t list)  =
  match tokens with 
  | [] -> failwith "incorrect token"
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
    | _ ->  failwith "incorrect token" 

and unary (tokens: Token.t list): (Expression.t * Token.t list) =
  match tokens with 
  | hd :: tl when (Token.equal_tag hd.tag Token.BANG) -> 
    let right, rem_tokens  = unary tl in 
    (Unary (Bang, right), rem_tokens)
  | hd :: tl when (Token.equal_tag hd.tag Token.MINUS) -> 
    let right, rem_tokens  = unary tl in 
    (Unary (Minus, right), rem_tokens)
  | _ -> primary tokens

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

let rec evaluate (expr: Expression.t) (env: Environment.t): Value.t * Environment.t = 
  match expr with 
  | Literal (l) ->  l, env
  | BinaryOp (a, o, b) ->  (
    let left, env  = evaluate a env in 
    let right, env = evaluate b env in 
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
      | _ -> failwith "incorrect" in 
    value, env
  )
  | Unary (o, a) -> (
    let right, env  = evaluate a env in 
    let value = 
      match o with 
      | Bang -> Value.LoxBool (Value.is_truthy right)
      | Minus -> Value.LoxNumber (-1.0 *. (Value.float_of right))
      | _ -> failwith "incorrect" in 
    value, env
  )
  | Grouping (e) -> (evaluate e env)
  | Variable (v) -> Environment.get env v, env
  | Assignment (token, expr) -> 
      let value, env = evaluate expr env in 
      let env = Environment.assign env token value in 
      value, env
  | Logical (a, o, b) -> 
    let (left, env) = evaluate a env in
    match o with 
      | And -> 
        if not (Value.is_truthy left) then left, env
        else evaluate b env
      | Or -> 
        if (Value.is_truthy left) then left, env
        else evaluate b env

let rec statements (tokens: Token.t list) (stmts: Statement.t list)  = 
  match tokens with
  | [] -> (stmts, tokens)
  | _ -> 
    let (stmt, rem_tokens) = statement tokens in 
    statements rem_tokens (stmt :: stmts)

and statement (tokens: Token.t list)  = 
  match tokens with
  | [] -> failwith "incorrect"
  | hd :: tl  -> 
    let (stmt, rem_tokens) = 
      match hd.tag with
      | Token.PRINT -> print_statement tl
      | Token.VAR -> var_declaration tl
      | Token.LEFT_BRACE -> block tl []
      | Token.IF -> if_statement tl
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
    | _ -> failwith "not a match" in 
  let (_, rem_tokens)  = consume rem_tokens Token.SEMICOLON "Expect variable name" in 
  (Statement.Var {name = name; init=init; }, rem_tokens)

and block (tokens: Token.t list) (stmts: Statement.t list) = 
  match tokens with 
  | hd :: tl when (not (Token.equal_tag hd.tag Token.RIGHT_BRACE)) -> 
    let (stmt, rem_tokens) = var_declaration tl in 
    block rem_tokens (stmt :: stmts)
  | hd :: tl when (Token.equal_tag hd.tag Token.RIGHT_BRACE) ->
    (Statement.Block stmts, tl)
  | _ -> failwith "Expect '}' after block"

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

and for_statement (tokens: Token.t list) = 
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

let rec interpret (statements: Statement.t list) (env: Environment.t) : Environment.t  = 
  match statements with
  | [] -> env
  | hd:: tl -> (
      match hd with 
      | Statement.Expression (expr) -> 
        ignore (evaluate expr env);
        interpret tl env
      | Statement.Print (expr) -> (
        let value, env = evaluate expr env in 
        (Printf.printf "%s") (Value.to_string value);
        interpret tl env
      ) 
      | Statement.Var {name; init;} -> (
        let value, env = evaluate init env in 
        let env = Environment.assign env name value in 
        interpret tl env
      )
      | Statement.Block (b) -> (
        let local_scope = Environment.create_local env in 
        let _ = interpret b local_scope in 
        env
      )
      | Statement.If (condition, then_branch) -> 
        let _ = (
          if Value.is_truthy (evaluate condition env |> (fun (expr, _) -> expr)) 
          then ignore (interpret [then_branch] env)) in 
        env
      | Statement.IfElse (condition, then_branch, else_branch) -> 
        let _ = (
          if Value.is_truthy (evaluate condition env |> (fun (expr, _) -> expr)) 
          then ignore(interpret [then_branch] env)
          else ignore(interpret [else_branch] env)) in 
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
        ignore (interpret [body] env);
        env
  )

and interpret_while condition body env = 
  let (value, env) = evaluate condition env in 
  if Value.is_truthy value then 
    let env = interpret [body] env in 
    ignore (interpret_while condition body env);
  else ()

(* TODO implement syncrhonize parser to catch error result types and then move to the next key word type*)
let parse tokens = 
  let statements, _ = statements tokens [] in 
  interpret statements

  

