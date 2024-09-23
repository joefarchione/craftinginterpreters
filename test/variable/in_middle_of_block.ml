open Core
open Olox_lib

let%expect_test "in_middle_of_block" = 
"
{
  var a = \"a\";
  print a; // expect: a
  var b = a + \" b\";
  print b; // expect: a b
  var c = a + \" c\";
  print c; // expect: a c
  var d = b + \" d\";
  print d; // expect: a b d
}
"
|> Interpreter.interpret;
  [%expect {|
    a
    a b
    a c
    a b d
    |}]
;;
    