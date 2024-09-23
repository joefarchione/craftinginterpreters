open Core
open Olox_lib

let%expect_test "nil" = 
"
nil(); // expect runtime error: Can only call functions and classes.
"
|> Interpreter.interpret;
  [%expect {|
    Invalid expression (Call ((Literal LoxNil),
       { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 2 }, []))
    |}]
;;
    