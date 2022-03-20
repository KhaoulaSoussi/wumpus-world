% ideally, we would order the rules in terms of meaning (actions, sensors, score-keeping, etc.) while preserving correctness for search

:- abolish(position/2).
:- abolish(wumpus_alive/0).
:- abolish(gold/1).
:- abolish(visited/2).
:- abolish(did_shoot/2).
:- abolish(score/1).

:- dynamic([
  position/2,
  wumpus_alive/0,
  gold/1,
  visited/2,
  did_shoot/2,
  score/1,
  glitter/1,
  did_grab/0,
  pit/1,
  player_alive/0,
  parent/2
]).

valid(X) :- X is 1; X is 2; X is 3; X is 4.
in_bounds(X, Y) :- valid(X), valid(Y).
room(X, Y) :- in_bounds(X, Y).
adjacent(room(X, Y), room(A, B)) :- room(X, Y), room(A, B),
                                    (A is X-1, B is Y ;
                                    A is X+1, B is Y ;
                                    A is X, B is Y-1 ;
                                    A is X, B is Y+1).

safe(room(X, Y)) :- visited(room(X, Y), _), !.
safe(room(X, Y)) :- has_wumpus(room(X, Y), no), has_pit(room(X, Y), no).
visited(room(X, Y), _) :- asserta(safe(room(X, Y))). % bad
% safe(room(X, Y)) :- not(pit(room(X, Y))), not(wumpus(room(X, Y))).

% SENSORS
breeze(room(X, Y), yes) :- pit(room(A, B)), adjacent(room(X, Y), room(A, B)), !.
breeze(room(_, _), no).
glitter(room(X, Y), yes) :- gold(room(X, Y)).
glitter(room(_, _), no).
stench(room(X, Y), yes) :- wumpus(room(A, B)), adjacent(room(X, Y), room(A, B)), !.
stench(room(_, _), no).
scream(yes) :- dead().
scream(no).

perceptions([Stench, Breeze, Glitter, Scream]) :- position(room(X, Y), T),
                                                  stench(room(X,Y), Stench),
                                                  format("[IN Perceptions] : Stench percept in room(~w,~w): ~w!~n", [X,Y,Stench]),
                                                  breeze(room(X,Y), Breeze),
                                                  format("[IN Perceptions] : Breeze percept in room(~w,~w): ~w!~n", [X,Y,Breeze]),
                                                  glitter(room(X,Y), Glitter),
                                                  format("[IN Perceptions] : Glitter percept in room(~w,~w): ~w!~n", [X,Y,Glitter]),
                                                  scream(Scream),
                                                  format("[IN Perceptions] : Percepts in room(~w,~w) at time ~w: [~w,~w,~w,~w]!~n", [X,Y,T,Stench,Breeze,Glitter,Scream]),!.

% GOLD STATE
%%% No need for this anymore right?
% has_gold() :- did_grab(), not(climb()).

% ACTIONS
% move from room(X, Y) to room(A, B) -- atomic move
%%% no need for the two first rules position(room(X, Y), T), adjacent(room(X, Y), room(A, B)) because we would only call shoot once we check for these
move(room(X, Y), room(A, B), T, backtrack) :- room(A,B) \== room(X,Y), position(room(X, Y), T), adjacent(room(X, Y), room(A, B)),
								retractall(position(_, _)),
								Z is T+1,
								asserta(position(room(A, B), Z)),
                retractall(visited(room(A, B), _)), % to avoid redundancy
								assertz(visited(room(A, B), Z)),
								score(S),
								C is S - 1,
								retractall(score(_)),
								asserta(score(C)), format("Moved from room(~w,~w) to room(~w,~w) at time ~w~n", [X,Y,A,B,T]),
                asserta(safe(room(A, B))), !.

