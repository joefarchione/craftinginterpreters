open Core
open Olox_lib

let%expect_test "method_binds_this" = 
"
class Foo {
  sayName(a) {
    print this.name;
    print a;
  }
}

var foo1 = Foo();
foo1.name = \"foo1\";

var foo2 = Foo();
foo2.name = \"foo2\";

// Store the method reference on another object.
foo2.fn = foo1.sayName;
// Still retains original receiver.
foo2.fn(1);
// expect: foo1
// expect: 1
"
|> Interpreter.interpret;
  [%expect {|
    invalid expression (Call (
       (Get (
          (Variable
             { tag = IDENTIFIER; lexeme = "foo2"; literal = LoxNil; line = 18 }),
          { tag = IDENTIFIER; lexeme = "fn"; literal = LoxNil; line = 18 })),
       { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 18 },
       [(Literal (LoxNumber 1.))]))
    |}]
;;
    