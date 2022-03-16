% TODO: Clean some rules from unnecessary checks (e.g., no_surrounding_pit() checks if there is room(X,Y) which adjacent() also does that)

:- abolish(stench/1).
:- abolish(breeze/1).
:- abolish(glitter/1).
:- abolish(scream/1).
:- abolish(safe/1).

:- dynamic([
  stench/1,
  breeze/1,
  glitter/1,
  scream/1,
  safe/1
]).

% A room X,Y definitely has a pit if there is a breeze in room A,B adjacent to X,Y, and none of the adjacent rooms to A,B have a pit
has_pit(room(X,Y), yes) :- room(A,B), breeze(room(A,B)), adjacent(room(X,Y), room(A, B)), no_surrounding_pit(room(A,B)).
% A room X,Y definitely has a pit if there is a breeze in room A,B adjacent to X,Y, and all the adjacent rooms to A,B were visited
has_pit(room(X,Y), yes) :- room(A,B), breeze(room(A,B)), adjacent(room(X,Y), room(A, B)), all_adjacent_visited(room(A,B)).

% A room X,Y definitely has no pit, if at least one of its adjacents doesn't have a breeze, or if it has a wumpus
has_pit(room(X,Y), no) :- position(room(A, B), _), adjacent(room(X,Y), room(A, B)), not(breeze(room(A,B))), !.
has_pit(room(X,Y), no) :- has_wumpus(room(X,Y), yes).

has_pit(room(X,Y), maybe) :- not(has_pit(room(X, Y), yes)), not(has_pit(room(X, Y), no)), not(has_wumpus(room(X,Y), yes)),
                             adjacent(room(X,Y), room(A, B)) , breeze(room(A,B)), !.

no_surrounding_pit(room(A,B)) :- room(X,Y), adjacent(room(X,Y), room(A, B)), not(has_pit(room(X,Y), no)) , !, fail.

no_surrounding_wumpus(room(A,B)) :- room(X,Y), adjacent(room(X,Y), room(A, B)), not(has_wumpus(room(X,Y), no)) , !, fail.

all_adjacent_visited(room(A,B)) :- room(X,Y), adjacent(room(X,Y), room(A, B)), not(visited(room(X,Y)),_) , !, fail.

% A room X,Y definitely has a wumpus, if there is a stench in room A,B adjacent to X,Y, and none of the adjacent rooms to A,B have a wumpus
has_wumpus(room(X,Y), yes) :- room(A,B), stench(room(A,B)), adjacent(room(X,Y), room(A, B)), no_surrounding_wumpus(room(A,B)).
% A room X,Y definitely has a wumpus if there is a stench in room A,B adjacent to X,Y, and all the adjacent rooms to A,B were visited
has_wumpus(room(X,Y), yes) :- room(A,B), stench(room(A,B)), adjacent(room(X,Y), room(A, B)), all_adjacent_visited(room(A,B)).

% A room X,Y definitely has no wumpus, if at least one of its adjacents doesn't have a stench, or if it has a pit
has_wumpus(room(X,Y), no) :- position(room(A, B), _), adjacent(room(X,Y), room(A, B)), not(stench(room(A,B))), !.

has_wumpus(room(X,Y), no) :- has_pit(room(X,Y), yes).

has_wumpus(room(X,Y), maybe) :- not(has_wumpus(room(X, Y), yes)), not(has_wumpus(room(X, Y), no)), not(has_pit(room(X,Y), yes)),
                                adjacent(room(X,Y), room(A, B)) , stench(room(A,B)), !.

tell_kb(breeze, room(X, Y)) :- assertz(breeze(room(X,Y))).
tell_kb(stench, room(X, Y)) :- assertz(stench(room(X,Y))).
tell_kb(glitter, room(X, Y)) :- assertz(glitter(room(X,Y))).
tell_kb(scream) :- assertz(scream()).

% HEURISTICS

% Shoot the wumpus when you are sure it is in room(A,B)
heuristic([yes, _, _, _]) :-  position(room(X, Y), T), tell_kb(stench, room(X, Y)),adjacent(room(X, Y), room(A, B)),
                                          has_wumpus(room(A,B), yes), shoot(room(A, B), T), !.

