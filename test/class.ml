open Core
open Olox_lib

let%expect_test "inherited_method.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/class/inherited_method.lox" in 
  Reader.interpret filepath;
  [%expect {|
    Invalid expression (Call (
       (Get (
          (Variable
             { tag = IDENTIFIER; lexeme = "baz"; literal = LoxNil; line = 20 }),
          { tag = IDENTIFIER; lexeme = "inFoo"; literal = LoxNil; line = 20 })),
       { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 20 },
       []))
    |}]

;;

let%expect_test "local_reference_self.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/class/local_reference_self.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : return Can't return from top-level code |}]
;;

let%expect_test "reference_self.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/class/reference_self.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : return Can't return from top-level code |}]
;;

let%expect_test "empty.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/class/empty.lox" in 
  Reader.interpret filepath;
  [%expect {| Foo |}]
;;

let%expect_test "local_inherit_self.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/class/local_inherit_self.lox" in 
  Reader.interpret filepath;
  [%expect {| Resover error : Foo A class cannot inherit from itself. |}]
;;

let%expect_test "local_inherit_other.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/class/local_inherit_other.lox" in 
  Reader.interpret filepath;
  [%expect {| B |}]
;;

let%expect_test "inherit_self.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/class/inherit_self.lox" in 
  Reader.interpret filepath;
  [%expect {| Resover error : Foo A class cannot inherit from itself. |}]
;;
