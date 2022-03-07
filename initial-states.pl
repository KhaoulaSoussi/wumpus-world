% Initial states common to all worlds.
position(room(1, 1), 0).
score(0, 0).
has_arrows().
wumpus_alive().
PlayerAlive().
has_gold() :- false.
visited(room(1, 1), 0).
pit(room(1, 1)) :- false.
wumpus(room(1, 1)) :- false.
did_shoot() :- false.
