:- dynamic(n/1).

%nos
n(0).
addNo(N) :- retract(n(X)), M is N+X, asserta(n(M)).

g:- estado_inicial(Ei), minmax_decidir(Ei,Op),
    write(Op), nl.

% decide qual é a melhor jogada num estado do jogo
% minmax_decidir(Estado, MelhorJogada)

% se é estado terminal  não há jogada          
minmax_decidir(Ei,terminou):- terminal(Ei).

%Para cada estado sucessor de Ei calcula o valor minmax do estado
%Opf é o operador (jogada) que tem maior valor

minmax_decidir(Ei,Opf):- 
          findall(Es-Op, op1(Ei,Op,Es),L),
          findall(Vc-Op,(member(E-Op,L), minmax_valor(E,Vc,1)),L1),
          escolhe_max(L1,Opf).

% se um estado é terminal o valor é dado pela função de utilidade
minmax_valor(Ei,Val,P):- terminal(Ei), valor(Ei,Val,P), addNo(1).

%Se o estado não é terminal o valor é:
%    -se a profundidade é par, o maior valor dos sucessores de Ei
%    -se aprofundidade é impar o menor valor dos sucessores de Ei
minmax_valor(Ei,Val,P):- findall(Es,op1(Ei,_,Es),L),
                          P1 is P+1,
                          findall(Val1,(member(E,L),minmax_valor(E,Val1,P1)),V),
                          seleciona_valor(V,P,Val).


% Se a profundidade (P) é par, retorna em Val o maximo de V
seleciona_valor(V,P,Val):- X is P mod 2, X=0,!, maximo(V,Val).

% Senão retorna em Val o minimo de V
seleciona_valor(V,_,Val):- minimo(V,Val).


maximo([A|R],Val):- maximo(R,A,Val).

maximo([],A,A).
maximo([A|R],X,Val):- A < X,!, maximo(R,X,Val).
maximo([A|R],_,Val):-  maximo(R,A,Val).


escolhe_max([A|R],Val):- escolhe_max(R,A,Val).

escolhe_max([],_-Op,Op).
escolhe_max([A-_|R],X-Op,Val):- A < X,!, escolhe_max(R,X-Op,Val).
escolhe_max([A|R],_,Val):-  escolhe_max(R,A,Val).


minimo([A|R],Val):- minimo(R,A,Val).

minimo([],A,A).
minimo([A|R],X,Val):- A > X,!, minimo(R,X,Val).
minimo([A|R],_,Val):-  minimo(R,A,Val).
