open Core

let matches tag tags = List.mem tag tags

let consume (tag: Token.tag) (message: string) (tokens: Token.t list)  = 
  match tokens with 
  | hd :: tl when (Token.equal_tag hd.tag tag) -> (hd, tl)
  | hd :: _ -> raise Lox_error.(ParseError {line=hd.line;lexeme=hd.lexeme;message=message;})
  | [] ->  raise Lox_error.(ParseError {line=(-1); lexeme="EOF";message=message})

let consume_some_identifier  (tokens: Token.t list)  = 
  match tokens with 
  | hd :: tl when (Token.equal_tag hd.tag Token.IDENTIFIER) -> (Some hd, tl)
  | _ -> None, tokens 

let rec primary (tokens:Token.t list) : (Expression.t * Token.t list)  =
  match tokens with 
  | []  -> Lox_error.out_of_tokens ()
  | hd :: tl -> 
    match hd.tag with 
    | Token.FALSE 
    | Token.TRUE 
    | Token.NIL 
    | Token.STRING 
    | Token.NUMBER -> (Expression.(Literal hd.literal), tl)
    | Token.LEFT_PAREN -> (
      let (exprs, rem_tokens) = expression tl in 
      let (_, rem_tokens) = consume  RIGHT_PAREN "Expect ')' after expression" rem_tokens in 
      (Expression.(Grouping exprs), rem_tokens)
    )
    | Token.THIS -> Expression.This (hd), tl
    | Token.IDENTIFIER -> Expression.(Variable hd), tl
    | Token.FUN -> call tokens
    | Token.SUPER -> (
      let (_, rem_tokens) = consume  DOT "Expect '.' after super" tl in 
      let (loxmethod, rem_tokens) = consume  IDENTIFIER "Expect superclass method name" rem_tokens in 
      (Expression.Super (hd, loxmethod), rem_tokens)
    )
    | _ ->  
      raise (Lox_error.(ParseError {line=hd.line; lexeme=hd.lexeme; message="Expected expression"}))


and call (tokens: Token.t list): (Expression.t * Token.t list) =
  let rec call_or_get (expr: Expression.t) (tokens: Token.t list) = 
    match tokens with 
    | hd :: tl when (Token.equal_tag hd.tag Token.LEFT_PAREN) -> 
      let (rem_tokens, arguments) = finish_call tl [] in 
      let (paren, rem_tokens) = consume Token.RIGHT_PAREN "Expect ')' after arguments" rem_tokens in 
      let expr = Expression.Call (expr, paren, arguments) in 
      call_or_get expr rem_tokens
    | hd :: tl when (Token.equal_tag hd.tag Token.DOT) -> 
      let (name, rem_tokens) = consume Token.IDENTIFIER "Expect property name after '." tl in 
      let expr = Expression.Get (expr, name) in 
      call_or_get expr rem_tokens
    | _ -> (expr, tokens) in 

  let (expr, rem_tokens) = primary tokens in 
  call_or_get expr rem_tokens

and finish_call (tokens: Token.t list) (arguments: Expression.t list) : Token.t list * Expression.t list = 
  match tokens with 
  | hd :: tl when (Token.equal_tag hd.tag Token.RIGHT_PAREN) -> (hd :: tl), (List.rev arguments)
  | _ -> 
    let (argument, rem_tokens) = expression tokens in 
    match rem_tokens with 
    | hd :: tl when Token.equal_tag hd.tag Token.COMMA -> 
      if (List.length arguments) >= 255 then (
        raise Lox_error.(TooManyArgumentsSupplied (Printf.sprintf "Can't have more than 255 arguments"))
      )
      else
      finish_call tl (argument :: arguments)
    | _ -> 
      if (List.length arguments) >= 255 then (
        raise Lox_error.(TooManyArgumentsSupplied (Printf.sprintf "Can't have more than 255 arguments"))
      )
      else
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
  | (Expression.Get (name, token), hd::tl) when (Token.equal_tag hd.tag Token.EQUAL) -> (
    let (value, rem_tokens) = assignment tl in 
    (Expression.Set (name, token, value), rem_tokens)
  )
  | (_, hd::_) when (Token.equal_tag hd.tag Token.EQUAL) -> (
      raise Lox_error.(RunTimeError (Printf.sprintf "Invalid assignment target '%s'" (Expression.show left), ""))
  )
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
      | Token.CLASS -> class_declaration tl
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
  let (_, rem_tokens) = consume  Token.SEMICOLON "Expect ';' after value" rem_tokens in 
  (Statement.Print value, rem_tokens)

