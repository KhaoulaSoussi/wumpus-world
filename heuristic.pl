:- dynamic([
  stench/1,
  breeze/1,
  glitter/1,
  scream/0
]).

has_pit(room(X,Y), yes) :- room(A,B), breeze(room(A,B)), adjacent(room(X,Y), room(A, B)), no_surrounding_pit(room(A,B)).
no_surrounding_pit(room(A,B)) :- room(X,Y), adjacent(room(X,Y), room(A, B)), not(has_pit(room(X,Y), no)) , !, fail.

has_wumpus(room(X,Y), yes) :- room(A,B), stench(room(A,B)), adjacent(room(X,Y), room(A, B)), no_surrounding_wumpus(room(A,B)).
no_surrounding_wumpus(room(A,B)) :- room(X,Y), adjacent(room(X,Y), room(A, B)), not(has_wumpus(room(X,Y), no)) , !, fail.

has_pit(room(X,Y), no) :- (position(room(A, B), _), adjacent(room(X,Y), room(A, B)), not(breeze(room(A,B))));
                      has_wumpus(room(X,Y), yes).
has_wumpus(room(X,Y), no) :- (position(room(A, B), _), adjacent(room(X,Y), room(A, B)), not(stench(room(A,B)))).
                        has_pit(room(X,Y), yes).

% This rule states cases where there may be a pit in room(X,Y)
has_pit(room(X,Y), maybe) :- not(has_pit(room(X, Y), yes)), not(has_pit(room(X, Y), no)),
                          adjacent(room(X,Y), room(A, B)) , breeze(room(A,B)), !.

% This rule states cases where the wumpus may be in room(X,Y)
has_wumpus(room(X,Y), maybe) :- adjacent(room(X, Y), room(A, B)) , stench(room(A, B)), !.

tell_kb(breeze) :- position(room(X, Y), _), assertz(breeze(room(X, Y))).
tell_kb(stench) :- position(room(X, Y), _), assertz(stench(room(X, Y))).
tell_kb(glitter) :- position(room(X, Y), _), assertz(glitter(room(X, Y))).
tell_kb(scream) :- assertz(scream()).

% HEURISTICS
% Khaoula
% Stench: if we have has_wumpus(room(X, Y), yes) for some adjacent room(X, Y), shoot there
% else, move to the safest adjacent room to gather more info
% if no such moves exists, shoot randomly at any of the adjacents that have wumpus maybe

%ignore these for now, I still need to fix many stuff
heuristic(perceptions([yes, _, _, _])) :- position(room(X, Y), T), adjacent(room(X, Y), room(A, B)),
                                          has_wumpus(room(A,B), yes), shoot(room(A, B), T).
% only if the above was false, we would move to this one
heuristic(perceptions([yes, _, _, _])) :- position(room(X, Y), T), adjacent(room(X, Y), room(A, B)),
                                          not(has_wumpus(room(A,B), yes)), not(has_wumpus(room(A,B), maybe)),
                                          not(has_pit(room(A,B), yes)), not(has_pit(room(A,B), maybe)),
                                          move(room(X, Y), room(A, B), T).
% only if the two above heuristics are face, we move to this one
heuristic(perceptions([yes, _, _, _])) :- position(room(X, Y), T), adjacent(room(X, Y), room(A, B)),
                                          has_wumpus(room(A,B), maybe), shoot(room(A, B), T).

% khaoula
% Scream: quit

% khaoula
% define explorable cells (visited + neighbors of visited)


% leila
% Breeze: just move to the best place
heuristic([_, yes, _, _], move(room(X, Y), room(A, B), T)) :- tell_kb(breeze), current_safest_cell(room(A, B)).

% leila
% Glitter: grab
heuristic([_, _, yes, _], grab_gold) :- tell_kb(glitter), !.

% Leila
% safest move (score)
current_safest_cell(room(X, Y)) :- !. % find the room corresponding to the minimum score

total_current_score(room(X, Y), T) :- findall(P, partial_score(room(X, Y), P), L), sum_list(L, T).

% The lower the score, the safer the room
partial_score(room(X, Y), S) :- has_pit(room(X, Y), yes), S is 1000.
partial_score(room(X, Y), S) :- has_wumpus(room(X, Y), yes), S is 2000.
partial_score(room(X, Y), S) :- has_pit(room(X, Y), maybe), S is 400.
partial_score(room(X, Y), S) :- has_wumpus(room(X, Y), maybe), S is 800.

% khaoula
% define explorable cells (visited + neighbors of visi)

% A bunch of atomic moves from X, Y to A, B
% traveling from xy to ab through zw is equivalent to moving from xy to zw atomically then traveling from zw to ab
% base case: same room
% zw is xy's parent (hopefully)
travel(room(X, Y), room(A, B), T) :- room(Z, W), parent(room(Z, W), room(X, Y)), 
                    move(room(X, Y), room(Z, W), T), U is T+1, travel(room(Z, W), room(A, B), U), !.
