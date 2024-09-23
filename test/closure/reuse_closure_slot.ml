open Core
open Olox_lib

let%expect_test "reuse_closure_slot" = 
"
{
  var f;

  {
    var a = \"a\";
    fun f_() { print a; }
    f = f_;
  }

  {
    // Since a is out of scope, the local slot will be reused by b. Make sure
    // that f still closes over a.
    var b = \"b\";
    f(); // expect: a
  }
}
"
|> Interpreter.interpret;
;;
    