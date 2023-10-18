grammar BehaviorNet;

behavior
    : BEHAVIOR qualifiedName? OPEN_BRACE element* CLOSE_BRACE
    ;

element
    : place
    | transition
    | edgeChain
    ;

place
    : PLACE idList ACCEPTING?
    ;

transition
    : TRANSITION ID OPEN_BRACE condition? CLOSE_BRACE
    ;

condition
    : ID OPEN_PARENS (argument (COMMA argument)*)? CLOSE_PARENS returnClause? inClause? whereClause?
    ;

argument
    : ID       # idArgument
    | DISCARD  # discardArgument
    ;

returnClause
    : EDGE argument
    ;

inClause
    : IN processClause? threadClause?
    ;

processClause
    : PROCESS ID
    ;

threadClause
    : THREAD ID
    ;

whereClause
    : WHERE expression+
    ;

expression
    : OPEN_PARENS expression CLOSE_PARENS                                        # parensExpression
    | OP_NOT expression                                                          # notExpression
    | expression OP_MUL expression                                               # multiplicativeExpression
    | expression OP_ADD expression                                               # additiveExpression
    | expression OP_BIT expression                                               # bitwiseExpression
    | expression OP_REL expression                                               # relationalExpression
    | expression IN expression                                                   # inExpression
    | expression OP_AND expression                                               # andExpression
    | expression OP_OR expression                                                # orExpression
    | OPEN_BRACKET expression RANGE_DOTS expression CLOSE_BRACKET                # rangeExpression
    | NUM                                                                        # numberExpression
    | STR                                                                        # stringExpression
    | BOOL                                                                       # boolExpression
    | ID                                                                         # identifierExpression
    ;

edgeChain
    : ID (EDGE ID)+
    ;

idList
    : OPEN_BRACKET ID+ CLOSE_BRACKET
    | ID
    ;

qualifiedName
    : ID
    | STR
    ;

BEHAVIOR      : 'behavior';
ACCEPTING     : 'accepting';
PLACE         : 'place';
TRANSITION    : 'transition';
WHERE         : 'where';
IN            : 'in';
PROCESS       : 'process';
THREAD        : 'thread';
OPEN_BRACE    : '{';
CLOSE_BRACE   : '}';
OPEN_BRACKET  : '[';
CLOSE_BRACKET : ']';
OPEN_PARENS   : '(';
CLOSE_PARENS  : ')';
EDGE          : '->';
COMMA         : ',';
DISCARD       : '_';
OP_ADD        : '+' | '-';
OP_MUL        : '*' | '/' | '%';
OP_REL        : '<=' | '<' | '>=' | '>' | '==' | '!=' ;
OP_AND        : 'and';
OP_OR         : 'or';
OP_BIT        : '&' | '|' | '^';
OP_NOT        : '-' | '~';
RANGE_DOTS    : '..';

BOOL          : 'true' | 'false'
              ;

NUM           : [0-9]+
              | '0x' [0-9a-fA-F]+
              | [0-9a-fA-F]+ 'h'
              ;

ID            : [a-zA-Z_] [a-zA-Z0-9_]*
              ;

STR           : ('"' (~["\n\\] | '\\"' | '\\\\' | '\\n' | '\\r' | '\\t' )* '"')+
              ;

WS           : [\r\n\t ]+ -> skip;
