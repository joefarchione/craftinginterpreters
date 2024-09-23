open Core
open Olox_lib

let%expect_test "add_bool_string" = 
"
true + \"s\"; // expect runtime error: Operands must be two numbers or two strings.
"
|> Interpreter.interpret;
  [%expect {|
    invalid expression (BinaryOp ((Literal (LoxBool true)),
       { tag = PLUS; lexeme = "+"; literal = LoxNil; line = 2 },
       (Literal (LoxString "s"))))
    |}]
;;
    