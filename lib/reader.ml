module Reader = struct

  let read_file file =
    In_channel.with_open_bin file In_channel.input_all

  let read_lines file =
    let contents = In_channel.with_open_bin file In_channel.input_all in
    String.split_on_char '\n' contents

  let interpret file = 
    try
      file
      |> read_file 
      |> Interpreter.interpret
    with 
      | Lox_error.ParseError (e) -> Printf.printf "%d %s %s" e.line e.lexeme e.message
      | Expression.EvalError (e) -> Printf.printf "Invalid expression %s" (Expression.show e)
    | Lox_error.RunTimeError (a, _) ->  Printf.printf "runtime error: %s" a
    | Resolver.ResolverError (msg) ->  Printf.printf "resover error: %s"  msg
      | Lox_error.TooFewArgumentsSupplied (e) -> Printf.printf "%s" e

end
include Reader