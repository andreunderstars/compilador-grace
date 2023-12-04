%{
	#include<stdio.h>
	#include<math.h> 
	#include<stdlib.h>
	#include<string.h>
	#include <cstdio>
	#include <iostream>

	using namespace std;
	#include"lex.yy.c"
	
	extern int yyparse();
	extern FILE *yyin;
    FILE *outputFile;

	void yyerror(const char *s);
	int yylex();
	int yywrap();
%}


%union {//used for semantic analysis to identify numbers, symbols, text, etc.
    char *str_val;
}

%token <str_val> INT_NUMBER REAL_NUMBER STR CHARACTER TRUE FALSE

%type <str_val> declarenoassign declareassign datatype literal value num bool exp arithmetic par operation logic negs logical relation relationterm relational read assignment loop conditional else write content
%token <str_val> VAR INT REAL STRING CHAR BOOLEAN

%token <str_val> BEGINPROGRAM ENDBLOCK NEWLINE FUNC REPEAT WHILE IF ELSE RETURN PRINT SCAN ASSIGN RETURNTYPE SUM SUBTRACTION MULTIPLICATION DIVISION EXPONENTIATION RESTDIV QUESTION GT LT LE GE NE EQ AND OR NEG COLON OPENPAR CLOSEPAR OPENBR CLOSEBR OPENCUR CLOSECUR SEPARATOR DECIMAL
 
%%

program: BEGINPROGRAM VAR COLON {fprintf(outputFile, "int main(){\n");} body;
;

body:ENDBLOCK
	|NEWLINE body
	|command NEWLINE body
    ;

command: declaration
| exp
| assignment
| loop
| conditional
| else
| read
| write
;

declaration: declarenoassign
| declareassign
;

declarenoassign: VAR COLON INT {
    fprintf(outputFile, "int %s;\n", $1);
}
| VAR COLON REAL {
    fprintf(outputFile, "float %s;\n", $1);
}
| VAR COLON STRING {
    fprintf(outputFile, "string %s;\n", $1);
}
| VAR COLON CHAR {
    fprintf(outputFile, "char %s;\n", $1);
}
| VAR COLON BOOLEAN {
    fprintf(outputFile, "bool %s;\n", $1);
}
;

declareassign: VAR COLON INT ASSIGN INT_NUMBER{
    fprintf(outputFile, "int %s = %s ;\n", $1, $5);
}
| VAR COLON REAL ASSIGN REAL_NUMBER{
    fprintf(outputFile, "float %s = %s;\n", $1, $5 );
}
| VAR COLON STRING ASSIGN STR{
    fprintf(outputFile, "string %s = %s;\n", $1, $5 );
}
| VAR COLON CHAR ASSIGN CHARACTER{
    fprintf(outputFile, "char %s = %s;\n", $1, $5 );
}
| VAR COLON BOOLEAN ASSIGN TRUE{
    fprintf(outputFile, "bool %s = %s;\n", $1, $5 );
}
| VAR COLON BOOLEAN ASSIGN FALSE{
    fprintf(outputFile, "bool %s = %s;\n", $1, $5 );
}
|VAR COLON datatype ASSIGN VAR{
    fprintf(outputFile, "int %s = %s ;\n", $1, $5);
}
VAR COLON datatype ASSIGN value{
    fprintf(outputFile, "int %s = %s ;\n", $1, $5);
}

;

datatype: STRING
    {$$ = $1;}
| BOOLEAN
    {$$ = $1;}
| INT
    {$$ = $1;}
| REAL
    {$$ = $1;}
| CHAR
    {$$ = $1;}
;

value:literal
{fprintf(outputFile, "%s", $1);}
| exp
{$$ = $1;}
| read
{$$ = $1;}
;

literal: num
| STR
{$$ = $1;}
| CHARACTER
{$$ = $1;}
| bool
;

num: REAL_NUMBER
{$$ = $1;}
| INT_NUMBER
{$$ = $1;}
;

bool: TRUE {fprintf(outputFile, "true");}
| FALSE {fprintf(outputFile, "false");}
;

exp: VAR {fprintf(outputFile, "%s", $1);}
| arithmetic
| logic
| relation
;

arithmetic: arithmetic operation arithmetic
| num {fprintf(outputFile, "%s", $1);}
| VAR {fprintf(outputFile, "%s", $1);}
| par arithmetic par
;

