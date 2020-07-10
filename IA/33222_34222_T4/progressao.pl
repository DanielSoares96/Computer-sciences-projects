:- consult(pesquisa).

estado_inicial(E) :-
	inicio(E).

estado_final(E) :-
	objetivo(F),
	satisfaz(E, F).	

tr(E, X, F, C) :-
	acao(X, P, A, R),
	satisfaz(E, P),
	sucessor(E, A, R, F),
	length(F, C).


satisfaz(_, []).

satisfaz(E, [X | R]) :-
	member(X, E),
	satisfaz(E, R).

sucessor(E, A, R, F) :-
	subtract(E, R, E1),
	append(E1, A, F1),
	list_to_set(F1, F).

planear(Problema, Algoritmo, Solucao, Stat) :-
	pesquisa(Problema, Algoritmo, Solucao, Stat).

teste(Problema, Algoritmo) :-
	time(planear(Problema, Algoritmo, Solucao, _)),
	write('Por PROGRESSÃO'), nl,
	escreve(Solucao).

teste(Problema) :-
	teste(Problema, iterativa).

escreve(nenhum).
escreve(no(E, P, O, _, _)) :-
	escreve(P),
	write(O), nl,
	write(' '),  write(E), nl.