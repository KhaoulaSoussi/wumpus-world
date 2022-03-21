### World C

```
[IN Perceptions] : Stench percept in room(1,1): no!
[IN Perceptions] : Breeze percept in room(1,1): no!
[IN Perceptions] : Glitter percept in room(1,1): no!
[IN Perceptions] : Percepts in room(1,1) at time 0: [no,no,no,no]!
[IN LOOP] : Perceptions in loop iter 0: [no,no,no,no]!
Traveled from room(1,1) to room(1,2) at time 0
[IN Perceptions] : Stench percept in room(1,2): no!
[IN Perceptions] : Breeze percept in room(1,2): yes!
[IN Perceptions] : Glitter percept in room(1,2): no!
[IN Perceptions] : Percepts in room(1,2) at time 1: [no,yes,no,no]!
[IN LOOP] : Perceptions in loop iter 1: [no,yes,no,no]!
Traveled from room(1,2) to room(2,1) at time 1
[IN Perceptions] : Stench percept in room(2,1): no!
[IN Perceptions] : Breeze percept in room(2,1): yes!
[IN Perceptions] : Glitter percept in room(2,1): no!
[IN Perceptions] : Percepts in room(2,1) at time 3: [no,yes,no,no]!
[IN LOOP] : Perceptions in loop iter 2: [no,yes,no,no]!
Traveled from room(2,1) to room(1,2) at time 3
[IN Perceptions] : Stench percept in room(1,2): no!
[IN Perceptions] : Breeze percept in room(1,2): yes!
[IN Perceptions] : Glitter percept in room(1,2): no!
[IN Perceptions] : Percepts in room(1,2) at time 5: [no,yes,no,no]!
[IN LOOP] : Perceptions in loop iter 3: [no,yes,no,no]!
Traveled from room(1,2) to room(2,1) at time 5
[IN Perceptions] : Stench percept in room(2,1): no!
[IN Perceptions] : Breeze percept in room(2,1): yes!
[IN Perceptions] : Glitter percept in room(2,1): no!
[IN Perceptions] : Percepts in room(2,1) at time 7: [no,yes,no,no]!
[IN LOOP] : Perceptions in loop iter 4: [no,yes,no,no]!
Traveled from room(2,1) to room(1,2) at time 7
[IN Perceptions] : Stench percept in room(1,2): no!
[IN Perceptions] : Breeze percept in room(1,2): yes!
[IN Perceptions] : Glitter percept in room(1,2): no!
[IN Perceptions] : Percepts in room(1,2) at time 9: [no,yes,no,no]!
[IN LOOP] : Perceptions in loop iter 5: [no,yes,no,no]!
Traveled from room(1,2) to room(2,1) at time 9
[IN Perceptions] : Stench percept in room(2,1): no!
[IN Perceptions] : Breeze percept in room(2,1): yes!
[IN Perceptions] : Glitter percept in room(2,1): no!
[IN Perceptions] : Percepts in room(2,1) at time 11: [no,yes,no,no]!
[IN LOOP] : Perceptions in loop iter 6: [no,yes,no,no]!
Traveled from room(2,1) to room(1,2) at time 11
[IN Perceptions] : Stench percept in room(1,2): no!
[IN Perceptions] : Breeze percept in room(1,2): yes!
[IN Perceptions] : Glitter percept in room(1,2): no!
[IN Perceptions] : Percepts in room(1,2) at time 13: [no,yes,no,no]!
[IN LOOP] : Perceptions in loop iter 7: [no,yes,no,no]!
Traveled from room(1,2) to room(3,3) at time 13
[IN Perceptions] : Stench percept in room(3,3): yes!
[IN Perceptions] : Breeze percept in room(3,3): yes!
[IN Perceptions] : Glitter percept in room(3,3): yes!
[IN Perceptions] : Percepts in room(3,3) at time 16: [yes,yes,yes,no]!
[IN LOOP] : Perceptions in loop iter 8: [yes,yes,yes,no]!
Grabbed gold from room(3,3) at time 16
Traveled from room(3,3) to room(1,2) at time 16
[IN Perceptions] : Stench percept in room(1,2): no!
[IN Perceptions] : Breeze percept in room(1,2): yes!
[IN Perceptions] : Glitter percept in room(1,2): no!
[IN Perceptions] : Percepts in room(1,2) at time 19: [no,yes,no,no]!
[IN LOOP] : Perceptions in loop iter 9: [no,yes,no,no]!
Traveled from room(1,2) to room(3,3) at time 19
[IN Perceptions] : Stench percept in room(3,3): yes!
[IN Perceptions] : Breeze percept in room(3,3): yes!
[IN Perceptions] : Glitter percept in room(3,3): no!
[IN Perceptions] : Percepts in room(3,3) at time 22: [yes,yes,no,no]!
[IN LOOP] : Perceptions in loop iter 10: [yes,yes,no,no]!
Shot room(2,3) at time 22
You won!
true.
```

### Final states

```
16 ?- has_pit(Room, Answer).
Room = room(3, 1),
Answer = yes ;
Room = room(2, 2),
Answer = yes ;
Room = room(1, 3),
Answer = yes ;
Room = room(2, 3),
Answer = maybe ;
Room = room(2, 1),
Answer = no ;
Room = room(1, 2),
Answer = no ;
Room = room(1, 1),
Answer = no.

17 ?- has_wumpus(Room, Answer). 
Room = room(4, 3),
Answer = yes ;
Room = room(3, 4),
Answer = yes ;
Room = room(3, 2),
Answer = yes ;
Room = room(2, 3),
Answer = yes ;
Room = room(3, 1),
Answer = no ;
Room = room(2, 2),
Answer = no ;
Room = room(1, 1),
Answer = no ;
Room = room(1, 3),
Answer = no ;
Room = room(2, 1),
Answer = no ;
Room = room(1, 2),
Answer = no.

18 ?- score(S).
S = 167.

19 ?- visited(Room, _).
Room = room(3, 3) ;
Room = room(1, 2) ;
Room = room(3, 3) ;
Room = room(1, 2) ;
Room = room(2, 1) ;
Room = room(1, 2) ;
Room = room(2, 1) ;
Room = room(1, 2) ;
Room = room(2, 1) ;
Room = room(1, 2) ;
Room = room(1, 1).
```
