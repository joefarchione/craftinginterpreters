type variable = {name: Token.t; init: Expression.t;}
[@@deriving  show { with_path = false }]

type t = 
| Expression of Expression.t
| Print of Expression.t
| VarDeclaration of variable
| Block of t list
| If of Expression.t * t
| IfElse of Expression.t * t * t
| While of Expression.t * t
| For of t option * Expression.t option * Expression.t option * t
| FunctionDeclaration of Token.t * Token.t list * t list
[@@deriving  show { with_path = false }]





