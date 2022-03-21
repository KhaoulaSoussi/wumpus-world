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
Traveled from room(2,1) to room(2,3) at time 11
Game Over... You were eaten by the wumpus in room(2,3) at time 13!
true.
```

### Final states

```
6 ?- has_pit(Room, Answer).
Room = room(2, 2),
Answer = yes ;
Room = room(1, 3),
Answer = yes ;
Room = room(3, 1),
Answer = yes ;
Room = room(2, 1),
Answer = no ;
Room = room(1, 2),
Answer = no ;
Room = room(1, 1),
Answer = no.

7 ?- has_wumpus(Room, Answer). 
Room = room(2, 2),
Answer = no ;
Room = room(1, 3),
Answer = no ;
Room = room(1, 1),
Answer = no ;
Room = room(3, 1),
Answer = no ;
Room = room(2, 1),
Answer = no ;
Room = room(1, 2),
Answer = no.

8 ?- visited(R, _).
R = room(2, 3) ;
R = room(2, 1) ;
R = room(1, 2) ;
R = room(2, 1) ;
R = room(1, 2) ;
R = room(2, 1) ;
R = room(1, 2) ;
R = room(1, 1).

9 ?- score(S).
S = -913.
```
