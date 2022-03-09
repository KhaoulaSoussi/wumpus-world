:- dynamic([
  stench/1,
  breeze/1
]).

has_pit(room(X,Y), yes) :- room(A,B), breeze(room(A,B)), adjacent(room(X,Y), room(A, B)), no_surrounding_pit(room(A,B)).

no_surrounding_pit(room(A,B)) :- room(X,Y), adjacent(room(X,Y), room(A, B)), not(has_pit(room(X,Y), no)) , !, fail.

has_wumpus(room(X,Y), yes) :- room(A,B), stench(room(A,B)), adjacent(room(X,Y), room(A, B)), no_surrounding_wumpus(room(A,B)).

no_surrounding_wumpus(room(A,B)) :- room(X,Y), adjacent(room(X,Y), room(A, B)), not(has_wumpus(room(X,Y), no)) , !, fail.

has_pit(room(X,Y), no) :- (position(room(A, B), _), adjacent(room(X,Y), room(A, B)), not(breeze(room(A,B))));
                      has_wumpus(room(X,Y)).
has_wumpus(room(X,Y), no) :- (position(room(A, B), _), adjacent(room(X,Y), room(A, B)), not(stench(room(A,B)))).
                        has_pit(room(X,Y)).

% This rule states cases where there may be a pit in room(X,Y)
has_pit(room(X,Y), maybe) :-  adjacent(room(X,Y), room(A, B)) , breeze(room(A,B)), !.

% This rule states cases where the wumpus may be in room(X,Y)
has_wumpus(room(X,Y), maybe) :- adjacent(room(X,Y), room(A, B)) , stench(room(A,B)), !.

tell_kb(breeze) :- assertz(breeze(room(X,Y))).
tell_kb(stench) :- assertz(stench(room(X,Y))).
tell_kb(glitter) :- assertz(glitter(room(X,Y))).
tell_kb(scream) :- assertz(scream()).

% Exit the game once the wumpus is killed





