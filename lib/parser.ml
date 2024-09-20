open Core

let matches tag tags = List.mem tag tags

let consume (tokens: Token.t list) (tag: Token.tag) (message: string) = 
  match tokens with 
  | hd :: tl when (Token.equal_tag hd.tag tag) -> (hd, tl)
  | hd :: _ -> raise Lox_error.(ParseError {line=hd.line;lexeme=hd.lexeme;message=message;})
  | [] ->  raise Lox_error.(ParseError {line=(-1); lexeme="EOF";message=message})

let rec primary (tokens:Token.t list) : (Expression.t * Token.t list)  =
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
    | Token.IDENTIFIER -> Expression.(Variable hd), tl
    | Token.FUN -> call tokens
    | _ ->  
      raise (Lox_error.(ParseError {line=hd.line; lexeme=hd.lexeme; message="Incorrect tag for primary expression"}))


and call (tokens: Token.t list): (Expression.t * Token.t list) =
  let (expr, rem_tokens) = primary tokens in 
    match rem_tokens with 
    (*TODO should this be recurive over while loop pg 148, needed for methods*)
    | hd :: tl when (Token.equal_tag hd.tag Token.LEFT_PAREN) -> 
      let (rem_tokens, arguments) = finish_call tl [] in 
      let (paren, rem_tokens) = consume rem_tokens Token.RIGHT_PAREN "Expect ')' after arguments" in 
      (Expression.Call (expr, paren, arguments), rem_tokens)
    | _ -> (expr, rem_tokens) 

and finish_call (tokens: Token.t list) (arguments: Expression.t list) : Token.t list * Expression.t list = 
  match tokens with 
  | hd :: tl when (Token.equal_tag hd.tag Token.RIGHT_PAREN) -> (hd :: tl), (List.rev arguments)
  | _ -> 
    let (argument, rem_tokens) = expression tokens in 
    match rem_tokens with 
    | hd :: tl when Token.equal_tag hd.tag Token.COMMA -> 
      if (List.length arguments) >= 255 then Lox_error.too_many_arguments ();
      finish_call tl (argument :: arguments)
    | _ -> 
      if (List.length arguments) >= 255 then Lox_error.too_many_arguments ();
      finish_call rem_tokens (argument:: arguments)

and unary (tokens: Token.t list): (Expression.t * Token.t list) =
  match tokens with 
  | hd :: tl when (Token.equal_tag hd.tag Token.BANG) -> 
    let right, rem_tokens  = unary tl in 
    (Unary (hd, right), rem_tokens)
  | hd :: tl when (Token.equal_tag hd.tag Token.MINUS) -> 
    let right, rem_tokens  = unary tl in 
    (Unary (hd, right), rem_tokens)
  | _ -> call tokens

and factor (tokens: Token.t list) : (Expression.t * Token.t list) = 
  let ops = [Token.SLASH; Token.STAR;] in 
  binary ops unary tokens

and term (tokens: Token.t list) : (Expression.t * Token.t list) = 
  let ops = [Token.MINUS; Token.PLUS;] in 
  binary ops factor tokens

and comparison (tokens: Token.t list) : (Expression.t * Token.t list) = 
  let ops = [Token.GREATER; Token.GREATER_EQUAL; Token.LESS; Token.LESS_EQUAL] in 
  binary  ops term tokens

and equality (tokens: Token.t list) : (Expression.t * Token.t list) = 
  let ops = [Token.BANG_EQUAL; Token.EQUAL_EQUAL] in 
  binary ops comparison tokens

and binary (ops: Token.tag list) (prec_func) (tokens: Token.t list) : (Expression.t * Token.t list) = 
  let rec binary_  (ops: Token.tag list) expr (prec_func) (tokens: Token.t list) : (Expression.t * Token.t list) = 
    match tokens with 
    | hd :: tl -> 
      if (List.mem ops hd.tag ~equal:(Token.equal_tag)) then 
        let (right, rem_tokens) = prec_func tl  in
        let expr = Expression.BinaryOp (expr, hd, right) in
        binary_ ops expr prec_func rem_tokens
      else
        expr, tokens
    | _ -> expr, tokens in 
  let (left, rem_tokens) = prec_func tokens in 
  binary_ ops left prec_func rem_tokens

