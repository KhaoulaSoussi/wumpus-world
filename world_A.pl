% Here we can define a world in terms of placement of pits, wumpus, and gold.
% I'd rather world_A is the same one in the illustration. No particular reason, it just feels right.
% so why make the 2 a 3?
wumpus(room(1, 3)).
pit(room(3, 1)).
pit(room(3, 3)).
pit(room(4, 4)).
gold(room(2, 3)).
