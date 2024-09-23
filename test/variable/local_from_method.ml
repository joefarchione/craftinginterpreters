open Core
open Olox_lib

(*FIXME*)

let%expect_test "local_from_method" = 
"
var foo = \"variable\";

class Foo {
  method() {
    print foo;
  }
}

Foo().method(); // expect: variable
"
|> Interpreter.interpret;
  [%expect {|
    invalid expression (Call (
       (Get (
          (Call (
             (Variable
                { tag = IDENTIFIER; lexeme = "Foo"; literal = LoxNil; line = 10 }),
             { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 10 },
             [])),
          { tag = IDENTIFIER; lexeme = "method"; literal = LoxNil; line = 10 })),
       { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 10 },
       []))
    |}]
;;
    