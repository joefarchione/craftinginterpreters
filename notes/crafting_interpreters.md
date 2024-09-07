# Crafting Interpreters

# A Map of the Territory

Front End
1. Scanning (lexing) := conversion of characters to tokens
2. Parsing := conversion of tokens to tree (parse or abstract syntax tree) (syntax error)
3. Static analysis := binding/resolution for each identifier (type errors)

Middle End
1. Intermediate representation := interface between source and destination languages
2. Optimization := Conversion to more efficient program with the same semantics

Back End
1. Code generation := Conversion to CPU instructions (bytecode is portable to different machines)
2. Targets := target VM allowing it to run anywhere that target language is (VM in C)

Alternatives
1. Singple pass compilers := interleave parsing, analysis & code generation without syntax trees or IRs (why we have limits in C - explicit function forward declaration)
2. Tree-walk interpreters := excute right after AST creation (is slow)
3. Transpilers := compile to another source langauge
4. Just-in-time compilation := native compilation when program is loaded

Compilers v. interpretation 
1. Compiling := implenetation technique for converting source langague to a "lower-level" form
2. Interpreter := conversts source code and executes it immediately (i.e. runs programs from source) 

CPython is an interpreter that haws a compiler. 

# The Lox Language

Lox is
- Dynamically typed
- Automatically memory-managed (with GC)
- Data types (booleans, numbers, strings, nil, expressions)

Note on OOP
- Implemetations not well covered - so we cover them here
- Static dispatch := instance method look up at compile time
- Dynamic dispatch := instance method look up at run time