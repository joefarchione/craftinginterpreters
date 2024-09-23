open Core
open Olox_lib

let%expect_test "add_bool_string.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/add_bool_string.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : rue Empty enviroment |}]
;;

let%expect_test "greater_or_equal_nonnum_num.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/greater_or_equal_nonnum_num.lox" in 
  Reader.interpret filepath;
  [%expect {|
    Invalid expression (BinaryOp ((Literal (LoxString "1")),
       { tag = GREATER_EQUAL; lexeme = ">= "; literal = LoxNil; line = 1 },
       (Literal (LoxNumber 1.))))
    |}]
;;

let%expect_test "not_class.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/not_class.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : ar Empty enviroment |}]
;;

let%expect_test "subtract_nonnum_num.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/subtract_nonnum_num.lox" in 
  Reader.interpret filepath;
  [%expect {|
    Invalid expression (BinaryOp ((Literal (LoxString "1")),
       { tag = MINUS; lexeme = "-"; literal = LoxNil; line = 1 },
       (Literal (LoxNumber 1.))))
    |}]
;;

let%expect_test "less_num_nonnum.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/less_num_nonnum.lox" in 
  Reader.interpret filepath;
  [%expect {|
    Invalid expression (BinaryOp ((Literal (LoxNumber 1.)),
       { tag = LESS; lexeme = "< "; literal = LoxNil; line = 1 },
       (Literal (LoxString "1"))))
    |}]
;;

let%expect_test "add_nil_nil.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/add_nil_nil.lox" in 
  Reader.interpret filepath;
  [%expect {|
    Invalid expression (BinaryOp ((Literal LoxNil),
       { tag = PLUS; lexeme = "+"; literal = LoxNil; line = 1 }, (Literal LoxNil)
       ))
    |}]
;;

let%expect_test "greater_nonnum_num.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/greater_nonnum_num.lox" in 
  Reader.interpret filepath;
  [%expect {|
    Invalid expression (BinaryOp ((Literal (LoxString "1")),
       { tag = GREATER; lexeme = "> "; literal = LoxNil; line = 1 },
       (Literal (LoxNumber 1.))))
    |}]
;;

let%expect_test "add_bool_num.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/add_bool_num.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : rue Empty enviroment |}]
;;

let%expect_test "negate_nonnum.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/negate_nonnum.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : Not a number s |}]

;;

let%expect_test "subtract_num_nonnum.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/subtract_num_nonnum.lox" in 
  Reader.interpret filepath;
  [%expect {|
    Invalid expression (BinaryOp ((Literal (LoxNumber 1.)),
       { tag = MINUS; lexeme = "-"; literal = LoxNil; line = 1 },
       (Literal (LoxString "1"))))
    |}]
;;

let%expect_test "add.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/add.lox" in 
  Reader.interpret filepath;
  [%expect {| 579string |}]
;;

let%expect_test "equals_class.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/equals_class.lox" in 
  Reader.interpret filepath;
  [%expect {| truefalsefalsetruefalsefalsefalseRuntime error : rue Empty enviroment |}]
;;

let%expect_test "greater_num_nonnum.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/greater_num_nonnum.lox" in 
  Reader.interpret filepath;
  [%expect {|
    Invalid expression (BinaryOp ((Literal (LoxNumber 1.)),
       { tag = GREATER; lexeme = "> "; literal = LoxNil; line = 1 },
       (Literal (LoxString "1"))))
    |}]
;;

let%expect_test "equals.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/equals.lox" in 
  Reader.interpret filepath;
  [%expect {| trueRuntime error : rue Empty enviroment |}]
;;

let%expect_test "add_string_nil.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/add_string_nil.lox" in 
  Reader.interpret filepath;
  [%expect {|
    Invalid expression (BinaryOp ((Literal (LoxString "s")),
       { tag = PLUS; lexeme = "+"; literal = LoxNil; line = 1 }, (Literal LoxNil)
       ))
    |}]
;;

let%expect_test "less_or_equal_nonnum_num.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/less_or_equal_nonnum_num.lox" in 
  Reader.interpret filepath;
  [%expect {|
    Invalid expression (BinaryOp ((Literal (LoxString "1")),
       { tag = LESS_EQUAL; lexeme = "<= "; literal = LoxNil; line = 1 },
       (Literal (LoxNumber 1.))))
    |}]
;;

