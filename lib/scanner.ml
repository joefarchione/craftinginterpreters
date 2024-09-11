type t = {
  source: string;
  tokens: Token.t list;
  start: int;
  current: int;
  line: int;
}

let create_scanner string = {source=string; tokens=[]; start=0; current=0;line=1;}
let is_eof scanner = scanner.current >= String.length scanner.source 
let advance_scanner scanner = {scanner with current = scanner.current + 1}

let get_char scanner = 
  if scanner.current > String.length scanner.source
  then None
  else Some scanner.source.[scanner.current - 1]

let get_lexeme scanner =
  String.sub scanner.source scanner.start (scanner.current - scanner.start)

let add_token_with_literal scanner token_tag literal =
  let token = Token.{
    tag = token_tag;
    lexeme = get_lexeme scanner;
    literal = literal;
    line = scanner.line
  } in
  {scanner with tokens = token :: scanner.tokens}

let add_token scanner tag = 
  let literal = Value.LoxNil in
  add_token_with_literal scanner tag literal

let add_double_token scanner double_token single_token = 
  match scanner |> advance_scanner |> get_char with 
  | None -> add_token scanner single_token
  | Some c ->
    let scanner = advance_scanner scanner  in 
    if not (Char.equal c '=')
    then add_token (scanner) single_token
    else add_token (advance_scanner scanner) double_token


let peek_n n scanner = 
  if (scanner.current+n-1) >= (String.length scanner.source)
  then '\x00'
  else scanner.source.[scanner.current+n-1]

let peek scanner = scanner |> peek_n 1
let peek_next scanner = scanner |> peek_n 2

let add_comment scanner =
  match scanner |> advance_scanner |> get_char with
  | None -> add_token scanner SLASH
  | Some c ->
  if Char.equal c '/'
  then (
    let rec comment_out scanner =
      if is_eof scanner || Char.equal (peek scanner) '\n'
      then scanner
      else scanner |> advance_scanner |> comment_out
    in
    comment_out scanner)
  else add_token scanner SLASH 

let rec add_string scanner =
  if Char.equal (peek scanner) '"' && not (is_eof scanner)  then (
    let scanner = advance_scanner scanner in
    let literal = 
        Value.LoxString (String.sub scanner.source (scanner.start+1) (scanner.current - scanner.start-2)) in 
    add_token_with_literal scanner STRING literal
  )
  else if (is_eof scanner) then 
      let message = "Unterminated string" in 
      raise Lox_error.(ParseError {line = scanner.line; lexeme = "EOF" ; message = message;})
  else scanner |> advance_scanner |> add_string

let is_alpha = function 'a' .. 'z' | 'A' .. 'Z' -> true | _ -> false
let is_digit = function '0' .. '9' -> true | _ -> false
let is_alphanumeric c = is_alpha c || is_digit c

let rec number scanner =
  if (scanner |> peek |> is_digit |> not ) && (scanner |> peek |> Char.equal '.' |> not)
  then (
    let value = get_lexeme scanner in 
    let num = 
      try Some (Float.of_string value) with
      | _ -> None

    in 
    match num with
    | None -> raise Lox_error.(ParseError {line = scanner.line; lexeme = value; message = "Invalid number" });
    | Some n -> add_token_with_literal scanner NUMBER (LoxNumber n)
  )
  else scanner |> advance_scanner |> number


let rec identifier scanner = 
  if (scanner |> peek |> is_alphanumeric |> not) then (
    let text = get_lexeme scanner in 
    let token_type =
      match Token.get_keyword text with
      | None -> Token.IDENTIFIER
      | Some t -> t
    in add_token scanner token_type
  )
  else scanner |> advance_scanner |> identifier


let scan_token scanner = 
  let scanner = advance_scanner scanner in 
  match get_char scanner with
  | None -> scanner
  | Some c -> 
  (match c with
  | '(' -> add_token scanner LEFT_PAREN 
  | ')' -> add_token scanner RIGHT_PAREN 
  | '{' -> add_token scanner LEFT_BRACE 
  | '}' -> add_token scanner RIGHT_BRACE 
  | ',' -> add_token scanner COMMA 
  | '.' -> add_token scanner DOT 
  | '-' -> add_token scanner MINUS 
  | '+' -> add_token scanner PLUS 
  | ';' -> add_token scanner SEMICOLON 
  | '*' -> add_token scanner STAR  
  | '!' -> add_double_token scanner BANG_EQUAL BANG 
  | '=' -> add_double_token scanner EQUAL_EQUAL EQUAL 
  | '<' -> add_double_token scanner GREATER_EQUAL GREATER 
  | '>' -> add_double_token scanner LESS_EQUAL LESS 
  | '/' -> add_comment scanner 
  | ' ' | '\r' | 't'  -> scanner
  | '\n' -> {scanner with line = scanner.line + 1}
  | '"' -> add_string scanner
  | c when is_digit c -> number scanner
  | c when is_alpha c -> identifier scanner
  | _ -> raise Lox_error.(ParseError {line=scanner.line; lexeme = String.make 1 (c); message = "Invalid char"})
  )

let rec scan_tokens scanner = 
  if (scanner |> is_eof) then (
    let token =
      Token.{ tag = Token.EOF; lexeme = ""; literal = Value.LoxNil; line = scanner.line }
    in
    List.rev (token :: scanner.tokens))
  else
    let scanner = {scanner with start = scanner.current} in
    scan_tokens (scan_token scanner)

let scan_text text = 
  create_scanner text
  |> scan_tokens

