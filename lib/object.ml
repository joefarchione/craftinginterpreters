open Core 

module ClassFields = Coremap.SexpEqShowMap(String [@deriving sexp])(Value)

type t = 
  | Value of Value.t
  | LoxClass of lox_class
  | LoxInstance of lox_instance
  [@@deriving eq, sexp, show { with_path = false }]

and lox_class =
  { 
    name : string;
  }
  [@@deriving sexp, show { with_path = false }, eq]


and lox_instance = { 
    klass : lox_class;
    fields: ClassFields.t
  }
  [@@deriving sexp, show { with_path = false }, eq]


let to_string v = 
  match v with 
  | Value(v) -> Value.to_string v
  | LoxClass c -> Printf.sprintf "%s" c.name
  | LoxInstance c -> Printf.sprintf "%s instance" c.klass.name

let call t = 
  match t with
  | LoxClass c -> {klass=c; fields=ClassFields.empty}
  | _ -> failwith "not a callable"

