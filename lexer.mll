{
  open Parser
}

let blank = [' ' '\009' '\012' '\010' '\013' ]
let lowercase = ['a'-'z' '\223'-'\246' '\248'-'\255' '_']
let uppercase = ['A'-'Z' '\192'-'\214' '\216'-'\222']
let identchar =
  ['A'-'Z' 'a'-'z' '_' '\192'-'\214' '\216'-'\246' '\248'-'\255' '\'' '0'-'9']


rule token = parse
  | blank+  { token lexbuf }
  | lowercase identchar* {
      match Lexing.lexeme lexbuf with
	| "let" -> LET
	| "in" -> IN
	| "if" -> IF
	| "then" -> THEN
	| "else" -> ELSE
	| "type" -> TYPE
	| "expr" -> EXPR
	| "rand" -> RAND
	| s -> LIDENT s
    }
  | uppercase identchar* { UIDENT (Lexing.lexeme lexbuf) }
  | "=" { EQUAL }
  | "," { COMMA }
  | ['0'-'9']+ { INT (int_of_string (Lexing.lexeme lexbuf)) }
  | "(" { LPAREN }
  | ")" { RPAREN }
  | "<" { LEFT }
  | ">" { RIGHT }
  | "|" { PIPE }
  | "&" { AMPERSAND }
  | "/*" { comment lexbuf }
  | eof { EOF }

and comment = parse
  | "*/" { token lexbuf }
  | _    { comment lexbuf }