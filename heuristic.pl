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
% Khaoula
% Stench: if we have has_wumpus(room(X, Y), yes) for some adjacent room(X, Y), shoot there
% else, move to the safest adjacent room to gather more info
% if no such moves exists, shoot randomly at any of the adjacents that have wumpus maybe

% Shoot the wumpus when you are sure it is in room(A,B)
heuristic(perceptions([yes, _, _, _]), shoot) :- position(room(X, Y), T), adjacent(room(X, Y), room(A, B)),
                                          has_wumpus(room(A,B), yes), shoot(room(A, B), T), !.

% If not sure where the wumpus is, move to an adjacent room that may be safe
heuristic(perceptions([yes, _, _, _]), move) :- position(room(X, Y), T), adjacent(room(X, Y), room(A, B)),
                                          not(has_wumpus(room(A,B), yes)), not(has_wumpus(room(A,B), maybe)),
                                          not(has_pit(room(A,B), yes)), not(has_pit(room(A,B), maybe)),
                                          move(room(X, Y), room(A, B), T).

‰ If not sure where the wumpus is, and no adjacent room is maybe safe, shoot any random adjacent room where there may be the wumpus
heuristic(perceptions([yes, _, _, _]), shoot) :- position(room(X, Y), T), adjacent(room(X, Y), room(A, B)),
                                                 has_wumpus(room(A,B), maybe), shoot(room(A, B), T).

% Question: if we do not know where the wumpus is, but all the neighboring rooms have been visited except one, we can just shoot that one, right?
% Question: if we do not know where the wumpus is, should we move to a neighboring room that has not been visited yet??
% or maybe to be safer we can visit one that has already been visited and continue from there to other rooms unless we fall in a cycle

% khaoula
% Scream: quit
heuristic(perceptions([_, _, _, yes]), quit) :- write('Game over... You won!'), halt().

% khaoula
% define explorable cells (visited + neighbors of visited)
explorableRooms(L) :- position(room(X,Y), _),
                      findall(room(A,B), adjacent(room(X, Y), room(A, B)), L1),
                      findall(room(C,D), visited(room(C,D),_), L2),
                      append(L1, L2, R),
                      remove_duplicates(R, L).

% Tried to append without duplicates but didnt work
append_no_dupl(_, [], _).
append_no_dupl(L, [H|T], R) :- member(H, L), append_no_dupl(L, T, R).
append_no_dupl(L, [H|T], R) :- not(member(H, L)), append(L, [H], R), append_no_dupl(R, T, X).

remove_duplicates([], []).
remove_duplicates([Head | Tail], Result) :-
    member(Head, Tail), !,
    remove_duplicates(Tail, Result).
remove_duplicates([Head | Tail], [Head | Result]) :-
    remove_duplicates(Tail, Result).

% leila
% Breeze: same as stench

% leila
% Glitter: grab

% Leila
% safest move (score)

% leila
% parent

% leila
% climb heuristic


