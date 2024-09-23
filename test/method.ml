open Core
open Olox_lib

let%expect_test "empty_block.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/method/empty_block.lox" in 
  Reader.interpret filepath;
  [%expect {|
    Invalid expression (Call (
       (Get (
          (Call (
             (Variable
                { tag = IDENTIFIER; lexeme = "Foo"; literal = LoxNil; line = 5 }),
             { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 5 },
             [])),
          { tag = IDENTIFIER; lexeme = "bar"; literal = LoxNil; line = 5 })),
       { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 5 }, []))
    |}]
;;

let%expect_test "arity.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/method/arity.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : return Can't return from top-level code |}]
;;

let%expect_test "too_many_parameters.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/method/too_many_parameters.lox" in 
  Reader.interpret filepath;
  [%expect {| Can't have more than 255 parameters |}]
;;

let%expect_test "too_many_arguments.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/method/too_many_arguments.lox" in 
  Reader.interpret filepath;
[@@expect.uncaught_exn {|
  (* CR expect_test_collector: This test expectation appears to contain a backtrace.
     This is strongly discouraged as backtraces are fragile.
     Please change this test to not include a backtrace. *)
  ("Olox_lib.Lox_error.ArgumentLengthExceeded(\"Can't have more than 255 arguments\")")
  Raised at Olox_lib__Lox_error.too_many_arguments in file "lib/lox_error.ml", line 13, characters 2-69
  Called from Olox_lib__Parser.finish_call in file "lib/parser.ml", line 70, characters 45-76
  Called from Olox_lib__Parser.call.call_or_get in file "lib/parser.ml", line 47, characters 36-53
  Called from Olox_lib__Parser.binary in file "lib/parser.ml", line 110, characters 27-43
  Called from Olox_lib__Parser.binary in file "lib/parser.ml", line 110, characters 27-43
  Called from Olox_lib__Parser.binary in file "lib/parser.ml", line 110, characters 27-43
  Called from Olox_lib__Parser.binary in file "lib/parser.ml", line 110, characters 27-43
  Called from Olox_lib__Parser.logical in file "lib/parser.ml", line 124, characters 27-43
  Called from Olox_lib__Parser.logical in file "lib/parser.ml", line 124, characters 27-43
  Called from Olox_lib__Parser.logical_or in file "lib/parser.ml" (inlined), line 133, characters 2-32
  Called from Olox_lib__Parser.assignment in file "lib/parser.ml", line 136, characters 27-44
  Called from Olox_lib__Parser.expression in file "lib/parser.ml" (inlined), line 147, characters 24-41
  Called from Olox_lib__Parser.expression_statement in file "lib/parser.ml", line 182, characters 28-45
  Called from Olox_lib__Parser.statement in file "lib/parser.ml", line 173, characters 13-40
  Called from Olox_lib__Parser.block in file "lib/parser.ml", line 198, characters 29-47
  Called from Olox_lib__Parser.statement in file "lib/parser.ml", line 167, characters 28-39
  Called from Olox_lib__Parser.statements in file "lib/parser.ml", line 155, characters 29-45
  Called from Olox_lib__Parser.parse in file "lib/parser.ml", line 351, characters 22-42
  Called from Olox_lib__Interpreter.interpret in file "lib/interpreter.ml", lines 325-326, characters 4-19
  Called from Olox_lib__Reader.Reader.interpret in file "lib/reader.ml", lines 12-14, characters 6-30
  Called from Ppx_expect_runtime__Test_block.Configured.dump_backtrace in file "runtime/test_block.ml", line 142, characters 10-28
  |}]
;;

let%expect_test "print_bound_method.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/method/print_bound_method.lox" in 
  Reader.interpret filepath;
  [%expect {| <method method> |}]
;;

let%expect_test "extra_arguments.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/method/extra_arguments.lox" in 
  Reader.interpret filepath;
  [%expect {|
    Invalid expression (Call (
       (Get (
          (Call (
             (Variable
                { tag = IDENTIFIER; lexeme = "Foo"; literal = LoxNil; line = 8 }),
             { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 8 },
             [])),
          { tag = IDENTIFIER; lexeme = "method"; literal = LoxNil; line = 8 })),
       { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 8 },
       [(Literal (LoxNumber 1.)); (Literal (LoxNumber 2.));
         (Literal (LoxNumber 3.)); (Literal (LoxNumber 4.))]
       ))
    |}]
;;

let%expect_test "not_found.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/method/not_found.lox" in 
  Reader.interpret filepath;
  [%expect {| Runtime error : No property unknown Foo |}]
;;

let%expect_test "refer_to_name.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/method/refer_to_name.lox" in 
  Reader.interpret filepath;
  [%expect {|
    Invalid expression (Call (
       (Get (
          (Call (
             (Variable
                { tag = IDENTIFIER; lexeme = "Foo"; literal = LoxNil; line = 7 }),
             { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 7 },
             [])),
          { tag = IDENTIFIER; lexeme = "method"; literal = LoxNil; line = 7 })),
       { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 7 }, []))
    |}]
;;

let%expect_test "missing_arguments.lox" = 
  let filepath = "/home/joefarchione/Projects/crafting_interpreters/olox/test/data/method/missing_arguments.lox" in 
  Reader.interpret filepath;
  [%expect {|
    Invalid expression (Call (
       (Get (
          (Call (
             (Variable
                { tag = IDENTIFIER; lexeme = "Foo"; literal = LoxNil; line = 5 }),
             { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 5 },
             [])),
          { tag = IDENTIFIER; lexeme = "method"; literal = LoxNil; line = 5 })),
       { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 5 },
       [(Literal (LoxNumber 1.))]))
    |}]
;;
