open Core
open Olox_lib

let%expect_test "not" = 
"
print !true;     // expect: false
print !false;    // expect: true
print !!true;    // expect: true

print !123;      // expect: false
print !0;        // expect: false

print !nil;     // expect: true

print !\"\";       // expect: false

fun foo() {}
print !foo;      // expect: false
"
|> Interpreter.interpret;
  [%expect {|
    false
    true
    true
    false
    false
    true
    false
    false
    |}]
;;
    