and expression_statement (tokens: Token.t list) =
  let (value, rem_tokens) = expression tokens in
  let (_, rem_tokens) = consume  Token.SEMICOLON "Expect ';' after value" rem_tokens in 
  (Statement.Expression value, rem_tokens)

and var_declaration (tokens: Token.t list) = 
  let (name, rem_tokens)  = consume  Token.IDENTIFIER "Expect variable name" tokens in 
  let (init, rem_tokens) = 
    match rem_tokens with 
    | hd :: tl when (Token.equal_tag hd.tag Token.EQUAL) -> expression tl |> (fun (i, r) -> ((Some i), r))
    | _ -> None, rem_tokens in 
  let (_, rem_tokens)  = consume  Token.SEMICOLON "Expect variable name" rem_tokens in 
  (Statement.VarDeclaration {name = name; init=init; }, rem_tokens)

and block (tokens: Token.t list) (stmts: Statement.t list) = 
  match tokens with 
  | hd :: _ when (not (Token.equal_tag hd.tag Token.RIGHT_BRACE)) -> 
    let (stmt, rem_tokens) = declaration tokens in 
    block rem_tokens (stmt :: stmts)
  | hd :: tl when (Token.equal_tag hd.tag Token.RIGHT_BRACE) ->
    (Statement.Block (List.rev stmts), tl)
    | hd :: _ -> raise Lox_error.(ParseError {line=hd.line; lexeme=hd.lexeme; message="Expect '}' after block"})
    | [] -> Lox_error.out_of_tokens () 

and declaration (tokens: Token.t list) = 
  match tokens with
  | [] -> raise Lox_error.(RunTimeError ("declaration", "no tokens supplied"))
  | hd :: tl when Token.equal_tag hd.tag Token.VAR -> var_declaration tl
  | hd :: tl when Token.equal_tag hd.tag Token.FUN -> function_statement tl "function"
  | hd :: tl when Token.equal_tag hd.tag Token.CLASS -> class_declaration tl 
  | _ -> statement tokens

and class_declaration (tokens: Token.t list)  = 
  let (name, rem_tokens) = consume  Token.IDENTIFIER "Expect class name" tokens in 

  let (superclass, rem_tokens) = 
    match rem_tokens with 
    | hd :: tl when Token.equal_tag hd.tag Token.LESS -> 
      consume Token.IDENTIFIER "Expect superclass name" tl
      |> (fun (a,b) -> (Some (Expression.Variable(a)), b))
    | _ -> None, rem_tokens in 

  let (_, rem_tokens) = consume  Token.LEFT_BRACE "Expect '{' before class body" rem_tokens in 

  let (methods, rem_tokens) = take_class_methods rem_tokens [] in 
  (Statement.ClassDeclaration (name, superclass, methods), rem_tokens)

and take_class_methods (tokens: Token.t list) (methods: Statement.t list) = 
    match tokens with 
    | hd :: _ when not (Token.equal_tag hd.tag Token.RIGHT_BRACE) -> 
      let (stmt, rem_tokens) = (function_statement tokens "function") in 
      take_class_methods rem_tokens (stmt :: methods)
    | hd :: tl when (Token.equal_tag hd.tag Token.RIGHT_BRACE) -> (methods, tl)
    | _ -> 
      let message = "Expect '}' after class body." in 
      raise Lox_error.(ParseError {line=(-1); lexeme="EOF";message=message}) 

and if_statement (tokens: Token.t list) = 
  let (_, rem_tokens) = consume  Token.LEFT_PAREN "Expect '(' after 'if'" tokens in
  let (condition, rem_tokens) = expression rem_tokens in 
  let (_, rem_tokens) = consume  Token.RIGHT_PAREN "Expect ')' after 'if'" rem_tokens in
  let (then_branch, rem_tokens) = expression rem_tokens in 

  match rem_tokens with 
  | hd::tl when (Token.equal_tag hd.tag Token.ELSE) -> 
    let (else_branch, rem_tokens) = expression tl in 
    (Statement.IfElse (condition, then_branch, else_branch), rem_tokens)
  | _ -> (Statement.If (condition, then_branch), rem_tokens)

