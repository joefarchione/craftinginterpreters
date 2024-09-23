open Core
open Olox_lib

let%expect_test "literals" = 
"
print \"(\" + \"\" + \")\";   // expect: ()
print \"a string\"; // expect: a string

// Non-ASCII.
print \"A~¶Þॐஃ\"; // expect: A~¶Þॐஃ
"
|> Interpreter.interpret;
;;
    