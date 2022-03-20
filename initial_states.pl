% Initial states common to all worlds.
position(room(1, 1), 0).
score(100).
wumpus_alive().
player_alive().
visited(room(1, 1), 0).
has_pit(room(1, 1), no).
has_wumpus(room(1, 1), no).
gold(room(1, 1)) :- false.
did_shoot(_ , _) :- false.
used_gold() :- false.
scream(no).
% add other non-perceptions for completeness, unless we don't need any of them.
safe(room(1, 1)). % would love to not need this.
