open Core
open Olox_lib

let%expect_test "method" = 
"
class Foo {
  bar(arg) {
    print arg;
  }
}

var bar = Foo().bar;
print \"got method\"; // expect: got method
bar(\"arg\");          // expect: arg
"
|> Interpreter.interpret;
  [%expect {|
    got method
    invalid expression (Call (
       (Variable
          { tag = IDENTIFIER; lexeme = "bar"; literal = LoxNil; line = 10 }),
       { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 10 },
       [(Literal (LoxString "arg"))]))
    |}]
;;
    