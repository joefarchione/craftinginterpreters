open Core
open Olox_lib

let%expect_test "return_in_nested_function" = 
"
class Foo {
  init() {
    fun init() {
      return \"bar\";
    }
    print init(); // expect: bar
  }
}

print Foo(); // expect: Foo instance
"
|> Interpreter.interpret;
;;
    