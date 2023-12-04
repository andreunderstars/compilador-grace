# Linguagem Grace - Compilador

Desenvolvimento de um analisador léxico e sintático da linguagem Grace, como requisito para a segunda nota da matéria de Compiladores (ECOM06A) do curso de Engenharia de Computação da UNIFEI.

Desenvolvido por: 

André Luiz Melo dos Santos Franco

Mateus Alexandre Martins de Souza

Patricia Brenny Ribeiro

## Conteúdo

O analisador é composto pelos arquivos **lexer.l**, com as definições de símbolos e palavras reservadas da linguagem, e **parser.y**, com a definição das regras das sentenças da linguagem.

## Utilização

Para utilização, é necessária a ferramenta flex.

O código deverá ser escrito em um arquivo com extensão **.gr**.

Para compilação do arquivo no Windows, será necessário utilizar os comandos:

```
yacc -v -d parser.y

flex lexer.l

g++ parser.tab.c

a grace.gr
```

Com isso, será criado um arquivo **.cpp** que possui o código convertido da linguagem Grace para C++. A partir disso, o arquivo C++ poderá ser compilado mostrando os outputs esperados no código.
