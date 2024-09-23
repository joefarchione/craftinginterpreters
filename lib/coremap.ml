open Core 

module SexpEqShowMap = functor 
  (K : sig
      type t
      include Sexpable.S with type t := t
      include Comparable.S with type t := t
   end) 
  (S: Sexpable.S) -> struct

  type t = S.t Map.M(K).t [@@deriving sexp]

  let show (t:t) = 
    sexp_of_t t
    |> Sexp.to_string_hum

  let pp (fmt: Format.formatter) (t:t) : unit = 
    Format.fprintf fmt "%s" (show t)
  
  let equal (m1:t) (m2:t): bool = 
    Poly.((Map.to_tree m1) = (Map.to_tree m2))

  let empty : t = Map.empty (module K)

  let get k t = 
    match Map.find t k with 
    | Some (v) -> v
    | None -> failwith "couldn't find"

  let set k v t  = 
    match Map.add t ~key:k ~data:v with
    | `Ok (v) -> v
    | `Duplicate -> Map.set t ~key:k ~data:v



  let print t = Format.printf "%s\n" (show t)
end

