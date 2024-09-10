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
[@@deriving  show { with_path = false }]

type expr = 
| Literal of Value.t
| BinaryOp of expr * op * expr
| Unary of op * expr
| Grouping of expr
| Variable of Token.t
| Assignment of Token.t * expr
[@@deriving  show { with_path = false }]

