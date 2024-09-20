open Core 

type t = 
  | LoxBool of bool
  | LoxNumber of float
  | LoxString of string
  | LoxNil 
  | LoxFunction of lox_function
  [@@deriving eq, sexp, show { with_path = false }]

and lox_function =
  { 
    name : string;
    arity : int;
    callable : t list -> t [@equal fun _ _ -> false]  (* no equality for functions *)
  }
  [@@deriving show { with_path = false }, eq]


let to_string v = 
  match v with 
  | LoxBool (x) -> Printf.sprintf "%b" x
  | LoxNumber (x) -> Printf.sprintf "%g" x
  | LoxString (x) -> Printf.sprintf "%s" x
  | LoxNil  -> Printf.sprintf "Nil"
  | LoxFunction f -> Printf.sprintf "<fn %s>" f.name

let float_of = function | LoxNumber (x) -> x | _ -> failwith "not a float"
let bool_of = function | LoxBool (x) -> x | _ -> true
let string_of = function | LoxString (x) -> x | _ -> failwith "not a string"

let is_equal a b = 
  match (a, b)  with 
  | (LoxNil, LoxNil) -> true
  | (LoxNil, _) -> false
  | (a,b) -> equal a b

let is_truthy value = bool_of value

let call value args =
  match value with
  | LoxFunction f -> f.callable args
  | _ -> failwith "not callable"

let print v = (Printf.printf "%s") (to_string v)