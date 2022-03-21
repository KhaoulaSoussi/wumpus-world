### World B 

```
[IN Perceptions] : Stench percept in room(1,1): no!
[IN Perceptions] : Breeze percept in room(1,1): no!
[IN Perceptions] : Glitter percept in room(1,1): no!
[IN Perceptions] : Percepts in room(1,1) at time 0: [no,no,no,no]!
[IN LOOP] : Perceptions in loop iter 0: [no,no,no,no]!
Traveled from room(1,1) to room(1,2) at time 0
[IN Perceptions] : Stench percept in room(1,2): yes!
[IN Perceptions] : Breeze percept in room(1,2): yes!
[IN Perceptions] : Glitter percept in room(1,2): no!
[IN Perceptions] : Percepts in room(1,2) at time 1: [yes,yes,no,no]!
[IN LOOP] : Perceptions in loop iter 1: [yes,yes,no,no]!
# ...
Traveled from room(1,2) to room(2,1) at time 1
# ...
[IN Perceptions] : Stench percept in room(2,1): yes!
[IN Perceptions] : Breeze percept in room(2,1): no!
[IN Perceptions] : Glitter percept in room(2,1): no!
[IN Perceptions] : Percepts in room(2,1) at time 3: [yes,no,no,no]!
[IN LOOP] : Perceptions in loop iter 2: [yes,no,no,no]!
# ...
Shot room(2,2) at time 3
You won!
```

### Final state 

```
9 ?- has_pit(Room, Answer).
Room = room(1, 3),
Answer = yes ;
Room = room(2, 1),
Answer = no ;
Room = room(1, 2),
Answer = no ;
Room = room(1, 1),
Answer = no.

10 ?- has_wumpus(Room, Answer).
Room = room(2, 2),
Answer = yes ;
Room = room(1, 3),
Answer = no ;
Room = room(3, 1),
Answer = maybe ;
Room = room(2, 1),
Answer = no ;
Room = room(1, 2),
Answer = no ;
Room = room(1, 1),
Answer = no.

11 ?- score(S).
S = 87.

12 ?- visited(Room, _).
Room = room(2, 1) ;
Room = room(1, 2) ;
Room = room(1, 1).
```
