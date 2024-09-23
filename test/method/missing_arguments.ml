open Core
open Olox_lib

let%expect_test "missing_arguments" = 
"
class Foo {
  method(a, b) {}
}

Foo().method(1); // expect runtime error: Expected 2 arguments but got 1.
"
|> Interpreter.interpret;
  [%expect {|
    invalid expression (Call (
       (Get (
          (Call (
             (Variable
                { tag = IDENTIFIER; lexeme = "Foo"; literal = LoxNil; line = 6 }),
             { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 6 },
             [])),
          { tag = IDENTIFIER; lexeme = "method"; literal = LoxNil; line = 6 })),
       { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 6 },
       [(Literal (LoxNumber 1.))]))
    |}]
;;
    