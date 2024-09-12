open Core

module ValuesMap = struct 
  type t = (string, Value.t, String.comparator_witness) Map.t

  let empty = Map.empty (module String)
  let to_list t = Map.to_alist t

  let define k v t  = 
    match Map.add t ~key:k ~data:v with
    | `Ok (v) -> v
    | `Duplicate -> Map.set t ~key:k ~data:v

  let contains (token:Token.t) t = 
    match Map.find t token.lexeme with
    | Some (_) -> true
    | None -> false
  
  let assign (token:Token.t) (value: Value.t) t = 
      if contains token t then
        (Map.update t token.lexeme ~f:(fun _-> value))
      else 
        raise Lox_error.(RunTimeError (token.lexeme, "Undefined variable"))

    let get (token: Token.t) (t:t) = 
      match Map.find t token.lexeme with 
        | Some v -> v
        | None -> raise Lox_error.(RunTimeError (token.lexeme, "Undefined variable"))

end

type t = ValuesMap.t list
let empty = ValuesMap.empty :: []
let is_empty t = List.is_empty t

let rec get (token: Token.t) (t:t) : Value.t = 
  match t with 
  | [] -> raise Lox_error.(RunTimeError (token.lexeme, "Empty enviroment"))
  | hd :: tl -> 
    if ValuesMap.contains token hd then
      ValuesMap.get token hd
    else
      get token tl

let define token value (t:t) = 
  match t with 
  | hd::tl -> (ValuesMap.define token value hd) :: tl
  | _ -> 
    let env = ValuesMap.empty in 
    (ValuesMap.define token value env) :: []

let assign (token:Token.t) (value:Value.t) (t:t) : t = 
  let rec assign_ (token:Token.t) value (t:t) (t_out:t) : t = 
    match t with 
    | [] -> raise Lox_error.(RunTimeError (token.lexeme, "Undefined variable"))
    | hd :: tl -> 
      if ValuesMap.contains token hd then
        t_out @ (ValuesMap.assign token value hd :: tl)
      else
        assign_ token value tl (t_out @ [hd]) in 
  assign_ token value t []
    

let create_local (t:t) : t = ValuesMap.empty :: t
let get_global (t:t) : ValuesMap.t = 
  match List.last t with
  | Some (l) -> l
  | None -> ValuesMap.empty

let ancestor distance (t:t) = 
  match List.nth t distance with 
  | Some(l) -> l
  | None -> raise Lox_error.(RunTimeError (Printf.sprintf "%d" distance, "Undefined environment"))

let get_at distance token t = ancestor distance t |> ValuesMap.get token
let assign_at (distance:int) (token:Token.t) (value: Value.t) (t:t) = 
  List.mapi t ~f:(fun idx env -> 
    if idx = distance then 
        (ValuesMap.assign token value env)
    else 
      env
  )
  
