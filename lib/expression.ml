open Core 

type t = 
| Literal of Value.t
| BinaryOp of t * Token.t * t
| Unary of Token.t * t
| Call of t * Token.t * t list
| Grouping of t
| Variable of Token.t
| Assignment of Token.t * t
| Logical of t * Token.t * t
[@@deriving eq, sexp, show { with_path = false }]

let compare (a:t) (b:t) : int = if equal a b then 1 else 0

let print t = (Printf.printf "%s\n" (show t))
let print_expressions exprs = List.iter exprs ~f:print

