open Core
open Olox_lib

let%expect_test "shadow_closure_with_local" = 
"
{
  var foo = \"closure\";
  fun f() {
    {
      print foo; // expect: closure
      var foo = \"shadow\";
      print foo; // expect: shadow
    }
    print foo; // expect: closure
  }
  f();
}
"
|> Interpreter.interpret;
;;
    