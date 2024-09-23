open Core
open Olox_lib

let%expect_test "num" = 
"
123(); // expect runtime error: Can only call functions and classes.
"
|> Interpreter.interpret;
  [%expect {|
    Invalid expression (Call ((Literal (LoxNumber 123.)),
       { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 2 }, []))
    |}]
;;
    