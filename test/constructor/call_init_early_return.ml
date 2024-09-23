open Core
open Olox_lib

let%expect_test "call_init_early_return" = 
"
class Foo {
  init() {
    print \"init\";
    return;
    print \"nope\";
  }
}

var foo = Foo(); // expect: init
print foo.init(); // expect: init
// expect: Foo instance
"
|> Interpreter.interpret;
;;
    