% Initial states common to all worlds.
Position(Room(1, 1), 0).
Score(0, 0).
HasArrows().
WumpusAlive().
PlayerAlive().
HasGold() :- false.
Visited(Room(1, 1), 0).
Pit(Room(1, 1)) :- false.
Wumpus(Room(1, 1)) :- false.
DidShoot() :- false.
