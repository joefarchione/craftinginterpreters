open Core 

module Value = struct
  module rec T: sig
    type t = 
      | LoxBool of bool
      | LoxNumber of float
      | LoxString of string
      | LoxNil 
      | LoxFunction of lox_function
      | LoxMethod of lox_method
      | LoxClass of lox_class
      | LoxInstance of lox_instance
      [@@deriving eq, compare, sexp, show { with_path = false }]

    and lox_function =
      { 
        name : string;
        arity : int;
        callable :  t list -> t [@equal fun _ _ -> false] [@compare.ignore]  (* no equality for functions *)
      }
      [@@deriving compare, show { with_path = false }, eq]

    and lox_method =
      { 
        name : string;
        arity : int;
        callable :  lox_instance -> t list -> t [@equal fun _ _ -> false] [@compare.ignore]  (* no equality for functions *)
      }
      [@@deriving compare, show { with_path = false }, eq]

    and lox_class = {
      name: string;
      arity: int;
      methods: Coremap.SexpEqShowMap(String)(T).t
    }
    [@@deriving compare, show { with_path = false }, eq]

    and lox_instance = {
      klass: lox_class;
      fields: Coremap.SexpEqShowMap(String)(T).t;
    }
    [@@deriving compare, show { with_path = false }, eq]

    include Sexpable.S with type t:= t


  end = struct 
    module ClassFields = Coremap.SexpEqShowMap(String)(T)

    type t = 
      | LoxBool of bool
      | LoxNumber of float
      | LoxString of string
      | LoxNil 
      | LoxFunction of lox_function
      | LoxMethod of lox_method
      | LoxClass of lox_class
      | LoxInstance of lox_instance
      [@@deriving eq, compare, sexp, show { with_path = false }]

    and lox_function =
      { 
        name : string;
        arity : int;
        callable :  t list -> t [@equal fun _ _ -> false] [@compare.ignore]  (* no equality for functions *)
      }
      [@@deriving compare, show { with_path = false }, eq]

    and lox_method =
      { 
        name : string;
        arity : int;
        callable :  lox_instance -> t list -> t [@equal fun _ _ -> false] [@compare.ignore]  (* no equality for functions *)
      }
      [@@deriving compare, show { with_path = false }, eq]


    and lox_class = {
      name: string;
      arity: int;
      methods: ClassFields.t [@compare.ignore];
    }
    [@@deriving compare, show { with_path = false }, eq]

    and lox_instance = {
      klass: lox_class;
      fields: ClassFields.t [@compare.ignore];
    }
    [@@deriving compare, show { with_path = false }, eq]
  end
  include T

  module ClassFields = Coremap.SexpEqShowMap(String)(T)

  let to_string v = 
    match v with 
    | LoxBool (x) -> Printf.sprintf "%b" x
    | LoxNumber (x) -> Printf.sprintf "%g" x
    | LoxString (x) -> Printf.sprintf "%s" x
    | LoxNil  -> Printf.sprintf "Nil"
    | LoxFunction f -> Printf.sprintf "<fn %s>" f.name
    | LoxClass c -> Printf.sprintf "%s" c.name
    | LoxInstance i -> Printf.sprintf "Instance of %s" i.klass.name
    | LoxMethod f -> Printf.sprintf "<method %s>" f.name

  let float_of = function | LoxNumber (x) -> x | _ -> failwith "not a float"
  let bool_of = function | LoxBool (x) -> x | LoxNil -> false |  _ -> true
  let string_of = function | LoxString (x) -> x | _ -> failwith "not a string"

  let is_equal a b = 
    match (a, b)  with 
    | (LoxNil, LoxNil) -> true
    | (LoxNil, _) -> false
    | (a,b) -> equal a b

  let is_truthy value = bool_of value

  let find_method (name:string) (methods: ClassFields.t) = 
    match Map.find methods name with 
    | Some (v) -> Some (v)
    | None -> None

  let bind_method (m: lox_method) (i: lox_instance) : lox_function = 
    {
      name = m.name;
      arity = m.arity;
      callable = m.callable i;
    }

  let rec call (value:t)  (args: t list) =
    match value with
    | LoxFunction f -> f.callable args
    | LoxClass c -> (
        let instance = {klass=c; fields = ClassFields.empty} in
        match find_method "init" c.methods with 
        | Some(LoxMethod(f)) -> (
          let func = LoxFunction (bind_method f instance) in 
          call func args
        )
        | _ -> LoxInstance instance
    )
    | _ -> failwith "not callable"

  let get_property (name: string) (instance: lox_instance) : t = 
    match Map.find instance.fields name with 
    | Some (v) -> v
    | None -> (
      match find_method name instance.klass.methods with
      | Some (lm) -> (
        match lm with  
        | LoxMethod (m) -> bind_method m instance |> LoxFunction
        | _ -> failwith "only expected methods"
      )
      | None -> failwith "undefined property"
    )

  let set_property (name: string) (value: t) (instance: lox_instance) : lox_instance = 
    let fields = ClassFields.set name value instance.fields in
    {instance with fields = fields}

  let print v = (Printf.printf "%s") (to_string v);

end
include Value

