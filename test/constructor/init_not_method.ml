open Core
open Olox_lib

let%expect_test "init_not_method" = 
"
class Foo {
  init(arg) {
    print \"Foo.init(\" + arg + \")\";
    this.field = \"init\";
  }
}

fun init() {
  print \"not initializer\";
}

init(); // expect: not initializer
"
|> Interpreter.interpret;
  [%expect {| not initializer |}]
;;
    