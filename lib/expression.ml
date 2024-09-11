type op = 
| Plus
| Minus
| Bang
| Slash
| Star
| Equal_equal
| Bang_equal
| Greater
| Greater_equal
| Less
| Less_equal
[@@deriving  eq,  show { with_path = false }]

type logical_op = 
| And 
| Or
[@@deriving  eq,  show { with_path = false }]

type t = 
| Literal of Value.t
| BinaryOp of t * op * t
| Unary of op * t
| Call of t * Token.t * t list
| Grouping of t
| Variable of Token.t
| Assignment of Token.t * t
| Logical of t * logical_op * t
[@@deriving eq,show { with_path = false }]

