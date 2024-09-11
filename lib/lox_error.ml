type parse_error = {
  line: int;
  lexeme: string;
  message: string;
}

type eval_error = {
  expr: Expression.t;
}

exception ParseError of parse_error
exception EvalError of eval_error
exception ArgumentLengthExceeded of string
exception TooFewArgumentsSupplied of string
exception ReturnError of Value.t

let too_many_arguments () = 
  raise (ArgumentLengthExceeded "Can't have more than 255 arguments")

let too_few_arguments_supplied () = 
  raise (TooFewArgumentsSupplied "Number of arguments supplied less than number of parameters")

let out_of_tokens () =
  raise (ParseError {line=(-1); lexeme="EOF"; message="out of tokens"})

let parse_error_from_token (token: Token.t) (message:string) = 
  raise (ParseError {line=token.line; lexeme=token.lexeme; message=message})

let report_runtime_error error = 
  (Printf.eprintf "%s\n[line %d]") error.message error.line

let report_eval_error error = 
  (Printf.eprintf "%s") (Expression.show error)