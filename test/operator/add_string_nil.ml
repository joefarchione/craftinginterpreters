open Core
open Olox_lib

let%expect_test "add_string_nil" = 
"
\"s\" + nil; // expect runtime error: Operands must be two numbers or two strings.
"
|> Interpreter.interpret;
  [%expect {|
    invalid expression (BinaryOp ((Literal (LoxString "s")),
       { tag = PLUS; lexeme = "+"; literal = LoxNil; line = 2 }, (Literal LoxNil)
       ))
    |}]
;;
    