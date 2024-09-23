open Core
open Olox_lib

let%expect_test "redeclare_global.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/variable/redeclare_global.lox" in 
  Reader.interpret filepath;
  [%expect {| Resover error : a Already a variable in this scope with this name |}]
;;

let%expect_test "use_global_in_initializer.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/variable/use_global_in_initializer.lox" in 
  Reader.interpret filepath;
  [%expect {| Resover error : a Already a variable in this scope with this name |}]
;;

let%expect_test "shadow_and_local.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/variable/shadow_and_local.lox" in 
  Reader.interpret filepath;
  [%expect {| outerinner |}]
;;

let%expect_test "redefine_global.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/variable/redefine_global.lox" in 
  Reader.interpret filepath;
  [%expect {| Resover error : a Already a variable in this scope with this name |}]
;;

let%expect_test "undefined_local.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/variable/undefined_local.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : notDefined Empty enviroment |}]
;;

let%expect_test "use_false_as_var.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/variable/use_false_as_var.lox" in 
  Reader.interpret filepath;
  [%expect {| 2 false Expect variable name |}]
;;

let%expect_test "unreached_undefined.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/variable/unreached_undefined.lox" in 
  Reader.interpret filepath;
  [%expect {| ok |}]
;;

let%expect_test "duplicate_local.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/variable/duplicate_local.lox" in 
  Reader.interpret filepath;
  [%expect {| Resover error : a Already a variable in this scope with this name |}]
;;

let%expect_test "scope_reuse_in_different_blocks.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/variable/scope_reuse_in_different_blocks.lox" in 
  Reader.interpret filepath;
  [%expect {| firstsecond |}]
;;

let%expect_test "in_middle_of_block.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/variable/in_middle_of_block.lox" in 
  Reader.interpret filepath;
  [%expect {| aa ba ca b d |}]
;;

let%expect_test "early_bound.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/variable/early_bound.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : 2 Undefined environment |}]
;;

let%expect_test "use_local_in_initializer.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/variable/use_local_in_initializer.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : a Can't read local variable in it's own initializer |}]
;;

let%expect_test "collide_with_parameter.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/variable/collide_with_parameter.lox" in 
  Reader.interpret filepath;
  [%expect {| Resover error : a Already a variable in this scope with this name |}]
;;

let%expect_test "use_nil_as_var.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/variable/use_nil_as_var.lox" in 
  Reader.interpret filepath;
  [%expect {| 2 nil Expect variable name |}]
;;

let%expect_test "local_from_method.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/variable/local_from_method.lox" in 
  Reader.interpret filepath;
  [%expect {|
    Invalid expression (Call (
       (Get (
          (Call (
             (Variable
                { tag = IDENTIFIER; lexeme = "Foo"; literal = LoxNil; line = 9 }),
             { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 9 },
             [])),
          { tag = IDENTIFIER; lexeme = "method"; literal = LoxNil; line = 9 })),
       { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 9 }, []))
    |}]
;;

let%expect_test "shadow_local.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/variable/shadow_local.lox" in 
  Reader.interpret filepath;
  [%expect {| shadowlocal |}]
;;

let%expect_test "duplicate_parameter.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/variable/duplicate_parameter.lox" in 
  Reader.interpret filepath;
  [%expect {| Resover error : arg Already a variable in this scope with this name |}]
;;

let%expect_test "shadow_global.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/variable/shadow_global.lox" in 
  Reader.interpret filepath;
  [%expect {| shadowglobal |}]
;;

let%expect_test "uninitialized.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/variable/uninitialized.lox" in 
  Reader.interpret filepath;
  [%expect {| Nil |}]
;;

let%expect_test "use_this_as_var.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/variable/use_this_as_var.lox" in 
  Reader.interpret filepath;
;;

let%expect_test "in_nested_block.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/variable/in_nested_block.lox" in 
  Reader.interpret filepath;
  [%expect {| outer |}]
;;

let%expect_test "undefined_global.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/variable/undefined_global.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : notDefined Empty enviroment |}]
;;
