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
[@@deriving  show { with_path = false }]

type stmt = 
| IfThenElse of expr * stmt * stmt
| Print of expr
[@@deriving  show { with_path = false }]

