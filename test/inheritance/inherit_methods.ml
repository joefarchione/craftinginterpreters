open Core
open Olox_lib

let%expect_test "inherit_methods" = 
"
class Foo {
  methodOnFoo() { print \"foo\"; }
  override() { print \"foo\"; }
}

class Bar < Foo {
  methodOnBar() { print \"bar\"; }
  override() { print \"bar\"; }
}

var bar = Bar();
bar.methodOnFoo(); // expect: foo
bar.methodOnBar(); // expect: bar
bar.override(); // expect: bar
"
|> Interpreter.interpret;
;;
    