and logical (ops: Token.tag list) (prec_func) (tokens: Token.t list) : (Expression.t * Token.t list) = 
  let rec logical_  (ops: Token.tag list) expr (prec_func) (tokens: Token.t list) : (Expression.t * Token.t list) = 
    match tokens with 
    | hd :: tl -> 
      if (List.mem ops hd.tag ~equal:(Token.equal_tag)) then 
        let (right, rem_tokens) = prec_func tl  in
        let expr = Expression.Logical (expr, hd, right) in
        logical_ ops expr prec_func rem_tokens
      else
        expr, tokens
    | _ -> expr, tokens in 
  let (left, rem_tokens) = prec_func tokens in 
  logical_ ops left prec_func rem_tokens

and logical_and (tokens: Token.t list) : (Expression.t * Token.t list) = 
  let ops = [Token.AND;] in 
  logical ops equality tokens

and logical_or (tokens: Token.t list) : (Expression.t * Token.t list) = 
  let ops = [Token.OR;] in 
  logical ops logical_and tokens
  
and assignment (tokens: Token.t list): (Expression.t * Token.t list) = 
  let (left, rem_tokens) = logical_or tokens in
  match (left, rem_tokens) with 
  | (Expression.Variable (v), hd::tl) when (Token.equal_tag hd.tag Token.EQUAL) -> 
    let (value, rem_tokens) = assignment tl in 
    (Expression.Assignment (v, value), rem_tokens)
  | (_, _) -> (left, rem_tokens)

and expression tokens = assignment tokens

type eval_result = (Value.t, Expression.t) result

let rec statements (tokens: Token.t list) (stmts: Statement.t list)  = 
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
      | Token.PRINT -> print_statement tl
      | Token.VAR -> var_declaration tl
      | Token.LEFT_BRACE -> block tl []
      | Token.IF -> if_statement tl
      | Token.FUN -> function_statement tl "function"
      | Token.RETURN -> return_statement tl
      | Token.FOR -> for_statement tl
      | Token.WHILE -> while_statement tl
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
    | hd :: tl when (Token.equal_tag hd.tag Token.EQUAL) -> expression tl |> (fun (i, r) -> ((Some i), r))
    | _ -> None, rem_tokens in 
  let (_, rem_tokens)  = consume rem_tokens Token.SEMICOLON "Expect variable name" in 
  (Statement.VarDeclaration {name = name; init=init; }, rem_tokens)

and block (tokens: Token.t list) (stmts: Statement.t list) = 
  match tokens with 
  | hd :: _ when (not (Token.equal_tag hd.tag Token.RIGHT_BRACE)) -> 
    let (stmt, rem_tokens) = declaration tokens in 
    block rem_tokens (stmt :: stmts)
  | hd :: tl when (Token.equal_tag hd.tag Token.RIGHT_BRACE) ->
    (Statement.Block (List.rev stmts), tl)
    | hd :: _ -> Lox_error.parse_error_from_token hd "Expect '}' after block"
    | [] -> Lox_error.out_of_tokens () 

and declaration (tokens: Token.t list) = 
  match tokens with
  | [] -> raise Lox_error.(RunTimeError ("declaration", "no tokens supplied"))
  | hd :: tl when Token.equal_tag hd.tag Token.VAR -> var_declaration tl
  | hd :: tl when Token.equal_tag hd.tag Token.FUN -> function_statement tl "function"
  | _ -> statement tokens

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
        collect_parameters rem_tokens (parameters @ [parameter])
    | _  -> (parameters, tokens) in 

  let (parameters, rem_tokens) = 
    consume rem_tokens Token.IDENTIFIER message 
    |> (fun (p, t) -> collect_parameters t [p]) in 

  let (_, rem_tokens) =
    (Printf.sprintf "Expect ')' after parameters")
    |> consume rem_tokens Token.RIGHT_PAREN   in 

  let (_, rem_tokens) = 
  (Printf.sprintf "Expect '{' after parameters declared") 
  |> consume rem_tokens Token.LEFT_BRACE   in 

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
  
  
let parse tokens = 
  let statements, _ = statements tokens [] in
  List.rev statements

(* let%test "function_call" = 
  ignore (
    let text = "
    print 1 + 2 + 3;
    " in 
    let tokens = Lexer.scan_text text in 
    Token.print_tokens tokens;
    let stmts = parse tokens in
    Statement.print_statements stmts;
  );
  true  *)