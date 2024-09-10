open Base

type t = 
| Global of Var_map.t
| Local of {enclosing: t; values: Var_map.t;}

let rec get t (s: Token.t) = 
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

let rec assign (t:t) (token:Token.t) (v: Value.t) : t = 
  match t with 
  | Global (g) -> 
    let env = 
      match Map.find g token.lexeme with 
      | Some (_) -> Map.update g token.lexeme ~f:(fun _-> v) 
      | None -> failwith ((Printf.sprintf "undefined variable %s") token.lexeme) in 
    Global env
  | Local (l) -> 
    match Map.find l.values token.lexeme with
    | Some (_) -> Local {enclosing = l.enclosing; values = Map.update l.values token.lexeme ~f:(fun _-> v);}
    | None -> assign l.enclosing token v 

let create_local (t:t) : t = 
  match t with 
  | Global (g) -> Local {enclosing = t; values = g;}
  | Local (l) -> Local {enclosing = t; values = l.values;}


