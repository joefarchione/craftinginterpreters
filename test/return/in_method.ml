open Core
open Olox_lib

let%expect_test "in_method" = 
"
class Foo {
  method() {
    return \"ok\";
    print \"bad\";
  }
}

print Foo().method(); // expect: ok
"
|> Interpreter.interpret;
  [%expect {| runtime error: return |}]
;;
    