open Core
open Olox_lib

let%expect_test "call_function_field" = 
"
class Foo {}

fun bar(a, b) {
  print \"bar\";
  print a;
  print b;
}

var foo = Foo();
foo.bar = bar;

foo.bar(1, 2);
// expect: bar
// expect: 1
// expect: 2
"
|> Interpreter.interpret;
  [%expect {|
    bar
    1
    2
    |}]
;;
    