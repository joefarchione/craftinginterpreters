type variable = {name: Token.t; init: Expression.expr;}
[@@deriving  show { with_path = false }]

type t = 
| Expression of Expression.expr 
| Print of Expression.expr
| Var of variable
| Block of t list
[@@deriving  show { with_path = false }]




