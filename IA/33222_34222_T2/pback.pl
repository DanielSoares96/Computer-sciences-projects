p:- consult(sudoku),
	estado_inicial(E0),
	back(E0,A),
	print(9,A).

back(e([],A),A).
back(E,Sol):-
		sucessor(E,E1),
	      restricoes(E1),

              back(E1,Sol).

sucessor(e([v(N,D,V)|Afect],E),e(Afect,[v(N,D,V)|E])):- member(V,D).






