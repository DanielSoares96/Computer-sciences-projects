objetivo([0,0,0,0]).

op_menos(1).
op_menos(2).
op_menos(3).
op_menos(4).

estado_inicial(e(a,[1,2,3,4])).

estado_terminal(e(_, N)) :- objetivo(N).

valor(e(b, N), +1) :- objetivo(N).
valor(e(a, N), -1) :- objetivo(N).

sucessor(e(J, Ei),(X,Y), e(K,Ef)) :-
	member(X,[1,2,3,4]),
	retirar(Ei,(X,Y), Ef).

retirar([H|T],(X,1),[X|T]):- !.
retirar([H|T],(X,Y),T1):-
	Y>1,
	Y1 is Y-1,
	retirar(T,(X,Y1),T1),


