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
  did_grab/0
]).

% did_grab() :- false.
% used_gold() :- false.

% :- ensure_loaded('./initial_states.pl').
% :- ensure_loaded('./world_a.pl').

% INITIAL STATES
position(room(1, 1), 0).
score(0).
has_arrows().
wumpus_alive().
player_alive().
visited(room(1, 1), 0).
pit(room(1, 1)) :- false.
wumpus(room(1, 1)) :- false.
gold(room(1, 1)) :- false.
did_shoot() :- false.
did_grab() :- false.
used_gold() :- false.

% WORLD
wumpus(room(1, 3)).
pit(room(3, 1)).
pit(room(3, 3)).
pit(room(4, 4)).
gold(room(2, 3)).

% this works so far
valid(X) :- X is 1; X is 2; X is 3; X is 4.
in_bounds(X, Y) :- valid(X), valid(Y).
room(X, Y) :- in_bounds(X, Y).
adjacent(room(X, Y), room(A, B)) :- room(X, Y), room(A, B), (A is X-1, B is Y ;
									A is X+1, B is Y ; 
									A is X, B is Y-1 ; 
									A is X, B is Y+1).
%safe(room(X, Y)) :- not(pit(room(X, Y)); wumpus(room(X, Y))).
safe(room(X, Y)) :- not(pit(room(X, Y))), not(wumpus(room(X, Y))).

% SENSORS
% might have to add ! to these for more efficient search
breeze(room(X, Y)) :- pit(room(A, B)), adjacent(room(X, Y), room(A, B)).
glitter(room(X, Y)) :- gold(room(X, Y)).
stench(room(X, Y)) :- room(A, B), adjacent(room(X, Y), room(A, B)), wumpus(room(A, B)).
% There is a bump if current position is a wall
% is that useful? maybe it is if we think of orientation, which we are not right now.
%Bump(room(X, Y)) :- .
% There is a scream the moment wumpus is killed
scream(T) :- kill(T), asserta(not(wumpus_alive())).

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
								asserta(score(C)),
								!.
								% TODO: printing.

grab_gold(room(X, Y), T) :- position(room(X, Y), T), gold(room(X, Y)),
						retractall(gold(_)),
						retractall(glitter(_)),
						score(S),
						C is S + 1000 - 1,
						retractall(score(_)),
						asserta(score(C)),
						retractall(did_grab()),
						asserta(did_grab()).
shoot(room(X, Y), T) :- position(room(A, B), T), adjacent(room(X, Y), room(A, B)), has_arrows(),
					retractall(did_shoot()),
					asserta(did_shoot()),
					score(S),
					retractall(score(_)),
					asserta(score(S - 10)).
% kill(T) :- shoot(room(X, Y), T), wumpus(room(X, Y)),
% 		retractall(wumpus_alive()),
% 		retractall(wumpus(room(X, Y))),
% 		asserta(not(wumpus(room(X, Y)))). % to make the room safe

% has_arrows(_) :- not(did_shoot()).
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
