open Core 

type tag = 
  | LEFT_PAREN
  | RIGHT_PAREN
  | LEFT_BRACE
  | RIGHT_BRACE
  | COMMA
  | DOT
  | MINUS
  | PLUS
  | SEMICOLON
  | SLASH
  | STAR
  | BANG
  | BANG_EQUAL
  | EQUAL
  | EQUAL_EQUAL
  | GREATER
  | GREATER_EQUAL
  | LESS
  | LESS_EQUAL
  | IDENTIFIER
  | STRING
  | NUMBER
  | AND
  | CLASS
  | ELSE
  | FALSE
  | FUN
  | FOR
  | IF
  | NIL
  | OR
  | PRINT
  | RETURN
  | SUPER
  | THIS
  | TRUE
  | VAR
  | WHILE
  | EOF
  [@@deriving  eq, compare, sexp, show { with_path = false }]


let get_keyword text =
  match text with
  | "and" ->    Some AND
  | "class" ->  Some CLASS
  | "else" ->   Some ELSE
  | "false" ->  Some FALSE
  | "for" ->    Some FOR
  | "fun" ->    Some FUN
  | "if" ->     Some IF
  | "nil" ->    Some NIL
  | "or" ->     Some OR
  | "print" ->  Some PRINT
  | "return" -> Some RETURN
  | "super" ->  Some SUPER
  | "this" ->   Some THIS
  | "true" ->   Some TRUE
  | "var" ->    Some VAR
  | "while" ->  Some WHILE
  | _ -> None



type t =  {
  tag: tag;
  lexeme: string;
  literal: Value.t;
  line: int; 
}
[@@deriving  eq, compare, sexp, show { with_path = false }]

let print token = 
  (Printf.printf "%s\n") (show token);
  (Printf.printf "\n");
  ()

let print_tokens tokens = 
  List.iter tokens ~f:print;
  (Printf.printf "\n");