%{
	#include "parser.tab.h"
	int countn = 0;
	extern int currentIndent;
%}

%option yylineno

letter [a-zA-Z]
digit [0-9]

%%

"begin"				{ return BEGINPROGRAM; }
"end"				{ return ENDBLOCK; }
"real"				{ return REAL; }
"int"				{ return INT; }
"string"			{ return STRING; }
"char"				{ return CHAR; }
"boolean"			{ return BOOLEAN; }
"true"				{ return TRUE; }
"false"				{ return FALSE; }
"func"				{ return FUNC; }
"repeat"			{ return REPEAT; }
"when"				{ return WHILE; }
"is"				{ return IF; }
"otherwise"			{ return ELSE; }
"return"			{ return RETURN; }
"write"				{ return PRINT; }
"read"				{ return SCAN; }


{letter}({letter}|{digit})*	{  yylval.str_val = strdup(yytext); return VAR; }
[-]?[0-9]+\.[0-9]{1,6}    { yylval.str_val = strdup(yytext); return REAL_NUMBER; }
[-]?[0-9]+                { yylval.str_val = strdup(yytext); return INT_NUMBER; }
\".*\"                    { yylval.str_val = strdup(yytext); return STR; }
\'.*\'                    { yylval.str_val = strdup(yytext); return CHARACTER; }


":"				{ return COLON; }
"<-"				{ return ASSIGN; }
"->"				{ return RETURNTYPE; }
"+"				{ return SUM; }
"-"				{ return SUBTRACTION; }
"*"				{ return MULTIPLICATION; }
"/"				{ return DIVISION; }
"^"				{ return EXPONENTIATION; }
"%"				{ return RESTDIV; }
"?"				{ return QUESTION; }

">"				{ return GT; }
"<" 				{ return LT; }
"<="				{ return LE; }
">="				{ return GE; }
"!="				{ return NE; }
"=="				{ return EQ; }

"&&"				{ return AND; }
"||"				{ return OR; }
"!"				{ return NEG; }


"("				{ return OPENPAR; }
")"				{ return CLOSEPAR; }
"["				{ return OPENBR; }
"]"				{ return CLOSEBR; }
"{"				{ return OPENCUR; }
"}"				{ return CLOSECUR; }
","				{ return SEPARATOR; }
"."				{ return DECIMAL; }


\#\#.*\n			{ ; }
\#\#(.*\n)*.*\#\#		{ ; }



^[ \t]+	{/*
            // Count the number of spaces or tabs
            int count = 0;
            for (int i = 0; i < yyleng; i++) {
                if (yytext[i] == ' ') {
                    count++;
                } else if (yytext[i] == '\t') {
                    count += 4;  // Assuming each tab is equivalent to 4 spaces
                }
            }

            if (count > currentIndent){
                currentIndent = count;
                return INDENT;
                
            } else if (count < currentIndent) {
                currentIndent = count;
                //printf("dedent");
                return DEDENT;
            }
            */
        }

         
[ ]* { ; }

[\n] { return NEWLINE; }


.	{ return *yytext; }


%%
int yywrap()
{
	return 1;
}