let%expect_test "not.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/not.lox" in 
  Reader.interpret filepath;
  [%expect {| 10 EOF Unterminated string |}]
;;

let%expect_test "add_bool_nil.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/add_bool_nil.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : rue Empty enviroment |}]
;;

let%expect_test "comparison.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/comparison.lox" in 
  Reader.interpret filepath;
  [%expect {| truefalsefalsetruetruefalsefalsefalsetruefalsetruetruefalsefalsefalsefalsetruetruetruetrue |}]
;;

let%expect_test "multiply_nonnum_num.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/multiply_nonnum_num.lox" in 
  Reader.interpret filepath;
  [%expect {|
    Invalid expression (BinaryOp ((Literal (LoxString "1")),
       { tag = STAR; lexeme = "*"; literal = LoxNil; line = 1 },
       (Literal (LoxNumber 1.))))
    |}]
;;

let%expect_test "not_equals.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/not_equals.lox" in 
  Reader.interpret filepath;
  [%expect {| falseRuntime error : rue Empty enviroment |}]
;;

let%expect_test "greater_or_equal_num_nonnum.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/greater_or_equal_num_nonnum.lox" in 
  Reader.interpret filepath;
  [%expect {|
    Invalid expression (BinaryOp ((Literal (LoxNumber 1.)),
       { tag = GREATER_EQUAL; lexeme = ">= "; literal = LoxNil; line = 1 },
       (Literal (LoxString "1"))))
    |}]
;;

let%expect_test "multiply_num_nonnum.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/multiply_num_nonnum.lox" in 
  Reader.interpret filepath;
  [%expect {|
    Invalid expression (BinaryOp ((Literal (LoxNumber 1.)),
       { tag = STAR; lexeme = "*"; literal = LoxNil; line = 1 },
       (Literal (LoxString "1"))))
    |}]
;;

let%expect_test "less_or_equal_num_nonnum.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/less_or_equal_num_nonnum.lox" in 
  Reader.interpret filepath;
  [%expect {|
    Invalid expression (BinaryOp ((Literal (LoxNumber 1.)),
       { tag = LESS_EQUAL; lexeme = "<= "; literal = LoxNil; line = 1 },
       (Literal (LoxString "1"))))
    |}]
;;

let%expect_test "add_num_nil.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/add_num_nil.lox" in 
  Reader.interpret filepath;
  [%expect {|
    Invalid expression (BinaryOp ((Literal (LoxNumber 1.)),
       { tag = PLUS; lexeme = "+"; literal = LoxNil; line = 1 }, (Literal LoxNil)
       ))
    |}]
;;

let%expect_test "divide_nonnum_num.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/divide_nonnum_num.lox" in 
  Reader.interpret filepath;
  [%expect {|
    Invalid expression (BinaryOp ((Literal (LoxString "1")),
       { tag = SLASH; lexeme = "/"; literal = LoxNil; line = 1 },
       (Literal (LoxNumber 1.))))
    |}]
;;

let%expect_test "less_nonnum_num.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/less_nonnum_num.lox" in 
  Reader.interpret filepath;
  [%expect {|
    Invalid expression (BinaryOp ((Literal (LoxString "1")),
       { tag = LESS; lexeme = "< "; literal = LoxNil; line = 1 },
       (Literal (LoxNumber 1.))))
    |}]
;;

let%expect_test "equals_method.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/equals_method.lox" in 
  Reader.interpret filepath;
  [%expect {| falsefalse |}]
;;

let%expect_test "negate.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/negate.lox" in 
  Reader.interpret filepath;
  [%expect {| -33-3 |}]
;;

let%expect_test "divide.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/divide.lox" in 
  Reader.interpret filepath;
  [%expect {| 41 |}]
;;

let%expect_test "subtract.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/subtract.lox" in 
  Reader.interpret filepath;
  [%expect {| 10 |}]
;;

let%expect_test "multiply.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/multiply.lox" in 
  Reader.interpret filepath;
  [%expect {| 153.702 |}]
;;

let%expect_test "divide_num_nonnum.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/operator/divide_num_nonnum.lox" in 
  Reader.interpret filepath;
  [%expect {|
    Invalid expression (BinaryOp ((Literal (LoxNumber 1.)),
       { tag = SLASH; lexeme = "/"; literal = LoxNil; line = 1 },
       (Literal (LoxString "1"))))
    |}]
;;
