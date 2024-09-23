open Core
open Olox_lib

let%expect_test "method" = 
"
class Foo {
  bar(arg) {
    print arg;
  }
}

var bar = Foo().bar;
print \"got method\"; // expect: got method
bar(\"arg\");          // expect: arg
"
|> Interpreter.interpret;
;;
    