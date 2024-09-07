open Expression

let (let*) = Result.bind
type eval_result = (Value.t, expr) result

let rec evaluate (expr: expr) : eval_result = 
  match expr with 
  | Literal (l) ->  Ok(l)
  | BinaryOp (a, o, b) ->  (
    let* left  = evaluate a in 
    let* right = evaluate b in 
    match (o, left, right) with 
    | (Plus, LoxString(l), LoxString(r)) -> Ok (Value.LoxString (l ^ r))
    | (Plus, LoxNumber (l), LoxNumber (r)) ->  Ok (Value.LoxNumber (l +. r))
    | (Minus, LoxNumber(l), LoxNumber (r)) -> Ok (Value.LoxNumber (l -. r))
    | (Slash, LoxNumber(l), LoxNumber (r)) -> Ok(Value.LoxNumber (l /.r ))
    | (Star, LoxNumber(l), LoxNumber (r)) -> Ok(Value.LoxNumber (l *. r))
    | (Greater, LoxNumber(l), LoxNumber (r)) -> Ok(Value.LoxBool (l > r))
    | (Greater_equal, LoxNumber(l), LoxNumber (r)) -> Ok(Value.LoxBool (l >= r))
    | (Less, LoxNumber(l), LoxNumber (r)) -> Ok(Value.LoxBool (l < r))
    | (Less_equal, LoxNumber(l), LoxNumber (r)) -> Ok(Value.LoxBool (l <= r))
    | (Bang_equal, _, _) -> Ok(Value.LoxBool (not (Value.is_equal left right)))
    | (Equal_equal, _, _) -> Ok(Value.LoxBool (Value.is_equal left right))
    | _ -> Error (expr)
  )
  | Unary (o, a) -> (
    let* right = evaluate a in 
    match o with 
    | Bang -> Ok(Value.LoxBool (Value.is_truthy right))
    | Minus -> Ok(Value.LoxNumber (-1.0 *. (Value.float_of right)))
    | _ -> Error expr
  )
  | Grouping (e) -> (evaluate e)


let%test "eval" = 
    "4 + 2 ("
      |> Scanner.scan_text
      |> (fun tokens -> 
          List.iter (fun token -> (Printf.printf "%s\n") (Token.show token)) tokens; 
          Parser.expression tokens)
      |> (fun (e, _) -> 
        (Printf.printf "%s\n") (Expression.show_expr e); 
        let result = evaluate e in 
        match result with  
        | Ok (v) -> v
        | Error (_)  -> failwith "incorrect"
      )
      |> Value.to_string
      |> Printf.printf "%s\n";
    true
