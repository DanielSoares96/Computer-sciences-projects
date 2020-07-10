p:- consult(sudoku),
	estado_inicial(E0),
	forward(E2,A),
	print(9,A).

forward(e([],A),A).
forward(E,Sol):-
		sucessor(E,E1),
	      restricoes(E1),
	      forwardC(E1,E2).
         


 

forwardC(e(NAfect,[n(N,D,V)|Afect]),e(NAfectS,[n(N,D,V)|Afect])):-
	    actualizaDom(V, NAfect, NAfectS).

actualizaDom(_,[],[]).
actualizaDom(V,[v(N,D,_)|NAfect],[v(N,DS,_)|NAfectS]):-
	delete(D,V,DS),
	actualizaDom(V, NAfect, NAfectS).

sucessor(e([v(N,D,V)|Afect],E),e(Afect,[v(N,D,V)|E])):- member(V,D).