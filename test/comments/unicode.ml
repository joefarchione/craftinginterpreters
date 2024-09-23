open Core
open Olox_lib

let%expect_test "unicode" = 
"
// Unicode characters are allowed in comments.
//
// Latin 1 Supplement: £§¶ÜÞ
// Latin Extended-A: ĐĦŋœ
// Latin Extended-B: ƂƢƩǁ
// Other stuff: ឃᢆ᯽₪ℜ↩⊗┺░
// Emoji: ☃☺♣

print \"ok\"; // expect: ok
"
|> Interpreter.interpret;
  [%expect {| ok |}];;
;;
    