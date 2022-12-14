%{
open Ast
open Term
open Type
%}

%token EOF
%token <string> IDENTIFIER
// keyword or symbol
%token LET
%token LAM
%token DOT
%token EQ
%token COLON
%token COMMA
%token L_PAREN
%token R_PAREN
%token L_BRACE
%token R_BRACE
%token RUN
// type
%token TYPE_MARK
%token ARROW
// term
%token CONST_MARK

%type <Ast.program> program
%start program

%type <Type.typ> typ

%%

program:
  | top* EOF { $1 }
  ;

top:
  | LET s=IDENTIFIER COLON ty=marked_typ EQ e=expr COMMA
    { Let (s, ty, e) }
  | RUN e=expr COMMA { Run e }
  ;

marked_typ: TYPE_MARK L_BRACE t=typ R_BRACE { t }
typ:
  | t=IDENTIFIER { Ty t }
  | t1=typ ARROW t2=typ { Arrow (t1, t2) }

expr:
  | CONST_MARK L_BRACE t=typ R_BRACE { Const t }
  | L_PAREN f=expr arg=expr R_PAREN { App (f, arg) }
  | LAM id=IDENTIFIER DOT e=expr { Lambda (id, e) }
  | v=IDENTIFIER { Var v }
  ;
