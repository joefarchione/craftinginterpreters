open Core
open Olox_lib

let%expect_test "infix_operator" = 
"
var a = \"a\";
var b = \"b\";
a + b = \"value\"; // Error at '=': Invalid assignment target.
"
|> Interpreter.interpret;
  [%expect {|
    runtime error: Invalid assignment target '(BinaryOp (
       (Variable { tag = IDENTIFIER; lexeme = "a"; literal = LoxNil; line = 4 }),
       { tag = PLUS; lexeme = "+"; literal = LoxNil; line = 4 },
       (Variable { tag = IDENTIFIER; lexeme = "b"; literal = LoxNil; line = 4 })
       ))'
    |}]
;;
    