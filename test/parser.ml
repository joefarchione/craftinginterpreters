open Olox_lib

let%expect_test "var_assignment" = 
    "
    var a = 10;
    var b;

    b = a;
    
    print b;
    " 
    |> Lexer.scan_text 
    |> Parser.parse 
    |> Statement.print_statements;
  [%expect {|
    (VarDeclaration
       { name = { tag = IDENTIFIER; lexeme = "a"; literal = LoxNil; line = 2 };
         init = (Some (Literal (LoxNumber 10.))) })
    (VarDeclaration
       { name = { tag = IDENTIFIER; lexeme = "b"; literal = LoxNil; line = 3 };
         init = None })
    (Expression
       (Assignment (
          { tag = IDENTIFIER; lexeme = "b"; literal = LoxNil; line = 5 },
          (Variable
             { tag = IDENTIFIER; lexeme = "a"; literal = LoxNil; line = 5 })
          )))
    (Print
       (Variable { tag = IDENTIFIER; lexeme = "b"; literal = LoxNil; line = 7 }))
    |}]
;;

let%expect_test "while_loop" = 
    "
    var a = 0;
    while (a < 5)
    {
      print a;
      a = a + 1;
    }
    " 
    |> Lexer.scan_text 
    |> Parser.parse 
    |> Statement.print_statements;
  [%expect {|
    (VarDeclaration
       { name = { tag = IDENTIFIER; lexeme = "a"; literal = LoxNil; line = 2 };
         init = (Some (Literal (LoxNumber 0.))) })
    (While (
       (BinaryOp (
          (Variable
             { tag = IDENTIFIER; lexeme = "a"; literal = LoxNil; line = 3 }),
          { tag = LESS; lexeme = "< "; literal = LoxNil; line = 3 },
          (Literal (LoxNumber 5.)))),
       (Block
          [(Print
              (Variable
                 { tag = IDENTIFIER; lexeme = "a"; literal = LoxNil; line = 5 }));
            (Expression
               (Assignment (
                  { tag = IDENTIFIER; lexeme = "a"; literal = LoxNil; line = 6 },
                  (BinaryOp (
                     (Variable
                        { tag = IDENTIFIER; lexeme = "a"; literal = LoxNil;
                          line = 6 }),
                     { tag = PLUS; lexeme = "+"; literal = LoxNil; line = 6 },
                     (Literal (LoxNumber 1.))))
                  )))
            ])
       ))
    |}]
;;

let%expect_test "for_loop" = 
    "
    for (var i = 0; i < 10; i = i + 1) print i;
    " 
    |> Lexer.scan_text 
    |> Parser.parse 
    |> Statement.print_statements;
  [%expect {|
    (For (
       (Some (VarDeclaration
                { name =
                  { tag = IDENTIFIER; lexeme = "i"; literal = LoxNil; line = 2 };
                  init = (Some (Literal (LoxNumber 0.))) })),
       (BinaryOp (
          (Variable
             { tag = IDENTIFIER; lexeme = "i"; literal = LoxNil; line = 2 }),
          { tag = LESS; lexeme = "< "; literal = LoxNil; line = 2 },
          (Literal (LoxNumber 10.)))),
       (Some (Assignment (
                { tag = IDENTIFIER; lexeme = "i"; literal = LoxNil; line = 2 },
                (BinaryOp (
                   (Variable
                      { tag = IDENTIFIER; lexeme = "i"; literal = LoxNil;
                        line = 2 }),
                   { tag = PLUS; lexeme = "+"; literal = LoxNil; line = 2 },
                   (Literal (LoxNumber 1.))))
                ))),
       (Print
          (Variable
             { tag = IDENTIFIER; lexeme = "i"; literal = LoxNil; line = 2 }))
       ))
    |}]
;;

let%expect_test "function_call" = 
    "
    fun add(a,b,c){
      print a + b + c;
    }

    add(1,2,3);
    " 
    |> Lexer.scan_text 
    |> Parser.parse 
    |> Statement.print_statements;
  [%expect {|
    (FunctionDeclaration (
       { tag = IDENTIFIER; lexeme = "add"; literal = LoxNil; line = 2 },
       [{ tag = IDENTIFIER; lexeme = "a"; literal = LoxNil; line = 2 };
         { tag = IDENTIFIER; lexeme = "b"; literal = LoxNil; line = 2 };
         { tag = IDENTIFIER; lexeme = "c"; literal = LoxNil; line = 2 }],
       [(Print
           (BinaryOp (
              (BinaryOp (
                 (Variable
                    { tag = IDENTIFIER; lexeme = "a"; literal = LoxNil; line = 3
                      }),
                 { tag = PLUS; lexeme = "+"; literal = LoxNil; line = 3 },
                 (Variable
                    { tag = IDENTIFIER; lexeme = "b"; literal = LoxNil; line = 3
                      })
                 )),
              { tag = PLUS; lexeme = "+"; literal = LoxNil; line = 3 },
              (Variable
                 { tag = IDENTIFIER; lexeme = "c"; literal = LoxNil; line = 3 })
              )))
         ]
       ))
    (Expression
       (Call (
          (Variable
             { tag = IDENTIFIER; lexeme = "add"; literal = LoxNil; line = 6 }),
          { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 6 },
          [(Literal (LoxNumber 1.)); (Literal (LoxNumber 2.));
            (Literal (LoxNumber 3.))]
          )))
    |}]
