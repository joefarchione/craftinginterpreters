open Core
open Olox_lib

let%expect_test "inherited_method" = 
"
class Foo {
  inFoo() {
    print \"in foo\";
  }
}

class Bar < Foo {
  inBar() {
    print \"in bar\";
  }
}

class Baz < Bar {
  inBaz() {
    print \"in baz\";
  }
}

var baz = Baz();
baz.inFoo(); // expect: in foo
baz.inBar(); // expect: in bar
baz.inBaz(); // expect: in baz
"
|> Interpreter.interpret;
  [%expect {|
    Invalid expression (Call (
       (Get (
          (Variable
             { tag = IDENTIFIER; lexeme = "baz"; literal = LoxNil; line = 21 }),
          { tag = IDENTIFIER; lexeme = "inFoo"; literal = LoxNil; line = 21 })),
       { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 21 },
       []))
    |}]
;;
    