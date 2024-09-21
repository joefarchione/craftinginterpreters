type parse_error = {
  line: int;
  lexeme: string;
  message: string;
}

exception ParseError of parse_error
exception ArgumentLengthExceeded of string
exception RunTimeError of string * string
exception TooFewArgumentsSupplied of string
exception ReturnError of Value.t
exception EvalError of Expression.t

let too_many_arguments () = 
  raise (ArgumentLengthExceeded "Can't have more than 255 arguments")

let too_few_arguments_supplied () = 
  raise (TooFewArgumentsSupplied "Number of arguments supplied less than number of parameters")

let out_of_tokens () =
  raise (ParseError {line=(-1); lexeme="EOF"; message="out of tokens"})

let report_runtime_error error = 
  (Printf.eprintf "%s\n[line %d]") error.message error.line

let report_parse_error error = 
  (Printf.eprintf "line %d: %s lexeme=%s\n") error.line error.message error.lexeme

let report_eval_error expr_str = 
  (Printf.eprintf "%s") expr_str