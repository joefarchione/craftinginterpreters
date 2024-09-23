open Core
open Olox_lib

let%expect_test "keywords" = 
"
and class else false for fun if nil or return super this true var while

// expect: AND and null
// expect: CLASS class null
// expect: ELSE else null
// expect: FALSE false null
// expect: FOR for null
// expect: FUN fun null
// expect: IF if null
// expect: NIL nil null
// expect: OR or null
// expect: RETURN return null
// expect: SUPER super null
// expect: THIS this null
// expect: TRUE true null
// expect: VAR var null
// expect: WHILE while null
// expect: EOF  null
"
|> Lexer.scan_text
|> Token.print_tokens;
  [%expect {|
    { tag = AND; lexeme = "and"; literal = LoxNil; line = 2 }

    { tag = CLASS; lexeme = "class"; literal = LoxNil; line = 2 }

    { tag = ELSE; lexeme = "else"; literal = LoxNil; line = 2 }

    { tag = FALSE; lexeme = "false"; literal = (LoxBool false); line = 2 }

    { tag = FOR; lexeme = "for"; literal = LoxNil; line = 2 }

    { tag = FUN; lexeme = "fun"; literal = LoxNil; line = 2 }

    { tag = IF; lexeme = "if"; literal = LoxNil; line = 2 }

    { tag = NIL; lexeme = "nil"; literal = LoxNil; line = 2 }

    { tag = OR; lexeme = "or"; literal = LoxNil; line = 2 }

    { tag = RETURN; lexeme = "return"; literal = LoxNil; line = 2 }

    { tag = SUPER; lexeme = "super"; literal = LoxNil; line = 2 }

    { tag = THIS; lexeme = "this"; literal = LoxNil; line = 2 }

    { tag = TRUE; lexeme = "true"; literal = (LoxBool true); line = 2 }

    { tag = VAR; lexeme = "var"; literal = LoxNil; line = 2 }

    { tag = WHILE; lexeme = "while"; literal = LoxNil; line = 2 }
    |}]
;;
    