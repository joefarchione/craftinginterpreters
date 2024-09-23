open Core
open Olox_lib

let%expect_test "nested_class" = 
"
class Outer {
  method() {
    print this; // expect: Outer instance

    fun f() {
      print this; // expect: Outer instance

      class Inner {
        method() {
          print this; // expect: Inner instance
        }
      }

      Inner().method();
    }
    f();
  }
}

Outer().method();
"
|> Interpreter.interpret;
  [%expect {|
    invalid expression (Call (
       (Get (
          (Call (
             (Variable
                { tag = IDENTIFIER; lexeme = "Outer"; literal = LoxNil; line = 21
                  }),
             { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 21 },
             [])),
          { tag = IDENTIFIER; lexeme = "method"; literal = LoxNil; line = 21 })),
       { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 21 },
       []))
    |}]
;;
    