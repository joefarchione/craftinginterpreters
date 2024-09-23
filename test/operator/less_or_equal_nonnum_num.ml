open Core
open Olox_lib

let%expect_test "less_or_equal_nonnum_num" = 
"
\"1\" <= 1; // expect runtime error: Operands must be numbers.
"
|> Interpreter.interpret;
  [%expect {|
    invalid expression (BinaryOp ((Literal (LoxString "1")),
       { tag = LESS_EQUAL; lexeme = "<="; literal = LoxNil; line = 2 },
       (Literal (LoxNumber 1.))))
    |}]
;;
    