par: OPENPAR {fprintf(outputFile, "(");}
| CLOSEPAR {fprintf(outputFile, ")");}
;

operation: SUM {fprintf(outputFile, "+");}
| SUBTRACTION {fprintf(outputFile, "-");}
| MULTIPLICATION {fprintf(outputFile, "*");}
| DIVISION {fprintf(outputFile, "/");}
| EXPONENTIATION {fprintf(outputFile, "^");}
| RESTDIV {fprintf(outputFile, "%");}
;

logic: par exp par
| negs VAR {fprintf(outputFile, "%s", $2);}
| exp logical exp
;

negs: negs negs
| NEG {fprintf(outputFile, "!");}
;  

logical: AND
    {fprintf(outputFile, "&&");}
| OR
    {fprintf(outputFile, "||");}
;

relation: relationterm relational relationterm
;

relationterm: bool
	| exp
;

relational: GT {fprintf(outputFile, ">");}
| LT {fprintf(outputFile, "<");}
| LE {fprintf(outputFile, "<=");}
| GE {fprintf(outputFile, ">=");}
| NE {fprintf(outputFile, "!=");}
| EQ {fprintf(outputFile, "==");}
;

read: VAR ASSIGN SCAN {
    fprintf(outputFile, "cin >> %s;\n", $1);
}
    | VAR COLON STRING ASSIGN SCAN {
        fprintf(outputFile, "string %s;\ncin >> %s;\n", $1, $1);
    }
    | VAR COLON INT ASSIGN SCAN {
        fprintf(outputFile, "int %s;\ncin >> %s;\n", $1, $1);
    }
    | VAR COLON REAL ASSIGN SCAN {
        fprintf(outputFile, "float %s;\ncin >> %s;\n", $1, $1);
    }
    | VAR COLON CHAR ASSIGN SCAN {
        fprintf(outputFile, "char %s;\ncin >> %s;\n", $1, $1);
    }
;

assignment: VAR ASSIGN {fprintf(outputFile, "%s = ", $1);} value {fprintf(outputFile, ";\n");}
    
;

loop: WHILE {fprintf(outputFile, "while (");} logic REPEAT COLON {fprintf(outputFile, "){\n");} body {fprintf(outputFile, "}\n");}
;

conditional: IF {fprintf(outputFile, "if (");} logic QUESTION {fprintf(outputFile, "){\n");} body {fprintf(outputFile, "}\n");}
;

else: ELSE {fprintf(outputFile, "else ");} COLON {fprintf(outputFile, "{\n");} body {fprintf(outputFile, "}\n");}
| ELSE {fprintf(outputFile, "else ");} conditional
;

write: PRINT {fprintf(outputFile, "cout << ");} content {fprintf(outputFile, "endl;\n");}
;

content: content content
| exp {fprintf(outputFile, " << ");}
| STR {fprintf(outputFile, "%s", $1); fprintf(outputFile, " << ");} 
;

%%

int main(int argc, char *argv[]) {
    // Check if the correct number of command-line arguments is provided
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    // Check if the input file has the correct extension
    char *fileExtension = strrchr(argv[1], '.');
    if (fileExtension == NULL || strcmp(fileExtension, ".gr") != 0) {
        fprintf(stderr, "Error: Input file must have a .gr extension\n");
        return 1;
    }

    // Open the input file
    FILE *inputFile = fopen(argv[1], "r");
    if (!inputFile) {
        fprintf(stderr, "Error opening input file\n");
        return 1;
    }

    // Open the output file for writing
    outputFile = fopen("output_file.cpp", "w");
    if (!outputFile) {
        fprintf(stderr, "Error opening output file\n");
        fclose(inputFile);
        return 1;
    }

    fprintf(outputFile, "#include <iostream>\nusing namespace std;\n");

    // Set yyin to read from the input file
    yyin = inputFile;

    // Call yyparse to parse the yacc code
    if (yyparse() == 0) {
        printf("Grace program parsed successfully\n");
    } else {
        printf("Parsing error.\n");
    }

    // Write the ending of the C++ code
    fprintf(outputFile, "    return 0;\n");
    fprintf(outputFile, "}\n");

    // Close the input and output files
    fclose(inputFile);
    fclose(outputFile);

    return 0;
}

void yyerror(const char* msg) {
    fprintf(stderr, "Error at line %d: %s\n", yylineno, msg);
}
