% estado inicial
estado_inicial( e([0,0,0, 0,0,0, 0,0,0],o) ).

%terminais
terminal(A):-estado_terminal(A),!.
terminal(A):-estado_empatado(A),!.

%linhas
estado_terminal( e([Op,Op,Op, _,_,_, _,_,_],Op) ).
estado_terminal( e([_,_,_, Op,Op,Op, _,_,_],Op) ).
estado_terminal( e([_,_,_, _,_,_, Op,Op,Op],Op) ).

%colunas
estado_terminal( e([Op,_,_, Op,_,_, Op,_,_],Op) ).
estado_terminal( e([_,Op,_, _,Op,_, _,Op,_],Op) ).
estado_terminal( e([_,_,Op, _,_,Op, _,_,Op],Op) ).

%diagonal
estado_terminal( e([Op,_,_, _,Op,_, _,_,Op],Op) ).
estado_terminal( e([_,_,Op, _,Op,_, Op,_,_],Op) ).

estado_empatado( e([A,B,C, D,E,F, G,H,I],_) ):-
	member(A,[x,o]),
	member(B,[x,o]),
	member(C,[x,o]),
	member(D,[x,o]),
	member(E,[x,o]),
	member(F,[x,o]),
	member(G,[x,o]),
	member(H,[x,o]),
	member(I,[x,o]).

%operadores
%op1(Estado,(Simbolo,Posicao),Estado Seguinte)
op1(e(Ei,o),(x,P),e(Ef,x)):-
	member(P,[1,2,3,4,5,6,7,8,9]),
	substituir1(Ei,(x,P),Ef).

op1(e(Ei,x),(o,P),e(Ef,o)):-
	member(P,[1,2,3,4,5,6,7,8,9]),
	substituir1(Ei,(o,P),Ef).


%substitui Op na posicao P 
substituir1([0|R],(Op,1),[Op|R]):-!.
substituir1([X|R],(Op,P),R1):-
	P>1,
	P1 is P-1,
	substituir1(R,(Op,P1),R2),
	append([X],R2,R1).


% função de utilidade, retorna o valor dos estados terminais, 1 ganha , 0 empata, -1 perde
valor(e(E,Op),1,_):- estado_terminal(e(E,Op1)), Op1=o,!.
valor(E,0,_):- estado_empatado(E),!.
valor(e(E,Op),-1,_):- estado_terminal(e(E,Op1)).



% função de avaliacao
% avalia(Estado, Tipo_peca, Avaliacao)
avalia(E,Op,3):-
	terminal(E).

avalia(e(E,Op),Op,2):-
	E = [Op,Op,X, _,_,_, _,_,_],
	X \= Op.

avalia(e(E,Op),Op,2):-
	E = [ _,_,_, Op,Op,X,_,_,_],
	X \= Op.

avalia(e(E,Op),Op,2):-
	E = [_,_,_, _,_,_, Op,Op,X],
	X \= Op.

avalia(e(E,Op),Op,2):-
	E = [X,Op,Op, _,_,_, _,_,_],
	X \= Op.

avalia(e(E,Op),Op,2):-
	E = [ _,_,_, X,Op,Op,_,_,_],
	X \= Op.

avalia(e(E,Op),Op,2):-
	E = [_,_,_, _,_,_, X,Op,Op],
	X \= Op.

avalia(e(E,Op),Op,2):-
	E = [Op,_,_, Op,_,_, X,_,_],
	X \= Op.

avalia(e(E,Op),Op,2):-
	E = [_,Op,_, _,Op,_, _,X,_],
	X \= Op.

avalia(e(E,Op),Op,2):-
	E = [_,_,Op, _,_,Op, _,_,X],
	X \= Op.

avalia(e(E,Op),Op,2):-
	E = [X,_,_, Op,_,_, Op,_,_],
	X \= Op.

avalia(e(E,Op),Op,2):-
	E = [_,X,_, _,Op,_, _,Op,_],
	X \= Op.

avalia(e(E,Op),Op,2):-
	E = [_,_,X, _,_,Op, _,_,Op],
	X \= Op.

avalia(e(E,Op),Op,2):-
	E = [Op,_,_, _,Op,_, _,_,X],
	X \= Op.

avalia(e(E,Op),Op,2):-
	E = [_,_,X, _,Op,_, Op,_,_],
	X \= Op.

avalia(e(E,Op),Op,1).


inverte_peca('x','o').
inverte_peca('o','x').

%desenhar tabuleiro
desenhar_tab(e(L,_)):-
	write('***Tabuleiro Actualizado***'),
	nl,nl,
	desenhar_val(L).

desenhar_val([A,B,C,D,E,F,G,H,I]):-
	write(A),write('|'), write(B),write('|'), write(C),nl,
	write('--'),write('--'),write('--'),nl,
	write(D),write('|'), write(E),write('|'), write(F),nl,
	write('--'),write('--'),write('--'),nl,
    write(G),write('|'), write(H),write('|'), write(I),nl.


%agente inteligente
inverter('p','j').
inverter('j','p').

agente_inteligente(j,e(L,O)):- estado_terminal(e(L,O)), desenhar_tab(e(L,O)),write('Vencedor: '),write(O),nl,nl.
agente_inteligente(j,e(L,O)):- estado_empatado(e(L,O)), desenhar_tab(e(L,O)),write('Empate!!'),nl,nl.

agente_inteligente(p,e(L,O)):- estado_terminal(e(L,O)), desenhar_tab(e(L,O)),write('Vencedor: '),write(O),nl,nl.
agente_inteligente(p,e(L,O)):- estado_empatado(e(L,O)), desenhar_tab(e(L,O)),write('Empate!!'),nl,nl.

agente_inteligente(p,e(L,O)):-
	desenhar_tab(e(L,O)),
	nl,nl,
	minmax_decidir(e(L,O),Op),
	escreveOp(Op),
	nl,
	nl,
	op1(e(L,O),Op,Es),
	inverter(p,Jogador1),
	agente_inteligente(Jogador1,Es).


agente_inteligente(j,e(L,O)):-
	desenhar_tab(e(L,O)),
	nl,
	nl,
	write('Escreva a posição onde deseja jogar (1,...,9): '),
	read(Pos),
	op1(e(L,O),(_,Pos),Es),
	inverter(j,Jogador1),
	agente_inteligente(Jogador1,Es).


%escrever operador
escreveOp(terminou):-!.
escreveOp((P,Op)):-nl,
	write('O computador jogou na posição:'),write(Op),nl.

galo:-
	[minmax],
	criar_estado_inicial(Jogador,x,Estado),
	write('Vamos começar!'),nl,
	agente_inteligente(Jogador,Estado),
	nl,
	n(X), write('Nós visitados: '), write(X), nl,
	nl,
	read(X).

%criar estado inicial
criar_estado_inicial(j,x,e([0,0,0, 0,0,0, 0,0,0],o)).
criar_estado_inicial(j,o,e([0,0,0, 0,0,0, 0,0,0],x)).







