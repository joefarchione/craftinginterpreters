open Core

type t = (string, Value.t, String.comparator_witness) Map.t

let empty = Map.empty (module String)
let to_list t = Map.to_alist t

let define t k v  = 
  match Map.add t ~key:k ~data:v with
  | `Ok (v) -> v
  | `Duplicate -> Map.set t ~key:k ~data:v