open Olox_lib

let%expect_test "var_assignment" = 
    "
    var a = 10;
    var b;

    b = a + 1;
    
    print b;
    " 
    |> Interpreter.interpret;
  [%expect {| 11 |}]
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
    |> Interpreter.interpret;
  [%expect {| 01234 |}]
;;



let%expect_test "short_circuit" = 
  "
    print \"hi\" or 2; 
    print nil or \"yes\"; 
  "
    |> Interpreter.interpret;
  [%expect {|hiyes|}]


let%expect_test "init_for_local_variable" = 
    try
      "
      var a = \"outer\";
      {
        var a = a;
      }
      " 
      |> Interpreter.interpret
    with 
    | Lox_error.RunTimeError (variable, message)  -> Printf.printf "%s %s" variable message;
  [%expect {| a Can't read local variable in it's own initializer |}]
;; 

let%expect_test "for_loop" = 
    "
    for (var i = 0; i < 10; i = i + 1) print i;
    " 
    |> Interpreter.interpret;
  [%expect {| 0123456789 |}]
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
  |> Interpreter.interpret;
  [%expect {| Crunch crunch crunch! |}]
;; 

let%expect_test "class_function_as_property" = 
   "
   class Box {}

   fun notMethod(argument) {
      print \"called function with \" + argument;
   }

   var box = Box();
   box.function = notMethod;
   box.function(\"argument\");
  "
  |> Interpreter.interpret;
  [%expect {| called function with argument |}]
;;

