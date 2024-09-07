open Expression
let matches tag tags = List.mem tag tags


let consume (tokens: Token.t list) tag message = 
  match tokens with 
  | hd :: tl when hd.tag = tag -> tl
  | _ -> failwith message
     
let rec primary (tokens:Token.t list) : (expr * Token.t list)  =
  match tokens with 
  | [] -> failwith "incorrect token"
  | hd :: tl -> 
    match hd.tag with 
    | Token.FALSE 
    | Token.TRUE 
    | Token.NIL 
    | Token.STRING 
    | Token.NUMBER -> (Expression.(Literal hd.literal), tl)
    | Token.LEFT_PAREN -> (
      let (exprs, rest) = expression tl in 
      let rest = consume rest RIGHT_PAREN "Expect ')' after expression" in 
      (Expression.(Grouping exprs), rest)
    )
    | _ ->  failwith "incorrect token" 

and unary (tokens: Token.t list): (expr * Token.t list) =
  match tokens with 
  | hd :: tl when hd.tag = Token.BANG -> 
    let right, rest  = unary tl in 
    (Unary (Bang, right), rest)
  | hd :: tl when hd.tag = Token.MINUS -> 
    let right, rest  = unary tl in 
    (Unary (Minus, right), rest)
  | _ -> primary tokens

and factor (tokens: Token.t list) : (expr * Token.t list) = 
  let (left, rest) = unary tokens in 
  match rest with 
  | hd :: tl when hd.tag = Token.SLASH -> 
      let (right, rest) = unary tl in 
      (BinaryOp (left, Slash, right), rest)
  | hd :: tl when hd.tag = Token.STAR -> 
      let (right, rest) = unary tl in 
      (BinaryOp (left, Star, right), rest)
  | _ -> (left, rest)


and term (tokens: Token.t list) : (expr * Token.t list) = 
  let (left, rest) = factor tokens in 
  match rest with 
  | hd :: tl when hd.tag = Token.MINUS -> 
      let (right, rest) = factor tl in 
      (BinaryOp (left, Minus, right), rest)
  | hd :: tl when hd.tag = Token.PLUS -> 
      let (right, rest) = factor tl in 
      (BinaryOp (left, Plus, right), rest)
  | _ -> (left, rest)

and comparison (tokens: Token.t list) : (expr * Token.t list) = 
  let (left, rest) = term tokens in 
  match rest with 
  | hd :: tl when hd.tag = Token.GREATER -> 
      let (right, rest) = term tl in 
      (BinaryOp (left, Greater, right), rest)
  | hd :: tl when hd.tag = Token.GREATER_EQUAL -> 
      let (right, rest) = term tl in 
      (BinaryOp (left, Greater_equal, right), rest)
  | hd :: tl when hd.tag = Token.LESS -> 
      let (right, rest) = term tl in 
      (BinaryOp (left, Less, right), rest)
  | hd :: tl when hd.tag = Token.LESS_EQUAL -> 
      let (right, rest) = term tl in 
      (BinaryOp (left, Less_equal, right), rest)
  | _ -> (left, rest)


and equality (tokens: Token.t list) : (expr * Token.t list) = 
  let (left, rest) = comparison tokens in 
  match rest with 
  | hd :: tl when hd.tag = Token.EQUAL_EQUAL -> 
      let (right, rest) = comparison tl in 
      (BinaryOp (left, Equal_equal, right), rest)
  | hd :: tl when hd.tag = Token.BANG_EQUAL -> 
      let (right, rest) = comparison tl in 
      (BinaryOp (left, Bang_equal, right), rest)
  | _  -> (left, rest)
  

and expression tokens = equality tokens

(* TODO implement syncrhonize parser to catch error result types and then move to the next key word type*)