;;


let%expect_test "short_circuit" = 
  "
    print \"hi\" or 2; 
    print nil or \"yes\"; 
  "
   |> Lexer.scan_text 
   |> Parser.parse 
   |> Statement.print_statements;
  [%expect {|
    (Print
       (Logical ((Literal (LoxString "hi")),
          { tag = OR; lexeme = "or"; literal = LoxNil; line = 2 },
          (Literal (LoxNumber 2.)))))
    (Print
       (Logical ((Literal LoxNil),
          { tag = OR; lexeme = "or"; literal = LoxNil; line = 3 },
          (Literal (LoxString "yes")))))
    |}]
;;  

let%expect_test "class_declaration" = 
  "
   class Bacon {
   eat() {
      print \"Crunch crunch crunch!\";
   }
   }

   Bacon().eat();
  "
   |> Lexer.scan_text 
   |> Parser.parse 
   |> Statement.print_statements;
  [%expect {|
    (ClassDeclaration (
       { tag = IDENTIFIER; lexeme = "Bacon"; literal = LoxNil; line = 2 },
       [(FunctionDeclaration (
           { tag = IDENTIFIER; lexeme = "eat"; literal = LoxNil; line = 3 },
           [], [(Print (Literal (LoxString "Crunch crunch crunch!")))]))
         ]
       ))
    (Expression
       (Call (
          (Get (
             (Call (
                (Variable
                   { tag = IDENTIFIER; lexeme = "Bacon"; literal = LoxNil;
                     line = 8 }),
                { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 8 },
                [])),
             { tag = IDENTIFIER; lexeme = "eat"; literal = LoxNil; line = 8 })),
          { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 8 },
          [])))
    |}]
;;  

let%expect_test "class_declaration" = 
   "
   class Box {}

   fun notMethod(argument) {
      print \"called function with \" + argument;
   }

   var box = Box();
   box.function = notMethod;
   box.function(\"argument\");
  "
   |> Lexer.scan_text 
   |> Parser.parse 
   |> Statement.print_statements;
  [%expect {|
    (ClassDeclaration (
       { tag = IDENTIFIER; lexeme = "Box"; literal = LoxNil; line = 2 },
       []))
    (FunctionDeclaration (
       { tag = IDENTIFIER; lexeme = "notMethod"; literal = LoxNil; line = 4 },
       [{ tag = IDENTIFIER; lexeme = "argument"; literal = LoxNil; line = 4 }],
       [(Print
           (BinaryOp ((Literal (LoxString "called function with ")),
              { tag = PLUS; lexeme = "+"; literal = LoxNil; line = 5 },
              (Variable
                 { tag = IDENTIFIER; lexeme = "argument"; literal = LoxNil;
                   line = 5 })
              )))
         ]
       ))
    (VarDeclaration
       { name = { tag = IDENTIFIER; lexeme = "box"; literal = LoxNil; line = 8 };
         init =
         (Some (Call (
                  (Variable
                     { tag = IDENTIFIER; lexeme = "Box"; literal = LoxNil;
                       line = 8 }),
                  { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 8 },
                  [])))
         })
    (Expression
       (Set (
          (Variable
             { tag = IDENTIFIER; lexeme = "box"; literal = LoxNil; line = 9 }),
          { tag = IDENTIFIER; lexeme = "function"; literal = LoxNil; line = 9 },
          (Variable
             { tag = IDENTIFIER; lexeme = "notMethod"; literal = LoxNil;
               line = 9 })
          )))
    (Expression
       (Call (
          (Get (
             (Variable
                { tag = IDENTIFIER; lexeme = "box"; literal = LoxNil; line = 10 }),
             { tag = IDENTIFIER; lexeme = "function"; literal = LoxNil; line = 10
               }
             )),
          { tag = RIGHT_PAREN; lexeme = ")"; literal = LoxNil; line = 10 },
          [(Literal (LoxString "argument"))])))
    |}]
;;
