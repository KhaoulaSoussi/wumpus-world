:- dynamic([
  stench/1,
  breeze/1
]).

breeze(room(2,3)).
breeze(room(3,2)).

% This rule states cases where there must be a pit in room(X,Y)
pit(room(X,Y)) :-   A is X - 1, B is Y + 1, breeze(room(X,A)), breeze(room(X,B));
                    A is X + 1, B is Y - 1, breeze(room(A,Y)), breeze(room(X,B));
                    A is X - 1, B is Y - 1, breeze(room(A,Y)), breeze(room(X,B));
                    A is X + 1, B is Y + 1, breeze(room(A,Y)), breeze(room(X,B));
                    A is X - 1, B is Y + 1, breeze(room(A,Y)), breeze(room(X,B));
                    A is X - 1, B is X + 1, breeze(room(A,Y)), breeze(room(B,Y)).

% This rule states cases where the wumpus must be in room(X,Y)
wumpus(room(X,Y)) :-   A is X - 1, B is Y + 1, stench(room(X,A)), stench(room(X,B));
                       A is X + 1, B is Y - 1, stench(room(A,Y)), stench(room(X,B));
                       A is X - 1, B is Y - 1, stench(room(A,Y)), stench(room(X,B));
                       A is X + 1, B is Y + 1, stench(room(A,Y)), stench(room(X,B));
                       A is X - 1, B is Y + 1, stench(room(A,Y)), stench(room(X,B));
                       A is X - 1, B is X + 1, stench(room(A,Y)), stench(room(B,Y)).

tell_kb(Breeze) :- position(room(X, Y), _), assertz(breeze(room(X,Y))).
tell_kb(Stench) :- position(room(X, Y), _), assertz(stench(room(X,Y))).

% Exit the game once the wumpus is killed





