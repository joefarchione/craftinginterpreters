open Core
open Olox_lib

let%expect_test "identifiers" = 
"
andy formless fo _ _123 _abc ab123
abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_

// expect: IDENTIFIER andy null
// expect: IDENTIFIER formless null
// expect: IDENTIFIER fo null
// expect: IDENTIFIER _ null
// expect: IDENTIFIER _123 null
// expect: IDENTIFIER _abc null
// expect: IDENTIFIER ab123 null
// expect: IDENTIFIER abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_ null
// expect: EOF  null
"
|> Lexer.scan_text
|> Token.print_tokens;
  [%expect {|
    { tag = IDENTIFIER; lexeme = "andy"; literal = LoxNil; line = 2 }

    { tag = IDENTIFIER; lexeme = "formless"; literal = LoxNil; line = 2 }

    { tag = IDENTIFIER; lexeme = "fo"; literal = LoxNil; line = 2 }

    { tag = IDENTIFIER; lexeme = "_"; literal = LoxNil; line = 2 }

    { tag = IDENTIFIER; lexeme = "_123"; literal = LoxNil; line = 2 }

    { tag = IDENTIFIER; lexeme = "_abc"; literal = LoxNil; line = 2 }

    { tag = IDENTIFIER; lexeme = "ab123"; literal = LoxNil; line = 2 }

    { tag = IDENTIFIER;
      lexeme = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_";
      literal = LoxNil; line = 3 }
    |}]
;;
    