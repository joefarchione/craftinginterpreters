open Core
open Olox_lib

let%expect_test "early_return" = 
"
class Foo {
  init() {
    print \"init\";
    return;
    print \"nope\";
  }
}

var foo = Foo(); // expect: init
print foo; // expect: Foo instance
"
|> Interpreter.interpret;
  [%expect {| message='Expect ';' after return value' at line 6 for lexeme='print' |}]
;;
    