% If not sure where the wumpus is, move to the safest explorable room
heuristic([yes, _, _, _]) :- position(room(X, Y), T), tell_kb(stench, room(X, Y)), current_safest_cell(room(A, B)),
                                          move(room(X, Y), room(A, B), T).

% If not sure where the wumpus is, and no adjacent room is maybe safe, shoot any random adjacent room where there may be the wumpus
heuristic([yes, _, _, _]) :- position(room(X, Y), T), tell_kb(stench, room(X, Y)), adjacent(room(X, Y), room(A, B)),
                                                 has_wumpus(room(A,B), maybe), shoot(room(A, B), T).

heuristic([no, no, _, _]) :- position(room(X, Y), T), adjacent(room(X, Y), room(A, B)), asserta(safe(room(A, B))),
                                          move(room(X, Y), room(A, B), T).

heuristic([_, _, _, yes]) :- write('Game over... You won!'), halt().

heuristic([_, yes, _, _]) :- position(room(X, Y), T), tell_kb(breeze, room(X, Y)), current_safest_cell(room(A, B)), move(room(X, Y), room(A, B), T).

heuristic([_, _, yes, _]) :- position(room(X, Y), _), tell_kb(glitter, room(X, Y)), grab_gold(), !.

explorableRooms(L) :- position(room(X,Y), _),
                      findall(room(A,B), adjacent(room(X, Y), room(A, B)), L1),
                      findall(room(C,D), visited(room(C,D),_), L2),
                      findall(L3, adjacent_to_visited(L3) ,L4),
                      flatten(L4, L5),
                      append([L1, L2, L5], R),
                      remove_duplicates(R, L).

adjacent_to_visited(L) :- visited(room(X,Y), _), findall(room(A,B), adjacent(room(X, Y), room(A, B)), L).

remove_duplicates([], []).
remove_duplicates([Head | Tail], Result) :-
    member(Head, Tail), !,
    remove_duplicates(Tail, Result).
remove_duplicates([Head | Tail], [Head | Result]) :-
    remove_duplicates(Tail, Result).

current_safest_cell(room(X, Y)) :- findall(S, total_current_score(room(_, _), S), L),
                                  min_list(L, MinScore),
                                  index_of(MinScore, L, Idx),
                                  nth0(Idx, L, room(X, Y)).

% From reference (hilios):
% index_of([H|_], H, 0):- !.
% index_of([_|T], H, Index):- index_of(T, H, OldIndex), !, Index is OldIndex + 1.
% I hope the following works:
index_of(Elt, Lst, Idx) :- nth0(Idx, Lst, Elt).

total_current_score(room(X, Y), S) :- safe(room(X, Y)), S is 0. % or -inf?
total_current_score(room(X, Y), S) :- findall(P, partial_score(room(X, Y), P), L), sum_list(L, S).

% The lower the score, the safer the room
partial_score(room(X, Y), S) :- explorableRooms(E), member(room(X, Y), E), has_pit(room(X, Y), yes), S is 1000.
partial_score(room(X, Y), S) :- explorableRooms(E), member(room(X, Y), E), has_wumpus(room(X, Y), yes), S is 2000.
partial_score(room(X, Y), S) :- explorableRooms(E), member(room(X, Y), E), has_pit(room(X, Y), maybe), S is 400.
partial_score(room(X, Y), S) :- explorableRooms(E), member(room(X, Y), E), has_wumpus(room(X, Y), maybe), S is 800.

% A bunch of atomic moves from X, Y to A, B
% traveling from xy to ab through zw is equivalent to moving from xy to zw atomically then traveling from zw to ab
% base case: same room
% zw is xy's parent
travel(room(A, B), room(A, B), _).
travel(room(X, Y), room(A, B), T) :- room(Z, W), parent(room(Z, W), room(X, Y)), 
                    move(room(X, Y), room(Z, W), T), U is T+1, travel(room(Z, W), room(A, B), U), !.
