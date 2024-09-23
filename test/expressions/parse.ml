open Core
open Olox_lib

let%expect_test "parse" = 
"
// Note: This is just for the expression parsing chapter which prints the AST.
print (5 - (3 - 1)) + -1;
// expect: (+ (group (- 5.0 (group (- 3.0 1.0)))) (- 1.0))
"
|> Lexer.scan_text |> Parser.parse |> Statement.print_statements;
  [%expect {|
    (Print
       (BinaryOp (
          (Grouping
             (BinaryOp ((Literal (LoxNumber 5.)),
                { tag = MINUS; lexeme = "-"; literal = LoxNil; line = 3 },
                (Grouping
                   (BinaryOp ((Literal (LoxNumber 3.)),
                      { tag = MINUS; lexeme = "-"; literal = LoxNil; line = 3 },
                      (Literal (LoxNumber 1.)))))
                ))),
          { tag = PLUS; lexeme = "+"; literal = LoxNil; line = 3 },
          (Unary ({ tag = MINUS; lexeme = "-"; literal = LoxNil; line = 3 },
             (Literal (LoxNumber 1.))))
          )))
    |}]
;;
    