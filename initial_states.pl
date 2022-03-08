% Initial states common to all worlds.
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
