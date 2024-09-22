open Core

module ValuesMap = struct
  include Coremap.SexpEqShowMap(String [@deriving compare, sexp])(Value)
  let define k v t  = 
    match Map.add t ~key:k ~data:v with
    | `Ok (v) -> v
    | `Duplicate -> Map.set t ~key:k ~data:v

  let contains (name:string) t = 
    match Map.find t name with
    | Some (_) -> true
    | None -> false
  
  let assign (name: string) (value: Value.t) t = 
      if contains name t then
        (Map.update t name ~f:(fun _-> value))
      else 
        raise Lox_error.(RunTimeError (name, "Undefined variable"))


  let get (name: string) (t:t) = 
    match Map.find t name with 
      | Some v -> v
      | None -> raise Lox_error.(RunTimeError (name, "Undefined variable"))
    
end 

type t = ValuesMap.t list [@@deriving show {with_path=false}]
let empty = ValuesMap.empty :: []
let is_empty t = List.is_empty t

let print (t:t) = List.iter t ~f:(fun m -> ValuesMap.print m)

let pop (t:t) = 
  match t with 
  | _ :: tl -> tl
  | _ -> failwith "only one environment"

let rec get (name: string) (t:t) : Value.t = 
  match t with 
  | [] -> raise Lox_error.(RunTimeError (name, "Empty enviroment"))
  | hd :: tl -> 
    if ValuesMap.contains name hd then
      ValuesMap.get name hd
    else
      get name tl

let define token value (t:t) = 
  match t with 
  | hd::tl -> (ValuesMap.define token value hd) :: tl
  | _ -> 
    let env = ValuesMap.empty in 
    (ValuesMap.define token value env) :: []

let assign (name: string) (value:Value.t) (t:t) : t = 
  let rec assign_ (name:string) value (t:t) (t_out:t) : t = 
    match t with 
    | [] -> raise Lox_error.(RunTimeError (name, "Undefined variable"))
    | hd :: tl -> 
      if ValuesMap.contains name hd then
        t_out @ (ValuesMap.assign name value hd :: tl)
      else
        assign_ name value tl (t_out @ [hd]) in 
  assign_ name value t []
    

let create_local (t:t) : t = ValuesMap.empty :: t
let get_global (t:t) : ValuesMap.t = 
  match List.last t with
  | Some (l) -> l
  | None -> ValuesMap.empty

let ancestor (distance:int) (t:t) = 
  match List.nth t distance with 
  | Some(l) -> l
  | None -> raise Lox_error.(RunTimeError (Printf.sprintf "%d" distance, "Undefined environment"))

let get_at distance token t = ancestor distance t |> ValuesMap.get token

let assign_at (distance:int) (name:string) (value: Value.t) (t:t) = 
  List.mapi t ~f:(fun idx env -> 
    if idx = distance then 
        (ValuesMap.assign name value env)
    else 
      env
  )
  
