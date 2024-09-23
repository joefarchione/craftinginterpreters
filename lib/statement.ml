open Core 

type variable = {name: Token.t; init: Expression.t option;} (*implement option type?*)
[@@deriving  show { with_path = false }]


type t = 
| Expression of Expression.t
| Print of Expression.t
| VarDeclaration of variable
| Block of t list
| If of Expression.t * Expression.t
| IfElse of Expression.t * Expression.t * Expression.t
| While of Expression.t * Expression.t
| FunctionDeclaration of Token.t * Token.t list * t list
| For of t option * Expression.t * Expression.t option * t
| ClassDeclaration of Token.t * Expression.t option * t list
| Return of Expression.t option
[@@deriving  show { with_path = false }]


let print stmt = 
  (Printf.printf "%s\n") (show stmt)

let print_statements stmts = 
  List.iter ~f:print stmts;
  (Printf.printf "\n");





