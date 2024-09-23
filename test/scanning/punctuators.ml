open Core
open Olox_lib

let%expect_test "punctuators" = 
"
(){};,+-*!===<=>=!=<>/.

// expect: LEFT_PAREN ( null
// expect: RIGHT_PAREN ) null
// expect: LEFT_BRACE { null
// expect: RIGHT_BRACE } null
// expect: SEMICOLON ; null
// expect: COMMA , null
// expect: PLUS + null
// expect: MINUS - null
// expect: STAR * null
// expect: BANG_EQUAL != null
// expect: EQUAL_EQUAL == null
// expect: LESS_EQUAL <= null
// expect: GREATER_EQUAL >= null
// expect: BANG_EQUAL != null
// expect: LESS < null
// expect: GREATER > null
// expect: SLASH / null
// expect: DOT . null
// expect: EOF  null
"
|> Lexer.scan_text
|> Token.print_tokens;
  [%expect {|
    { tag = LEFT_PAREN; lexeme = "("; literal = LoxNil; line = 2 }

    { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 2 }

    { tag = LEFT_BRACE; lexeme = "{"; literal = LoxNil; line = 2 }

    { tag = RIGHT_BRACE; lexeme = "}"; literal = LoxNil; line = 2 }

    { tag = SEMICOLON; lexeme = ";"; literal = LoxNil; line = 2 }

    { tag = COMMA; lexeme = ","; literal = LoxNil; line = 2 }

    { tag = PLUS; lexeme = "+"; literal = LoxNil; line = 2 }

    { tag = MINUS; lexeme = "-"; literal = LoxNil; line = 2 }

    { tag = STAR; lexeme = "*"; literal = LoxNil; line = 2 }

    { tag = BANG_EQUAL; lexeme = "!="; literal = LoxNil; line = 2 }

    { tag = EQUAL_EQUAL; lexeme = "=="; literal = LoxNil; line = 2 }

    { tag = LESS_EQUAL; lexeme = "<="; literal = LoxNil; line = 2 }

    { tag = GREATER_EQUAL; lexeme = ">="; literal = LoxNil; line = 2 }

    { tag = BANG_EQUAL; lexeme = "!="; literal = LoxNil; line = 2 }

    { tag = LESS; lexeme = "<"; literal = LoxNil; line = 2 }

    { tag = GREATER; lexeme = ">"; literal = LoxNil; line = 2 }

    { tag = SLASH; lexeme = "/"; literal = LoxNil; line = 2 }

    { tag = DOT; lexeme = "."; literal = LoxNil; line = 2 }
    |}]
;;
    