and while_statement (tokens: Token.t list) = 
  let (_, rem_tokens) = consume  Token.LEFT_PAREN "Expect '(' after 'while'" tokens in 
  let (condition, rem_tokens) = expression rem_tokens in 
  let (_, rem_tokens) = consume  Token.RIGHT_PAREN "Expect ')' after 'while'" rem_tokens in 
  let (body, rem_tokens) = expression rem_tokens in 
  (Statement.While (condition, body)), rem_tokens

and for_statement (tokens: Token.t list): Statement.t * Token.t list = 
  let (_, rem_tokens) = consume  Token.LEFT_PAREN "Expect '(' after 'for'" tokens in 

  let a_b_to_somea_b (a,b) = (Some a, b) in 

  let (init, rem_tokens) = 
    match rem_tokens with 
    | hd :: tl when Token.equal_tag hd.tag Token.SEMICOLON -> None, tl
    | hd :: tl when Token.equal_tag hd.tag Token.VAR -> 
      var_declaration tl |> a_b_to_somea_b
    | _ -> expression_statement rem_tokens |> a_b_to_somea_b in

  let (condition, rem_tokens) = 
    match rem_tokens with 
    | hd :: _ when not (Token.equal_tag hd.tag Token.SEMICOLON) -> 
      expression rem_tokens 
    | _ -> (Expression.Literal (Value.LoxBool (true))), rem_tokens in

  let (_, rem_tokens) = consume  Token.SEMICOLON "Expect ';' after loop condition" rem_tokens in 

  let (increment, rem_tokens) = 
    match rem_tokens with 
    | hd :: _ when not (Token.equal_tag hd.tag Token.RIGHT_PAREN) -> 
      expression rem_tokens|> a_b_to_somea_b
    | _ -> None, rem_tokens in 

  let (_, rem_tokens) = consume  Token.RIGHT_PAREN "Expect ')' after for clauses" rem_tokens in 

  let (body, rem_tokens) = statement rem_tokens in 

  Statement.For (init, condition, increment, body), rem_tokens


and function_statement (tokens: Token.t list) (kind: string): (Statement.t * Token.t list) =
  let message = (Printf.sprintf "Expect %s name") kind in 
  let (name, rem_tokens) = consume Token.IDENTIFIER message tokens in 
  let message = (Printf.sprintf "Expect '(' after %s name") kind in 
  let (_, rem_tokens) = consume Token.LEFT_PAREN message rem_tokens in 

  let rec collect_parameters (tokens: Token.t list) (parameters: Token.t list) = 
    match tokens with 
    | hd :: tl when (Token.equal_tag hd.tag Token.COMMA) -> 
        if List.length parameters >= 255 then Printf.printf "Can't have more than 255 parameters";
        let (parameter, rem_tokens) = consume Token.IDENTIFIER message tl in 
        collect_parameters rem_tokens (parameters @ [parameter])
    | _  -> (parameters, tokens) in 

  let (parameters, rem_tokens) = 
    match consume_some_identifier rem_tokens with
    | (Some (a), rem_tokens) -> collect_parameters rem_tokens [a] 
    | (None, rem_tokens) -> [], rem_tokens in 

  let (_, rem_tokens) =
    let message = (Printf.sprintf "Expect ')' after parameters") in 
    consume Token.RIGHT_PAREN message rem_tokens   in 

  let (_, rem_tokens) = 
    let message = Printf.sprintf "Expect '{' after parameters declared" in 
    consume Token.LEFT_BRACE message rem_tokens  in 

  let (body, rem_tokens) = block rem_tokens [] in 
  let body = match body with | Statement.Block (b) -> b | _ -> [body;] in 

  Statement.FunctionDeclaration (name, parameters, body), rem_tokens

and return_statement (tokens: Token.t list) : (Statement.t * Token.t list) =
  let (expr, rem_tokens)  = 
    match tokens with
    | hd :: tl when Token.equal_tag hd.tag Token.SEMICOLON -> None, tl
    | _ -> expression tokens |> (fun (e, t) -> Some e, t) in 

  let message = (Printf.sprintf "Expect ';' after return value") in 
  let (_, rem_tokens) = consume Token.SEMICOLON message rem_tokens  in 
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
