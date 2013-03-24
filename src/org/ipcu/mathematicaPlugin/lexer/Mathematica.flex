package org.ipcu.mathematicaPlugin.lexer;

import com.intellij.lexer.FlexLexer;
import com.intellij.psi.tree.IElementType;
import org.ipcu.mathematicaPlugin.MathematicaElementTypes;

%%

%class _MathematicaLexer
%implements FlexLexer
%unicode
%function advance
%type IElementType
%eof{ return;
%eof}


LineTerminator = \n | \r | \r\n
WhiteSpace = [\ \t\f] | {LineTerminator}

Comment   = "(*" [^*] ~"*)" | "(*" "*"+ ")"

CommentStart = "(*"
CommentEnd = "*)"

Identifier = [a-zA-Z\$] [a-zA-Z0-9\$]*
IdInContext = (`?){Identifier}(`{Identifier})*(`?)

pBase = "(?:\\d+)"
pFloat = "(?:\\.\\d+|\\d+\\.\\d*|\\d+)"
pFloatBase = "(?:\\.\\w+|\\w+\\.\\w*|\\w+)"
pPrecision = "(?:`(?:`?" {pFloat} ")?)"

Literal = [0-9]+

Slot = "#" [0-9]*
SlotSequence = "##" [0-9]*

Out = "%"+

%state IN_COMMENT
%state IN_STRING

%%

<YYINITIAL> {
	"(*"				{ yybegin(IN_COMMENT); return MathematicaElementTypes.COMMENT;}
	{WhiteSpace}+ 		{ yybegin(YYINITIAL); return MathematicaElementTypes.WHITE_SPACE; }
	\"				 	{ yybegin(IN_STRING); return MathematicaElementTypes.STRING_LITERAL; }
	{IdInContext} 		{ return MathematicaElementTypes.IDENTIFIER; }

	{Literal}	  		{ return MathematicaElementTypes.LITERAL; }

	"``"				{ return MathematicaElementTypes.ACCURACY; }

	"["					{ return MathematicaElementTypes.LEFT_BRACKET; }
	"]"					{ return MathematicaElementTypes.RIGHT_BRACKET; }
	"("					{ return MathematicaElementTypes.LEFT_PAR; }
	")"					{ return MathematicaElementTypes.RIGHT_PAR; }
	"{"					{ return MathematicaElementTypes.LEFT_BRACE; }
	"}"					{ return MathematicaElementTypes.RIGHT_BRACE; }
	"@@@"				{ return MathematicaElementTypes.APPLY1; }
	"@@"				{ return MathematicaElementTypes.APPLY; }
	"@"					{ return MathematicaElementTypes.PREFIX; }
	"/@"				{ return MathematicaElementTypes.MAP; }

	{Out}				{ return MathematicaElementTypes.OUT; }

	"^:="				{ return MathematicaElementTypes.UP_SET_DELAYED; }
	"^="				{ return MathematicaElementTypes.UP_SET; }
	":="				{ return MathematicaElementTypes.SET_DELAYED; }
	"->"				{ return MathematicaElementTypes.RULE; }
	":>"				{ return MathematicaElementTypes.RULE_DELAYED; }
	"//."				{ return MathematicaElementTypes.REPLACE_REPEATED; }
	"/."				{ return MathematicaElementTypes.REPLACE_ALL; }
	"/;"				{ return MathematicaElementTypes.CONDITION; }
	"/:"				{ return MathematicaElementTypes.TAG_SET; }

	">>>"				{ return MathematicaElementTypes.PUT_APPEND; }
	">>"				{ return MathematicaElementTypes.PUT; }
	"<<"				{ return MathematicaElementTypes.GET; }

	"___"				{ return MathematicaElementTypes.BLANK_NULL_SEQUENCE; }
	"__"				{ return MathematicaElementTypes.BLANK_SEQUENCE; }
	"_."				{ return MathematicaElementTypes.OPTIONAL; }
	"_"					{ return MathematicaElementTypes.BLANK; }

	"//"				{ return MathematicaElementTypes.POSTFIX; }

	"==="				{ return MathematicaElementTypes.SAME_Q; }
	"=!="				{ return MathematicaElementTypes.UNSAME_Q; }
	"=="				{ return MathematicaElementTypes.EQUAL; }
	"!="				{ return MathematicaElementTypes.UNEQUAL; }
	"<="				{ return MathematicaElementTypes.LESS_EQUAL; }
	">="				{ return MathematicaElementTypes.GREATER_EQUAL; }
	"<"					{ return MathematicaElementTypes.LESS; }
	">"					{ return MathematicaElementTypes.GREATER; }
	"+="				{ return MathematicaElementTypes.ADD_TO; }
	"-="				{ return MathematicaElementTypes.SUBTRACT_FROM; }
	"*="				{ return MathematicaElementTypes.TIMES_BY; }
	"/="				{ return MathematicaElementTypes.DIVIDE_BY; }

	"++"				{ return MathematicaElementTypes.INCREMENT; }
	"+"					{ return MathematicaElementTypes.PLUS; }
	"--"				{ return MathematicaElementTypes.DECREMENT; }
	"-"					{ return MathematicaElementTypes.MINUS; }
	"**"				{ return MathematicaElementTypes.NON_COMMUTATIVE_MULTIPLY; }
	"*"					{ return MathematicaElementTypes.TIMES; }
	"/"					{ return MathematicaElementTypes.DIVIDE; }



    "<>"				{ return MathematicaElementTypes.STRING_JOIN; }
    "~~"				{ return MathematicaElementTypes.STRING_EXPRESSION; }
    "~"					{ return MathematicaElementTypes.INFIX; }

    "`"					{ return MathematicaElementTypes.BACK_TICK; }

    ","					{ return MathematicaElementTypes.COMMA; }
	"..."				{ return MathematicaElementTypes.REPEATED_NULL; }
	"=."				{ return MathematicaElementTypes.UNSET; }
	".."				{ return MathematicaElementTypes.REPEATED; }
	"."					{ return MathematicaElementTypes.POINT; }
	";;"				{ return MathematicaElementTypes.SPAN; }
	";"					{ return MathematicaElementTypes.SEMICOLON; }
	"::"				{ return MathematicaElementTypes.DOUBLE_COLON; }
	":"					{ return MathematicaElementTypes.COLON; }

	"="					{ return MathematicaElementTypes.SET; }


    {SlotSequence}		{ return MathematicaElementTypes.SLOT_SEQUENCE; }
    {Slot}				{ return MathematicaElementTypes.SLOT; }

    "?"					{ return MathematicaElementTypes.QUESTION_MARK; }
    "!"					{ return MathematicaElementTypes.EXCLAMATION_MARK; }

    "||"				{ return MathematicaElementTypes.OR; }
    "|"					{ return MathematicaElementTypes.ALTERNATIVE; }
    "&&"				{ return MathematicaElementTypes.AND; }
    "&"					{ return MathematicaElementTypes.FUNCTION; }



	.       			{ return MathematicaElementTypes.BAD_CHARACTER; }
}

<IN_STRING> {
	(\\\" | [^\"])*		{ return MathematicaElementTypes.STRING_LITERAL; }
	\"					{ yybegin(YYINITIAL); return MathematicaElementTypes.STRING_LITERAL; }

}

<IN_COMMENT> {
	[^\*\)\(]*			{ return MathematicaElementTypes.COMMENT; }
	"*)"				{ yybegin(YYINITIAL); return MathematicaElementTypes.COMMENT; }
	"*"					{ return MathematicaElementTypes.COMMENT; }
	.					{ return MathematicaElementTypes.BAD_CHARACTER; }

}

.|{LineTerminator}+ 	{ return MathematicaElementTypes.BAD_CHARACTER; }