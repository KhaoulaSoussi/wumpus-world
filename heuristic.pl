:- dynamic([
  stench/1,
  breeze/1,
  glitter/1,
  scream/0
]).

% A room X,Y definitely has a pit, if there is a breeze in room A,B adjacent to X,Y, and none of the adjacent rooms to A,B have a pit
has_pit(room(X,Y), yes) :- room(A,B), breeze(room(A,B)), adjacent(room(X,Y), room(A, B)), no_surrounding_pit(room(A,B)).

no_surrounding_pit(room(A,B)) :- room(X,Y), adjacent(room(X,Y), room(A, B)), not(has_pit(room(X,Y), no)) , !, fail.

% A room X,Y definitely has a wumpus, if there is a stench in room A,B adjacent to X,Y, and none of the adjacent rooms to A,B have a wumpus
has_wumpus(room(X,Y), yes) :- room(A,B), stench(room(A,B)), adjacent(room(X,Y), room(A, B)), no_surrounding_wumpus(room(A,B)).

no_surrounding_wumpus(room(A,B)) :- room(X,Y), adjacent(room(X,Y), room(A, B)), not(has_wumpus(room(X,Y), no)) , !, fail.

% A room X,Y definitely has no pit, if none of its adjacent rooms have a breeze, or if it has a wumpus
has_pit(room(X,Y), no) :- (position(room(A, B), _), adjacent(room(X,Y), room(A, B)), not(breeze(room(A,B))));
                          has_wumpus(room(X,Y), yes).

% A room X,Y definitely has no wumpus, if none of its adjacent rooms have a stench, or if it has a pit
has_wumpus(room(X,Y), no) :- (position(room(A, B), _), adjacent(room(X,Y), room(A, B)), not(stench(room(A,B)))).
                             has_pit(room(X,Y), yes).

has_pit(room(X,Y), maybe) :- not(has_pit(room(X, Y), yes)), not(has_pit(room(X, Y), no)), not(has_wumpus(room(X,Y), yes)),
                             adjacent(room(X,Y), room(A, B)) , breeze(room(A,B)), !.

has_wumpus(room(X,Y), maybe) :- not(has_wumpus(room(X, Y), yes)), not(has_wumpus(room(X, Y), no)), not(has_pit(room(X,Y), yes)),
                                adjacent(room(X,Y), room(A, B)) , stench(room(A,B)), !.

tell_kb(breeze) :- assertz(breeze(room(X,Y))).
tell_kb(stench) :- assertz(stench(room(X,Y))).
tell_kb(glitter) :- assertz(glitter(room(X,Y))).
tell_kb(scream) :- assertz(scream()).

% HEURISTICS

% think about the second argument of heuristic and how it is used
% think about how heuristic itself is used

% Shoot the wumpus when you are sure it is in room(A,B)
heuristic(perceptions([yes, _, _, _]), shoot) :- position(room(X, Y), T), adjacent(room(X, Y), room(A, B)),
                                          has_wumpus(room(A,B), yes), shoot(room(A, B), T), !.

% If not sure where the wumpus is, move to an adjacent room that may be safe
% Why not move to safest room then, using the score?
heuristic(perceptions([yes, _, _, _]), move) :- position(room(X, Y), T), adjacent(room(X, Y), room(A, B)),
                                          not(has_wumpus(room(A,B), yes)), not(has_wumpus(room(A,B), maybe)),
                                          not(has_pit(room(A,B), yes)), not(has_pit(room(A,B), maybe)),
                                          move(room(X, Y), room(A, B), T).

% If not sure where the wumpus is, and no adjacent room is maybe safe, shoot any random adjacent room where there may be the wumpus
heuristic(perceptions([yes, _, _, _]), shoot) :- position(room(X, Y), T), adjacent(room(X, Y), room(A, B)),
                                                 has_wumpus(room(A,B), maybe), shoot(room(A, B), T).

% Question: if we do not know where the wumpus is, but all the neighboring rooms have been visited except one, we can just shoot that one, right?
% Yup. Sounds oddly specific hahah but it might be useful.
% Question: if we do not know where the wumpus is, should we move to a neighboring room that has not been visited yet?
% We could. I think we should leave the decision to move to the safety score
% or maybe to be safer we can visit one that has already been visited and continue from there to other rooms unless we fall in a cycle
% yeah, we need to make sure we make meaningful moves: don't keep moving to visited places and make sure your destination is different from your start point

heuristic(perceptions([_, _, _, yes]), quit) :- write('Game over... You won!'), halt().

% does this handle rooms that are adjacent to visited?
explorableRooms(L) :- position(room(X,Y), _),
                      findall(room(A,B), adjacent(room(X, Y), room(A, B)), L1),
                      findall(room(C,D), visited(room(C,D),_), L2),
                      append(L1, L2, R),
                      remove_duplicates(R, L).

% Tried to append without duplicates but didnt work
% it's alright
append_no_dupl(_, [], _).
append_no_dupl(L, [H|T], R) :- member(H, L), append_no_dupl(L, T, R).
append_no_dupl(L, [H|T], R) :- not(member(H, L)), append(L, [H], R), append_no_dupl(R, T, X).

remove_duplicates([], []).
remove_duplicates([Head | Tail], Result) :-
    member(Head, Tail), !,
    remove_duplicates(Tail, Result).
remove_duplicates([Head | Tail], [Head | Result]) :-
    remove_duplicates(Tail, Result).

heuristic([_, yes, _, _], move(room(X, Y), room(A, B), T)) :- tell_kb(breeze), current_safest_cell(room(A, B)).

heuristic([_, _, yes, _], grab_gold) :- tell_kb(glitter), !.

current_safest_cell(room(X, Y)) :- findall(S, total_current_score(room(A, B), S), L), % has to be explorable
            % will probably have to get explorable list and append it to this L (it's okay if there are duplicates, i think)
                                  min_list(L, MinScore),
                                  index_of(MinScore, L, Idx),
                                  nth0(Idx, L, room(X, Y)).

% util to get index of element
% From reference:
% index_of([H|_], H, 0):- !.
% index_of([_|T], H, Index):- index_of(T, H, OldIndex), !, Index is OldIndex + 1.
% I hope the following works:
index_of(Elt, Lst, Idx) :- nth0(Idx, Lst, Elt).

total_current_score(room(X, Y), T) :- findall(P, partial_score(room(X, Y), P), L), sum_list(L, T).

% The lower the score, the safer the room
partial_score(room(X, Y), S) :- has_pit(room(X, Y), yes), S is 1000.
partial_score(room(X, Y), S) :- has_wumpus(room(X, Y), yes), S is 2000.
partial_score(room(X, Y), S) :- has_pit(room(X, Y), maybe), S is 400.
partial_score(room(X, Y), S) :- has_wumpus(room(X, Y), maybe), S is 800.

% A bunch of atomic moves from X, Y to A, B
% traveling from xy to ab through zw is equivalent to moving from xy to zw atomically then traveling from zw to ab
% base case: same room
% zw is xy's parent
travel(room(X, Y), room(A, B), T) :- room(Z, W), parent(room(Z, W), room(X, Y)), 
                    move(room(X, Y), room(Z, W), T), U is T+1, travel(room(Z, W), room(A, B), U), !.