move(room(X, Y), room(A, B), T, simple) :- room(A,B) \== room(X,Y), position(room(X, Y), T), adjacent(room(X, Y), room(A, B)),
								retractall(position(_, _)),
								Z is T+1,
								asserta(position(room(A, B), Z)),
                retractall(visited(room(A, B), _)), % to avoid redundancy
								assertz(visited(room(A, B), Z)),
                retractall(parent(_, room(A, B))),
								asserta(parent(room(X, Y), room(A, B))),
								score(S),
								C is S - 1,
								retractall(score(_)),
								asserta(score(C)), format("Moved from room(~w,~w) to room(~w,~w) at time ~w~n", [X,Y,A,B,T]),
                asserta(safe(room(A, B))), !.

%%% Do we use did_grab() anywhere? We can just remove it!
grab_gold() :- position(room(X, Y), T), gold(room(X, Y)),
				retractall(gold(_)),
				retractall(glitter(_)),
                score(S),
                C is S + 100 - 1,
                retractall(score(_)),
                asserta(score(C)),
                retractall(did_grab()),
                asserta(did_grab()),
                format("Grabbed gold from room(~w,~w) at time ~w~n", [X,Y,T]).


%%% no need for the two first rules position(room(X, Y), T), adjacent(room(X, Y), room(A, B)) because we would only call shoot once we check for these
shoot(room(X, Y), T) :- write('shooting'), nl, position(room(A, B), T), adjacent(room(X, Y), room(A, B)), not(did_shoot(_, _)),
 					retractall(did_shoot(_, _)),
 					asserta(did_shoot(X, Y)),
 					score(S),
 					C is S - 10,
 					retractall(score(_)),
 					asserta(score(C)),
 					format("Shot room(~w,~w) at time ~w~n", [X,Y,T]), !.

dead() :- did_shoot(X, Y), wumpus(room(X, Y)), retractall(wumpus_alive()).

% Note: kill is not an action that is actively performed by the agent.
% It is just an abstraction to verify the death of the Wumpus.
kill() :- shoot(room(X, Y), _), wumpus(room(X, Y)),
 		retractall(wumpus_alive()),
 		retractall(wumpus(room(X, Y))).

%%% To avoid performing the shoot when "calling" kill(), we can do the following given that we change the rule did_shoot to take an argument which is the room that was shot
%%% I didn't change did_shoot() anywhere yet, this is just a suggestion
kill() :- shoot(room(X, Y), _), wumpus(room(X, Y)),
 		retractall(wumpus_alive()),
 		retractall(wumpus(room(X, Y))).

/* climb(T) :- P is T-1, position(room(X, Y), P), pit(room(X, Y)),
				did_grab(), has_gold(),
				retractall(has_gold()),
				score(S),
				C is S - 1000 - 1,
                retractall(score(_)),
                asserta(score(C)). */

fall(T) :- position(room(X, Y), T), pit(room(X, Y)),
		score(S),
		C is S - 1000,
		retractall(score(_)),
		asserta(score(C)),
		retractall(player_alive()).

eaten(T) :- position(room(X, Y), T), wumpus(room(X, Y)),
		score(S),
		C is S - 1000,
		retractall(score(_)),
		asserta(score(C)),
		retractall(player_alive()).

start_game() :- loop(0).

loop(200) :- write('Game Over... Too much time spent!'), nl, !. % halt(),

loop(Iter) :-
  perceptions(L),
  format("[IN LOOP] : Perceptions in loop iter ~w: ~w!~n", [Iter,L]),
  heuristic(L),
  position(room(X, Y), T),
  (fall(T) -> (
    format("Game Over... You fell in a pit in room(~w,~w) at time ~w!~n", [X,Y,T]),
	halt
  );
  eaten(T) -> (
    format("Game Over... You were eaten by the wumpus in room(~w,~w) at time ~w!~n", [X,Y,T]),
	halt
  );
  score(S),
  S < 1 -> (
	format("Game Over... Your life ran out in room(~w,~w) at time ~w!~n", [X,Y,T]),
	halt
  );
  dead() -> (
    format("won!"), halt
  );
  (did_shoot(_, _), wumpus_alive() -> (
    format("Missed your shot -- no way to win.")
    % , halt
  )));
  Next is Iter + 1,
  loop(Next).
