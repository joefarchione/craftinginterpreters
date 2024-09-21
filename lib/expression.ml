open Core 

module Expression = struct
  type t = 
  | Literal of Value.t 
  | BinaryOp of t * Token.t * t
  | Unary of Token.t * t
  | Call of t * Token.t * t list
  | Grouping of t
  | Variable of Token.t
  | Assignment of Token.t * t
  | Logical of t * Token.t * t
  | Get of t  * Token.t
  | Set of t * Token.t * t
  [@@deriving eq, sexp, compare, show { with_path = false }]

  let print t = (Printf.printf "%s\n" (show t))
  let print_expressions exprs = List.iter exprs ~f:print
end 
include Comparable.Make(Expression)
include Expression


