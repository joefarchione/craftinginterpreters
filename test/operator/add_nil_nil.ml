open Core
open Olox_lib

let%expect_test "add_nil_nil" = 
"
nil + nil; // expect runtime error: Operands must be two numbers or two strings.
"
|> Interpreter.interpret;
  [%expect {|
    invalid expression (BinaryOp ((Literal LoxNil),
       { tag = PLUS; lexeme = "+"; literal = LoxNil; line = 2 }, (Literal LoxNil)
       ))
    |}]
;;
    