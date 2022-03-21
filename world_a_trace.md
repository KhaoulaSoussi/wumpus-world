### World A 
```
[IN Perceptions] : Stench percept in room(1,1): no!
[IN Perceptions] : Breeze percept in room(1,1): no!
[IN Perceptions] : Glitter percept in room(1,1): no!
[IN Perceptions] : Percepts in room(1,1) at time 0: [no,no,no,no]!
[IN LOOP] : Perceptions in loop iter 0: [no,no,no,no]!
Traveled from room(1,1) to room(1,2) at time 0
[IN Perceptions] : Stench percept in room(1,2): yes!
[IN Perceptions] : Breeze percept in room(1,2): no!
[IN Perceptions] : Glitter percept in room(1,2): no!
[IN Perceptions] : Percepts in room(1,2) at time 1: [yes,no,no,no]!
[IN LOOP] : Perceptions in loop iter 1: [yes,no,no,no]!
Traveled from room(1,2) to room(2,1) at time 1
# ...
[IN Perceptions] : Stench percept in room(2,1): no!
[IN Perceptions] : Breeze percept in room(2,1): yes!
[IN Perceptions] : Glitter percept in room(2,1): no!
[IN Perceptions] : Percepts in room(2,1) at time 3: [no,yes,no,no]!
[IN LOOP] : Perceptions in loop iter 2: [no,yes,no,no]!
# ...
Traveled from room(2,1) to room(1,2) at time 3
# ...
[IN Perceptions] : Stench percept in room(1,2): yes!
[IN Perceptions] : Breeze percept in room(1,2): no!
[IN Perceptions] : Glitter percept in room(1,2): no!
[IN Perceptions] : Percepts in room(1,2) at time 5: [yes,no,no,no]!
[IN LOOP] : Perceptions in loop iter 3: [yes,no,no,no]!
Shot room(1,3) at time 5
You won!
```

### Final states/heuristics

```
3 ?- has_pit(Room, Answer).
Room = room(3, 1),
Answer = yes ;
Room = room(2, 2),
Answer = no ;
Room = room(1, 3),
Answer = no ;
Room = room(1, 1),
Answer = no ;
Room = room(2, 1),
Answer = no ;
Room = room(1, 2),
Answer = no.

4 ?- has_wumpus(Room, Answer). 
Room = room(1, 3),
Answer = yes ;
Room = room(3, 1),
Answer = no ;
Room = room(2, 2),
Answer = no ;
Room = room(1, 1),
Answer = no ;
Room = room(2, 1),
Answer = no ;
Room = room(1, 2),
Answer = no.

5 ?- score(S).
S = 85.

6 ?- visited(Room, _). 
Room = room(1, 2) ;
Room = room(2, 1) ;
Room = room(1, 2) ;
Room = room(1, 1).
```
