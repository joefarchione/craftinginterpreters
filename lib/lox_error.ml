type parse_error = {
  line: int;
  lexeme: string;
  message: string;
}

exception ParseError of parse_error
exception ArgumentLengthExceeded of string
exception RunTimeError of string * string
exception TooFewArgumentsSupplied of string
exception TooManyArgumentsSupplied of string

let too_few_arguments_supplied () = 
  raise (TooFewArgumentsSupplied "Number of arguments supplied less than number of parameters")

let out_of_tokens () =
  raise (ParseError {line=(-1); lexeme="EOF"; message="out of tokens"})
