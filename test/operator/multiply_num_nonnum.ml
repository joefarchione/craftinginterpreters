open Core
open Olox_lib

let%expect_test "multiply_num_nonnum" = 
"
1 * \"1\"; // expect runtime error: Operands must be numbers.
"
|> Interpreter.interpret;
  [%expect {|
    invalid expression (BinaryOp ((Literal (LoxNumber 1.)),
       { tag = STAR; lexeme = "*"; literal = LoxNil; line = 2 },
       (Literal (LoxString "1"))))
    |}]
;;
    