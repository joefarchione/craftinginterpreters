open Core
open Olox_lib

let%expect_test "call_nonfunction_field" = 
"
class Foo {}

var foo = Foo();
foo.bar = \"not fn\";

foo.bar(); // expect runtime error: Can only call functions and classes.
"
|> Interpreter.interpret;
  [%expect {|
    invalid expression (Call (
       (Get (
          (Variable
             { tag = IDENTIFIER; lexeme = "foo"; literal = LoxNil; line = 7 }),
          { tag = IDENTIFIER; lexeme = "bar"; literal = LoxNil; line = 7 })),
       { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 7 }, []))
    |}]
;;
    