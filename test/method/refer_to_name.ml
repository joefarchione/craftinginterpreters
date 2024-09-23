open Core
open Olox_lib

let%expect_test "refer_to_name" = 
"
class Foo {
  method() {
    print method; // expect runtime error: Undefined variable 'method'.
  }
}

Foo().method();
"
|> Interpreter.interpret;
  [%expect {|
    invalid expression (Call (
       (Get (
          (Call (
             (Variable
                { tag = IDENTIFIER; lexeme = "Foo"; literal = LoxNil; line = 8 }),
             { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 8 },
             [])),
          { tag = IDENTIFIER; lexeme = "method"; literal = LoxNil; line = 8 })),
       { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 8 }, []))
    |}]
;;
    