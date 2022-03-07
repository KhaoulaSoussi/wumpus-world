% order of the rules needs to be verified

% i need to take a better look at these
:- abolish(position/2). % room, time
:- abolish(wumpus_alive/0). % no argument
:- abolish(gold/1). % room
:- abolish(visited/2). % room, time
:- abolish(did_shoot/0).
% player life too? score?

% http://www.cse.unsw.edu.au/~billw/dictionaries/prolog/dynamic.html#:~:text=dynamic&text=In%20Prolog%2C%20a%20procedure%20is,loaded%20during%20the%20Prolog%20session.
:- dynamic([
  position/2,
  wumpus_alive/0,
  gold/1,
  visited/2,
  did_shoot/0
]).

% we have to define different worlds in other pl files.
world_A(4, 4).
% can we pass filename for world as argument?
%world_B(4,4).

% rooms are 1-indexed
% Annoying error I don't know how to fix
%ERROR: c:/users/mouss/documents/wumpus-world/main.pl:28:29: Syntax error: Operator expected
in_bounds(X, Y) :- X >= 1, X <= 4, Y >= 1, Y <= 4.
room(X, Y) :- in_bounds(X, Y).
adjacent(room(X, Y), room(A, B)) :- A is X-1, B is Y ; A is X+1, B is Y ; A is X, B is Y-1 ; A is X, B is Y+1.
safe(room(X, Y)) :- not(pit(room(X, Y)); wumpus(room(X, Y))).
% should the initial score be defined in world builder? there are a lot of initial facts. maybe it is better to put them here because they are shared among worlds. or maybe we can put them in a file of their own.
score(0, 0). % score is 0 at t=0
% disregard the following line right now
%score(S, H) :- score(Head + sum_list(Tail), [Head|Tail]).  % sum of list

% SENSORS
% might have to add ! to these for more efficient search
breeze(room(X, Y)) :- adjacent(room(X, Y), room(A, B)), pit(room(A, B)).
glitter(room(X, Y)) :- gold(room(X, Y)).
stench(room(X, Y)) :- adjacent(room(X, Y), room(A, B)), wumpus(room(A, B)).
% There is a bump if current position is a wall
% is that useful? maybe if we think of orientation, which we are not right now.
%Bump(room(X, Y)) :- .
% There is a scream the moment wumpus is killed
scream(T) :- kill(T), asserta(not(wumpus_alive())).

% ACTIONS
move(room(X, Y), room(A, B), T) :- adjacent(room(X, Y), room(A, B)),
								retractall(position(_, _)),
								asserta(position(room(X, Y), T+1)),
								assertz(visited(room(X, Y), T+1)).
grab_gold(room(X, Y)) :- position(room(X, Y), T), gold(room(X, Y)),
						retractall(gold(_)),
						retractall(glitter(_)),
						score(S, T),
						asserta(score(S+1000, T+1)), % add to score
						asserta(position(room(X, Y), T+1)).  % this does not look good: it keeps the player in the same position in 2 consecutive moments because they grabbed gold
shoot(room(X, Y), _) :- position(room(A, B)), adjacent(room(X, Y), room(A, B)), has_arrows(),
					retractall(did_shoot()),
					asserta(did_shoot()).
kill(T) :- shoot(room(X, Y), T), wumpus(room(X, Y)),
		retractall(wumpus_alive()),
		retractall(wumpus(room(X, Y))),
		asserta(not(wumpus(room(X, Y)))). % to make the room safe

has_arrows() :- not(did_shoot()).
% player has gold (and can use it to get out of pits) if they grabbed some gold before and did not use it yet
%has_gold() :- .