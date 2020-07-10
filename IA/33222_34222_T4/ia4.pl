local(esq).
local(dir).

possiveis(0).
possiveis(1).
possiveis(2).
possiveis(3).

levar(2,0).
levar(1,0).
levar(1,1).
levar(0,1).
levar(0,2).

levar2(0,0).
levar2(2,0).
levar2(1,0).
levar2(1,1).
levar2(0,1).
levar2(0,2).

inicio([estado(3,3,esq),barco(0,0,esq),estado(0,0,dir)]).

objetivo([estado(3,3,dir)]).

acao(ir(A,B),
	[barco(M1,C1,A)],
	[barco(M1,C1,B)],
	[barco(M1,C1,A)]):- local(A),local(B), levar(M1,C1),A\=B.


acao(embarcarMissionario,
	[estado(M1,C,A),barco(M2,C1,A)],
	[estado(M3,C,A),barco(M4,C1,A)],
	[estado(M1,C,A),barco(M2,C1,A)]):-
	local(A),
	levar2(M2,C1),
	levar2(M4,C1),
	possiveis(M3),
	possiveis(M1),
	possiveis(C),
	M4 is M2+1,
	M3 is M1-1,
	M3 =< C.

acao(embarcarCanibal,
	[estado(M,C1,A),barco(M1,C2,A)],
	[estado(M,C3,A),barco(M1,C4,A)],
	[estado(M,C1,A),barco(M1,C2,A)]):-
	local(A),
	levar2(M1,C4),
	levar2(M1,C2),
	possiveis(M),
	possiveis(C1),
	possiveis(C3),
	C4 is C2+1,
	C3 is C1-1,
	M >= C3.

acao(desembarcarMissionario,
	[estado(M1,C,A),barco(M2,C1,A)],
	[estado(M3,C,A),barco(M4,C1,A)],
	[estado(M1,C,A),barco(M2,C1,A)]):-
	local(A),
	levar2(M4,C1),
	levar2(M2,C1),
	possiveis(M3),
	possiveis(M1),
	possiveis(C),
	M4 is M2-1,
	M3 is M1+1,
	M3 >= C.


acao(desembarcarCanibal,
	[estado(M,C1,A),barco(M1,C2,A)],
	[estado(M,C3,A),barco(M1,C4,A)],
	[estado(M,C1,A),barco(M1,C2,A)]):-
	local(A),
	levar2(M1,C4),
	levar2(M1,C2),
	possiveis(M),
	possiveis(M1),
	possiveis(C1),
	C3 is C1+1,
	C4 is C2-1,
	M >= C3.

%%perguntar se pode ser assim 