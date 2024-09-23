open Core
open Olox_lib

let%expect_test "subtract_nonnum_num" = 
"
\"1\" - 1; // expect runtime error: Operands must be numbers.
"
|> Interpreter.interpret;
  [%expect {|
    invalid expression (BinaryOp ((Literal (LoxString "1")),
       { tag = MINUS; lexeme = "-"; literal = LoxNil; line = 2 },
       (Literal (LoxNumber 1.))))
    |}]
;;
    