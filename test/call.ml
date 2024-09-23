open Core
open Olox_lib

let%expect_test "nil.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/call/nil.lox" in 
  Reader.interpret filepath;
  [%expect {|
    Invalid expression (Call ((Literal LoxNil),
       { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 1 }, []))
    |}]
;;

let%expect_test "bool.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/call/bool.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : rue Empty enviroment |}]
;;

let%expect_test "object.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/call/object.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : Not callable Instance of Foo |}]
;;

let%expect_test "string.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/call/string.lox" in 
  Reader.interpret filepath;
  [%expect {|
    Invalid expression (Call ((Literal (LoxString "str")),
       { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 1 }, []))
    |}]
;;

let%expect_test "num.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/call/num.lox" in 
  Reader.interpret filepath;
  [%expect {|
    Invalid expression (Call ((Literal (LoxNumber 123.)),
       { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 1 }, []))
    |}]
;;
