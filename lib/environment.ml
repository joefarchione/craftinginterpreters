open Core

module VarMap = struct 
  type t = (string, Value.t, String.comparator_witness) Map.t

  let empty = Map.empty (module String)
  let to_list t = Map.to_alist t

  let define t k v  = 
    match Map.add t ~key:k ~data:v with
    | `Ok (v) -> v
    | `Duplicate -> Map.set t ~key:k ~data:v

  let contains t k = 
    match Map.find t k with
    | Some (_) -> true
    | None -> false

end

type t = 
| Global of VarMap.t
| Local of {enclosing: t; values: VarMap.t;}

let rec get (t:t) (s: Token.t) = 
  match t with 
  | Global (g) -> 
    let value = match Map.find g s.lexeme with 
      | Some v -> v 
      | None -> failwith ((Printf.sprintf "undefined variable %s") s.lexeme) in 
    value
  | Local (l) -> 
    let value = match Map.find l.values s.lexeme with
    | Some (v) -> v
    | None -> get l.enclosing s in 
    value

let define (t:t) k v = 
  match t with 
  | Global (g) -> Global (VarMap.define g k v)
  | Local (l) -> Local {enclosing = l.enclosing; values=VarMap.define l.values k v}

let rec assign (t:t) (token:Token.t) (v: Value.t) : t = 
  match t with 
  | Global (g) -> 
    let env = 
      if VarMap.contains g token.lexeme then
        Map.update g token.lexeme ~f:(fun _-> v) 
      else 
        failwith ((Printf.sprintf "undefined variable %s") token.lexeme) in 
    Global env
  | Local (l) -> 
    if VarMap.contains l.values token.lexeme then
      Local {enclosing = l.enclosing; values = Map.update l.values token.lexeme ~f:(fun _-> v);}
    else
      assign l.enclosing token v 

let create_local (t:t) : t = 
  match t with 
  | Global (g) -> Local {enclosing = t; values = g;}
  | Local (l) -> Local {enclosing = t; values = l.values;}

let rec get_global (t:t) : t = 
  match t with 
  | Global (g) -> Global (g)
  | Local (l) -> get_global l.enclosing

let rec ancestor (distance:int) (t:t) : t = 
  match t with
  | Global (_) -> t
  | Local (l) -> 
    match distance with 
    | 0 -> t
    | _ -> ancestor (distance-1) l.enclosing

let get_at distance token t = 
  let env = ancestor distance t in 
  get env token

let assign_at distance (token:Token.t) value t = 
  let env = ancestor distance t in
  define env token.lexeme value









