open Core

type t = {
  source: string;
  tokens: Token.t list;
  start: int;
  current: int;
  line: int;
}

let create_lexer string = {source=string; tokens=[]; start=0; current=0;line=1;}
let is_eof lexer = lexer.current >= String.length lexer.source 
let advance_lexer lexer = {lexer with current = lexer.current + 1}

let get_char lexer = 
  if lexer.current > String.length lexer.source
  then None
  else Some lexer.source.[lexer.current - 1]

let get_lexeme lexer =
  String.sub lexer.source ~pos:lexer.start ~len:(lexer.current - lexer.start)

let add_token_with_literal lexer token_tag literal =
  let token = Token.{
    tag = token_tag;
    lexeme = get_lexeme lexer;
    literal = literal;
    line = lexer.line;
  } in
  {lexer with tokens = token :: lexer.tokens}

let add_token lexer tag = 
  let literal = Value.LoxNil in
  add_token_with_literal lexer tag literal

let add_double_token lexer double_token single_token = 
  match lexer |> advance_lexer |> get_char with 
  | None -> 
    add_token lexer single_token
  | Some c ->
    if not (Char.equal c '=')
    then add_token (lexer) single_token
    else add_token (advance_lexer lexer) double_token

let peek_n n lexer = 
  if (lexer.current+n-1) >= (String.length lexer.source)
  then '\x00'
  else lexer.source.[lexer.current+n-1]

let peek lexer = lexer |> peek_n 1
let peek_next lexer = lexer |> peek_n 2

let add_comment lexer =
  match lexer |> advance_lexer |> get_char with
  | None -> add_token lexer SLASH
  | Some c ->
  if Char.equal c '/'
  then (
    let rec comment_out lexer =
      if is_eof lexer || Char.equal (peek lexer) '\n'
      then lexer
      else lexer |> advance_lexer |> comment_out
    in
    comment_out lexer)
  else add_token lexer SLASH 

let rec add_string lexer =
  if Char.equal (peek lexer) '"' && not (is_eof lexer)  then (
    let lexer = advance_lexer lexer in
    let literal = 
        Value.LoxString (String.sub lexer.source ~pos:(lexer.start+1) ~len:(lexer.current - lexer.start-2)) in 
    add_token_with_literal lexer STRING literal
  )
  else if (is_eof lexer) then 
      let message = "Unterminated string" in 
      raise Lox_error.(ParseError {line = lexer.line; lexeme = "EOF" ; message = message;})
  else lexer |> advance_lexer |> add_string

let is_alpha = function 'a' .. 'z' | 'A' .. 'Z' | '_' -> true | _ -> false
let is_digit = function '0' .. '9' -> true | _ -> false
let is_alphanumeric c = is_alpha c || is_digit c

let rec number lexer =
  if (lexer |> peek |> is_digit |> not ) && (lexer |> peek |> Char.equal '.' |> not)
  then (
    let value = get_lexeme lexer in 
    let num = 
      try Some (Float.of_string value) with
      | _ -> None

    in 
    match num with
    | None -> raise Lox_error.(ParseError {line = lexer.line; lexeme = value; message = "Invalid number" });
    | Some n -> add_token_with_literal lexer NUMBER (LoxNumber n)
  )
  else lexer |> advance_lexer |> number


let rec identifier lexer = 
  if (lexer |> peek |> is_alphanumeric |> not) then (
    let text = get_lexeme lexer in 
    let token_type =
      match Token.get_keyword text with
      | None -> Token.IDENTIFIER
      | Some t -> t in 
    let literal = (
      match token_type with
      | Token.TRUE -> Value.LoxBool(true)
      | Token.FALSE -> Value.LoxBool(false)
      | _ -> Value.LoxNil 
    ) in 
    add_token_with_literal lexer token_type literal
  )
  else lexer |> advance_lexer |> identifier


let scan_token lexer = 
  let lexer = advance_lexer lexer in 
  match get_char lexer with
  | None -> lexer
  | Some c -> 
  (match c with
  | '(' -> add_token lexer LEFT_PAREN 
  | ')' -> add_token lexer RIGHT_PAREN 
  | '{' -> add_token lexer LEFT_BRACE 
  | '}' -> add_token lexer RIGHT_BRACE 
  | ',' -> add_token lexer COMMA 
  | '.' -> add_token lexer DOT 
  | '-' -> add_token lexer MINUS 
  | '+' -> add_token lexer PLUS 
  | ';' -> add_token lexer SEMICOLON 
  | '*' -> add_token lexer STAR  
  | '!' -> add_double_token lexer BANG_EQUAL BANG 
  | '=' -> add_double_token lexer EQUAL_EQUAL EQUAL 
  | '<' -> add_double_token lexer LESS_EQUAL LESS 
  | '>' -> add_double_token lexer GREATER_EQUAL GREATER 
  | '/' -> add_comment lexer 
  | ' ' | '\r' | '\t'  -> lexer
  | '\n' -> {lexer with line = lexer.line + 1}
  | '"' -> add_string lexer
  | c when is_digit c -> number lexer
  | c when is_alpha c -> identifier lexer
  | _ -> raise Lox_error.(ParseError {line=lexer.line; lexeme = String.make 1 (c); message = "Invalid char"})
  )

let rec scan_tokens lexer = 
  if (lexer |> is_eof) then (
    List.rev lexer.tokens
  )
  else
    let lexer = {lexer with start = lexer.current} in
    scan_tokens (scan_token lexer)

let scan_text text = 
  create_lexer text
  |> scan_tokens

