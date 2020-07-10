/*
    Descrição formal de um problema:

    estado_inicial( ... ).
    estado_final( ... ).
    tr(E0, accao, E1, custo).

    Descricao de um nó de pesquisa:

    no(Estado, Pai, Operacao, Custo, Profundidade) SSE

        Obtém-se o estado "Estado",
        com custo "Custo" a profundidade "Profundidade",
        a partir do estado "Pai" fazendo "Operação". 
  
*/
pesquisa(Problema, Algoritmo, Solucao, Stat) :-
    consult(Problema),
    estado_inicial(E0),
    pesquisa_alg(
        Algoritmo,
        [no(E0, nenhum, nenhuma, 0, 0)],
        Solucao,
        Stat).

pesquisa_alg(iterativa, Lista, Solucao, Stat) :-
    pesquisa_iterativa(Lista, Solucao, 1, Stat).
pesquisa_alg(limitada(N), Lista, Solucao, Stat) :-
    pesquisa_plim(Lista, Solucao, N, [], Stat).
pesquisa_alg(largura, Lista, Solucao, Stat) :-
    pesquisa_largura(Lista, [], Solucao, Stat).
/*
    Pesquisa LARGURA
*/
%
%   Verificar se o topo da lista é um estado final.
%
pesquisa_largura(
    [ no(Ef, Pai, Op, C, P) | R],
    _,
    no(Ef, Pai, Op, C, P),
    stat(1, LL))
:-
    estado_final(Ef),
    length(R, L1),
    LL is L1 + 1.
%
%   Caso contrário, espandir em largura
%
pesquisa_largura( [N | R], V, S, Stats) :-
    N = no(E, _, _, _, _),
    member(E, V), !, % Não expandir estados visitados.
    pesquisa_largura(R, V, S, Stats).
pesquisa_largura([N | Resto], V, Solucao, stat(NN1, LL1)) :-
    N = no(E, _, _, _, _),
    expande_largura(N, Filhos),
    append(Resto, Filhos, Seguintes),
    pesquisa_largura(Seguintes, [E | V], Solucao, stat(NN, LL)),
    NN1 is NN + 1,
    length(Seguintes, LenSeguintes),
    max(LenSeguintes, LL, LL1).

expande_largura(no(E, A, O, C, P), Filhos) :-
    findall(
        no(Enovo, no(E, A, O, C, P), Onovo, Cnovo, Pnovo),
        (   tr(E, Onovo, Enovo, Cop),
            Pnovo is P + 1,
            Cnovo is C + Cop ),
        Filhos).
/*
    Pesquisa ITERATIVA e PROFUNDIDADE LIMITADA
*/
pesquisa_iterativa(Lista, Solucao, Profundidade, Stats) :-
    pesquisa_plim(Lista, Solucao, Profundidade, [], Stats).
pesquisa_iterativa(Lista, Solucao, Profundidade, Stats) :-
    P1 is Profundidade + 1,
    pesquisa_iterativa(Lista, Solucao, P1, Stats).
/*
    Pesquisa profundidade limitada
    pesquisa_plim(Abertos, Solucao, EstadoFinal, Profundidade, Fechados, Stats)
*/
%
% O topo dos candidatos é um estado final?
%
pesquisa_plim(
    [no(Ef, A, O, C, P) | R], no(Ef, A, O, C, P), _, _, stat(0, LL)) :-
    estado_final(Ef),!,
    length(R, LR),
    LL is LR + 1.
%
% Espandir topo dos candidatos...
%
pesquisa_plim([No | Resto], S, P, V, Stats) :-
    No = no(E, _, _, _, _),
    member(E, V), !, % Não expandir em estados visitados
    pesquisa_plim(Resto, S, P, V, Stats).
pesquisa_plim([No | R], S, P, V, stat(NN1, LL1)) :-
    No = no(E, _, _, _, _),
    expande_plim(No, Filhos, P),
    append(Filhos, R, Seguintes),
    pesquisa_plim(Seguintes, S, P, [E | V], stat(NN, LL)),
    NN1 is NN + 1,
    length(Seguintes, LS),
    max(LL, LS, LL1).
%
% Cortar a espansão de nós demasiado profundos.
%
expande_plim(no(_, _, _, _, P), [], Plim) :- 
    Plim =< P, !.
%
% Desenvolver os filhos de um nó.
%
expande_plim(no(E, A, O, C, P), Filhos, _) :-
    findall(
        no(Enovo, no(E, A, O, C, P), Onovo, Cnovo, Pnovo),
        (   tr(E, Onovo, Enovo, Cop),
            Pnovo is P + 1,
            Cnovo is C + Cop ),
        Filhos).
/*
Escrita de accoes, etc
*/

max(A, B, A) :- A > B, !.
max(_, B, B).

min(A, B, A) :- A < B, !.
min(_, B, B).