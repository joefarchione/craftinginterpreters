open Core
open Olox_lib

let%expect_test "empty_block" = 
"
class Foo {
  bar() {}
}

print Foo().bar(); // expect: nil
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
          { tag = IDENTIFIER; lexeme = "bar"; literal = LoxNil; line = 6 })),
       { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 6 }, []))
    |}]
;;
    