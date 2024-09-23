open Core
open Olox_lib

let%expect_test "string" = 
"
\"str\"(); // expect runtime error: Can only call functions and classes.
"
|> Interpreter.interpret;
  [%expect {|
    Invalid expression (Call ((Literal (LoxString "str")),
       { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 2 }, []))
    |}]
;;
    