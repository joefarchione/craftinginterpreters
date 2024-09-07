type t = 
  | LoxBool of bool
  | LoxNumber of float
  | LoxString of string
  | LoxNil 
[@@deriving  show { with_path = false }]

let to_string v = 
  match v with 
  | LoxBool (x) -> Printf.sprintf "%b" x
  | LoxNumber (x) -> Printf.sprintf "%g" x
  | LoxString (x) -> Printf.sprintf "%s" x
  | LoxNil  -> Printf.sprintf "Nil"

let float_of = function | LoxNumber (x) -> x | _ -> failwith "not a float"
let bool_of = function | LoxBool (x) -> x | _ -> true
let string_of = function | LoxString (x) -> x | _ -> failwith "not a string"

let is_equal a b = 
  match (a, b)  with 
  | (LoxNil, LoxNil) -> true
  | (LoxNil, _) -> false
  | (a,b) -> a = b

let is_truthy value = bool_of value
