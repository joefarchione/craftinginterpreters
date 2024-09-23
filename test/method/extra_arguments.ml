open Core
open Olox_lib

let%expect_test "extra_arguments" = 
"
class Foo {
  method(a, b) {
    print a;
    print b;
  }
}

Foo().method(1, 2, 3, 4); // expect runtime error: Expected 2 arguments but got 4.
"
|> Interpreter.interpret;
  [%expect {|
    invalid expression (Call (
       (Get (
          (Call (
             (Variable
                { tag = IDENTIFIER; lexeme = "Foo"; literal = LoxNil; line = 9 }),
             { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 9 },
             [])),
          { tag = IDENTIFIER; lexeme = "method"; literal = LoxNil; line = 9 })),
       { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 9 },
       [(Literal (LoxNumber 1.)); (Literal (LoxNumber 2.));
         (Literal (LoxNumber 3.)); (Literal (LoxNumber 4.))]
       ))
    |}]
;;
    