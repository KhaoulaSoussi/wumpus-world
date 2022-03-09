% order of the rules needs to be verified
% ideally, we would arrange them in terms of meaning (actions, sensors, score-keeping, etc.) while preserving correctness for search

% i need to take a better look at these
:- abolish(position/2). % room, time
:- abolish(wumpus_alive/0). % no argument
:- abolish(gold/1). % room
:- abolish(visited/2). % room, time
:- abolish(did_shoot/0).
:- abolish(score/1).
:- abolish(glitter/1).
:- abolish(did_grab/0).
% player life too?

% See: http://www.cse.unsw.edu.au/~billw/dictionaries/prolog/dynamic.html#:~:text=dynamic&text=In%20Prolog%2C%20a%20procedure%20is,loaded%20during%20the%20Prolog%20session.
:- dynamic([
  position/2,
  wumpus_alive/0,
  gold/1,
  visited/2,
  did_shoot/0,
  score/1,
  glitter/1,
  did_grab/0,
  pit/1
]).

valid(X) :- X is 1; X is 2; X is 3; X is 4.
in_bounds(X, Y) :- valid(X), valid(Y).
room(X, Y) :- in_bounds(X, Y).
adjacent(room(X, Y), room(A, B)) :- room(X, Y), room(A, B),
                                    (A is X-1, B is Y ;
									A is X+1, B is Y ;
									A is X, B is Y-1 ;
									A is X, B is Y+1).
safe(room(X, Y)) :- not(pit(room(X, Y))), not(wumpus(room(X, Y))).

% SENSORS
breeze(room(X, Y), yes) :- pit(room(A, B)), adjacent(room(X, Y), room(A, B)), !.
glitter(room(X, Y), yes) :- gold(room(X, Y)).
stench(room(X, Y), yes) :- room(A, B), adjacent(room(X, Y), room(A, B)), wumpus(room(A, B)), !.
scream(yes) :- kill().
breeze(room(X, Y), no).
glitter(room(X, Y), no).
stench(room(X, Y), no).
scream(no).

perceptions([Stench, Breeze, Glitter, Scream]) :- position(room(X, Y), _),
                                                  stench(room(X,Y), Stench),
                                                  breeze(room(X,Y), Breeze),
                                                  glitter(room(X,Y), Breeze),
                                                  scream(Scream), !.

% % ACTIONS
% move from x, y to a, b
move(room(X, Y), room(A, B), T) :- position(room(X, Y), T), adjacent(room(X, Y), room(A, B)),
								retractall(position(_, _)),
								Z is T+1,
								asserta(position(room(A, B), Z)),
								assertz(visited(room(A, B), Z)),
								score(S),
								C is S - 1,
								retractall(score(_)),
								asserta(score(C)), !.
% We need a better understanding of when to use timestamps.
grab_gold(room(X, Y), T) :- position(room(X, Y), T), gold(room(X, Y)),
						retractall(gold(_)),
						retractall(glitter(_)),
						score(S),
						C is S + 1000 - 1,
						retractall(score(_)),
						asserta(score(C)),
						retractall(did_grab()),
						asserta(did_grab()), print('You grabbed the gold at time T = ').
shoot(room(X, Y)) :- position(room(A, B), _), adjacent(room(X, Y), room(A, B)), not(did_shoot()),
 					retractall(did_shoot()),
 					asserta(did_shoot()),
 					score(S),
 					C is S - 10,
 					retractall(score(_)),
 					asserta(score(C)), !.

kill() :- shoot(room(X, Y)), wumpus(room(X, Y)),
 		retractall(wumpus_alive()),
 		retractall(wumpus(room(X, Y))),
 		asserta(not(wumpus(room(X, Y)))). % to make the room safe

% has_gold() :- did_grab(), not(climb()).

% %has_gold(_) :- did_grab(_), not(used_gold(_)).
% % climb_pit(room(X, Y)) :- position(room(X, Y), T), pit(room(X, Y)),
% % 				did_grab(_), has_gold(_), 
% % 				retractall(used_gold()),
% % 				asserta(used_gold()).

% fall(T) :- position(room(X, Y), T), pit(room(X, Y)),
% 		score(S),
%		C is S - 1000,
% 		retractall(score(_)),
% 		asserta(score(C)).

climb(T) :- P is T-1, fall(P), has_gold(P),
			retractall(has_gold(_)),
			asserta(not(has_gold(_))),
			score(S),
			C is S - 1,
			retractall(score(_)),
			asserta(score(C)).

eaten(T) :- position(room(X, Y), T), wumpus(room(X, Y)),
		score(S),
		C is S - 1000,
		retractall(score(_)),
		asserta(score(C)),
		retractall(player_alive()).
