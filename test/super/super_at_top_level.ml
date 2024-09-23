open Core
open Olox_lib

let%expect_test "super_at_top_level" = 
"
super.foo(\"bar\"); // Error at 'super': Can't use 'super' outside of a class.
super.foo; // Error at 'super': Can't use 'super' outside of a class."
|> Interpreter.interpret;
;;
    