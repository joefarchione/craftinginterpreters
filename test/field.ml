open Core
open Olox_lib

let%expect_test "set_on_num.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/field/set_on_num.lox" in 
  Reader.interpret filepath;
  [%expect {| 1 foo Expect ';' after value |}]
;;

let%expect_test "get_on_nil.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/field/get_on_nil.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : foo Only instances have properties |}]
;;

let%expect_test "get_on_class.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/field/get_on_class.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : bar Only instances have properties |}]
;;

let%expect_test "get_and_set_method.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/field/get_and_set_method.lox" in 
  Reader.interpret filepath;
  [%expect {|
    Invalid expression (Call (
       (Get (
          (Variable
             { tag = IDENTIFIER; lexeme = "foo"; literal = LoxNil; line = 18 }),
          { tag = IDENTIFIER; lexeme = "method"; literal = LoxNil; line = 18 })),
       { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 18 },
       [(Literal (LoxNumber 1.))]))
    |}]
;;

let%expect_test "set_on_bool.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/field/set_on_bool.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : rue Empty enviroment |}]
;;

let%expect_test "get_on_string.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/field/get_on_string.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : foo Only instances have properties |}]
;;

let%expect_test "set_on_class.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/field/set_on_class.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : bar Only instances have fields |}]
;;

let%expect_test "set_on_nil.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/field/set_on_nil.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : foo Only instances have fields |}]
;;

let%expect_test "set_on_function.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/field/set_on_function.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : bar Only instances have fields |}]
;;

let%expect_test "set_on_string.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/field/set_on_string.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : foo Only instances have fields |}]
;;

let%expect_test "on_instance.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/field/on_instance.lox" in 
  Reader.interpret filepath;
  [%expect {| Instance of FooInstance of Foobar valuebaz value |}]
;;

let%expect_test "method_binds_this.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/field/method_binds_this.lox" in 
  Reader.interpret filepath;
  [%expect {|
    Invalid expression (Call (
       (Get (
          (Variable
             { tag = IDENTIFIER; lexeme = "foo2"; literal = LoxNil; line = 17 }),
          { tag = IDENTIFIER; lexeme = "fn"; literal = LoxNil; line = 17 })),
       { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 17 },
       [(Literal (LoxNumber 1.))]))
    |}]
;;

let%expect_test "undefined.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/field/undefined.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : No property bar Foo |}]
;;

let%expect_test "set_evaluation_order.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/field/set_evaluation_order.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : undefined1 Empty enviroment |}]
;;

let%expect_test "get_on_bool.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/field/get_on_bool.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : rue Empty enviroment |}]
;;

let%expect_test "get_on_function.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/field/get_on_function.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : bar Only instances have properties |}]
;;

let%expect_test "method.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/field/method.lox" in 
  Reader.interpret filepath;
  [%expect {|
    got methodInvalid expression (Call (
       (Variable { tag = IDENTIFIER; lexeme = "bar"; literal = LoxNil; line = 9 }),
       { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 9 },
       [(Literal (LoxString "arg"))]))
    |}]
;;

let%expect_test "get_on_num.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/field/get_on_num.lox" in 
  Reader.interpret filepath;
  [%expect {| 1 foo Expect ';' after value |}]
;;

let%expect_test "call_nonfunction_field.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/field/call_nonfunction_field.lox" in 
  Reader.interpret filepath;
  [%expect {|
    Invalid expression (Call (
       (Get (
          (Variable
             { tag = IDENTIFIER; lexeme = "foo"; literal = LoxNil; line = 6 }),
          { tag = IDENTIFIER; lexeme = "bar"; literal = LoxNil; line = 6 })),
       { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 6 }, []))
    |}]
;;

let%expect_test "many.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/field/many.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : No property apple Foo |}]
;;

let%expect_test "call_function_field.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/field/call_function_field.lox" in 
  Reader.interpret filepath;
  [%expect {| bar12 |}]
;;
