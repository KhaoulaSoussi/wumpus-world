% order of the rules needs to be verified

% i need to take a better look at these
:- abolish(Position/2).
:- abolish(WumpusAlive/2). % initially true
:- abolish(Gold/2).
:- abolish(Visited/2).
:- abolish(DidShoot/2). % shoot is the action. didshoot keeps track of how many arrows are left -- initially false
% player life too?

% http://www.cse.unsw.edu.au/~billw/dictionaries/prolog/dynamic.html#:~:text=dynamic&text=In%20Prolog%2C%20a%20procedure%20is,loaded%20during%20the%20Prolog%20session.
:- dynamic([
  Position/2,
  WumpusAlive/2,
  Gold/2,
  Visited/2,
  DidShoot/2,
]).

% we have to define different worlds in other pl files.
world_A(4, 4).
% can we pass filename for world as argument?
%world_B(4,4).

Adjacent(Room(X, Y), Room(A, B)) :- A is X-1, B is Y ; A is X+1, B is Y ; A is X, B is Y-1 ; A is X, B is Y+1.
Safe(Room(X, Y)) :- not(Pit(Room(X, Y)); Wumpus(Room(X, Y))).
InBounds(Room(X, Y)) :- X >= 0, X <= 4, Y >= 0, Y <= 4.
% should the initial score be defined in world builder? there are a lot of initial facts. maybe it is better to put them here because they are shared among worlds. or maybe we can put them in a file of their own.
Score(0, 0). % score is 0 at t=0
% disregard the following line right now
%Score(S, H) :- Score(Head + sum_list(Tail), [Head|Tail]).  % sum of list

% SENSORS
% might have to add ! to these for more efficient search
Breeze(Room(X, Y)) :- Adjacent(Room(X, Y), Room(A, B)), Pit(Room(A, B)).
Glitter(Room(X, Y)) :- Gold(Room(X, Y)).
Stench(Room(X, Y)) :- Adjacent(Room(X, Y), Room(A, B)), Wumpus(Room(A, B)).
% There is a bump if current position is a wall
% is that useful? maybe if we think of orientation, which we are not right now.
%Bump(Room(X, Y)) :- .
% There is a scream the moment wumpus is killed
Scream(T) :- Kill(T), asserta(not(WumpusAlive())),.

% ACTIONS
Move(Room(X, Y), Room(A, B), T) :- InBounds(Room(X, Y)), Adjacent(Room(X, Y), Room(A, B)),
								retractall(Position(_, _)),
								asserta(Position(Room(X, Y), T+1)),
								assertz(Visited(Room(X, Y), T+1)).
GrabGold(Room(X, Y)) :- Position(Room(X, Y), T), Gold(Room(X, Y)),
						retractall(Gold(_)),
						retractall(Glitter(_)),
						Score(S, T),
						asserta(Score(S+1000, T+1)), % add to score
						asserta(Position(Room(X, Y), T+1)).  % this does not look good: it keeps the player in the same position in 2 consecutive moments because they grabbed gold
Shoot(Room(X, Y), _) :- Position(Room(A, B)), Adjacent(Room(X, Y), Room(A, B)), HasArrows(),
					retractall(DidShoot()),
					asserta(DidShoot()).
Kill(T) :- Shoot(Room(X, Y), T), Wumpus(Room(X, Y)),
		retractall(WumpusAlive()),
		retractall(Wumpus(Room(X, Y))),
		asserta(not(Wumpus(Room(X, Y)))). % to make the room safe

HasArrows() :- not(DidShoot()).
% player has gold (and can use it to get out of pits) if they grabbed some gold before and did not use it yet
%HasGold() :- .