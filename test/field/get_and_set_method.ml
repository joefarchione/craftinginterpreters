open Core
open Olox_lib

let%expect_test "get_and_set_method" = 
"
// Bound methods have identity equality.
class Foo {
  method(a) {
    print \"method\";
    print a;
  }
  other(a) {
    print \"other\";
    print a;
  }
}

var foo = Foo();
var method = foo.method;

// Setting a property shadows the instance method.
foo.method = foo.other;
foo.method(1);
// expect: other
// expect: 1

// The old method handle still points to the original method.
method(2);
// expect: method
// expect: 2
"
|> Interpreter.interpret;
  [%expect {|
    invalid expression (Call (
       (Get (
          (Variable
             { tag = IDENTIFIER; lexeme = "foo"; literal = LoxNil; line = 19 }),
          { tag = IDENTIFIER; lexeme = "method"; literal = LoxNil; line = 19 })),
       { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 19 },
       [(Literal (LoxNumber 1.))]))
    |}]
;;
    