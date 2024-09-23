open Core
open Olox_lib

let%expect_test "add_num_nil" = 
"
1 + nil; // expect runtime error: Operands must be two numbers or two strings.
"
|> Interpreter.interpret;
  [%expect {|
    invalid expression (BinaryOp ((Literal (LoxNumber 1.)),
       { tag = PLUS; lexeme = "+"; literal = LoxNil; line = 2 }, (Literal LoxNil)
       ))
    |}]
;;
    