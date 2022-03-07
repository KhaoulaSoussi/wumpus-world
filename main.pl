% order of the rules needs to be verified
% ideally, we would arrange them in terms of meaning (actions, sensors, score-keeping, etc.) while preserving correctness for search

% i need to take a better look at these
:- abolish(position/2). % room, time
:- abolish(wumpus_alive/0). % no argument
:- abolish(gold/1). % room
:- abolish(visited/2). % room, time
:- abolish(did_shoot/0).
% player life too? score?

% See: http://www.cse.unsw.edu.au/~billw/dictionaries/prolog/dynamic.html#:~:text=dynamic&text=In%20Prolog%2C%20a%20procedure%20is,loaded%20during%20the%20Prolog%20session.
:- dynamic([
  position/2,
  wumpus_alive/0,
  gold/1,
  visited/2,
  did_shoot/0
]).

did_grab(_) :- false.
used_gold(_) :- false.

% we have to define different worlds in other pl files.
world_A(4, 4).
% can we pass filename for world as argument?
% world_B(4,4).

% rooms are 1-indexed
%ERROR: c:/users/mouss/documents/wumpus-world/main.pl:28:29: Syntax error: Operator expected
% i tried upper case variable names too.
in_bounds(x, y) :- x >= 1, x <= 4, y >= 1, y <= 4.
room(X, Y) :- in_bounds(X, Y).
adjacent(room(X, Y), room(A, B)) :- A is X-1, B is Y ;
									A is X+1, B is Y ; 
									A is X, B is Y-1 ; 
									A is X, B is Y+1.
safe(room(X, Y)) :- not(pit(room(X, Y)); wumpus(room(X, Y))).

% SENSORS
% might have to add ! to these for more efficient search
breeze(room(X, Y)) :- adjacent(room(X, Y), room(A, B)), pit(room(A, B)).
glitter(room(X, Y)) :- gold(room(X, Y)).
stench(room(X, Y)) :- adjacent(room(X, Y), room(A, B)), wumpus(room(A, B)).
% There is a bump if current position is a wall
% is that useful? maybe it is if we think of orientation, which we are not right now.
%Bump(room(X, Y)) :- .
% There is a scream the moment wumpus is killed
scream(T) :- kill(T), asserta(not(wumpus_alive())).

% ACTIONS
move(room(X, Y), room(A, B), T) :- adjacent(room(X, Y), room(A, B)),
								retractall(position(_, _)),
								asserta(position(room(X, Y), T+1)),
								assertz(visited(room(X, Y), T+1)),
								score(S),
								retractall(score(_)),
								asserta(score(S - 1)).
% We need a better understand of when to use timestamps.
grab_gold(room(X, Y), T) :- position(room(X, Y), T), gold(room(X, Y)),
						retractall(gold(_)),
						retractall(glitter(_)), % become false
						score(S),
						retractall(score(_)),
						asserta(score(S + 1000 - 1)),
						retractall(did_grab(_)),
						asserta(did_grab()).
shoot(room(X, Y), T) :- position(room(A, B), T), adjacent(room(X, Y), room(A, B)), has_arrows(),
					retractall(did_shoot()),
					asserta(did_shoot()),
					score(S),
					retractall(score(_)),
					asserta(score(S - 10)).
kill(T) :- shoot(room(X, Y), T), wumpus(room(X, Y)),
		retractall(wumpus_alive()),
		retractall(wumpus(room(X, Y))),
		asserta(not(wumpus(room(X, Y)))). % to make the room safe

has_arrows(_) :- not(did_shoot()).
has_gold() :- did_grab(), not(climb()).

%has_gold(_) :- did_grab(_), not(used_gold(_)).
% climb_pit(room(X, Y)) :- position(room(X, Y), T), pit(room(X, Y)),
% 				did_grab(_), has_gold(_), 
% 				retractall(used_gold()),
% 				asserta(used_gold()).

fall(T) :- position(room(X, Y), T), pit(room(X, Y)),
		score(S),
		retractall(score(_)),
		asserta(score(S - 1000)).
climb(T) :- fall(T-1), has_gold(T-1),
			retractall(has_gold(_)),
			asserta(not(has_gold(_))),
			score(S),
			retractall(score(_)),
			asserta(score(S - 1)).

eaten(T) :- position(room(X, Y), T), wumpus(room(X, Y)),
		score(S),
		retractall(score(_)),
		asserta(score(S - 1000)).
