open Base

type t = (string, Value.t, String.comparator_witness) Map.t

let empty = Map.empty (module String)
let to_list t = Map.to_alist t