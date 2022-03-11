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
has_wumpus(room(X,Y), maybe) :- adjacent(room(X,Y), room(A, B)) , stench(room(A,B)), !.

tell_kb(breeze) :- assertz(breeze(room(X,Y))).
tell_kb(stench) :- assertz(stench(room(X,Y))).
tell_kb(glitter) :- assertz(glitter(room(X,Y))).
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
% Breeze: same as stench

% leila
% Glitter: grab

% Leila
% safest move (score)

% leila
% parent

% leila
% climb heuristic


