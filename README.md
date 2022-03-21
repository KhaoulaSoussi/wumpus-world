# wumpus-world

So far, we always succeed in worlds A and worlds B thanks to our assertions of has_wumpus(_, yes). The outcomes and final states of world A and world B are deterministic.

The outcome of world C seems to be depend on the random move made some time after timestamp 10. We get stuck in rooms (1, 1), (1, 2), and (2, 1) without this random move. Depending on this move, we could either win, or lose by falling, getting eaten, or shooting in the wrong place.

To achieve a better outcome more often in world C, we can work towards moving more freely to different places, by ensuring we don't assume pits exist where they aren't.

Thus, the heuristics could be improved as follows:
- Reduce the places where has_pit(_, yes)
- [Inconsiquential but indicates good heuristics] Make sure to grab the gold when there is glitter. In principle, this is implemented, but in one run, it did not seem to work

Moreover, the code itself could be improved as follows:
- Investigate why the loop requires typing ; in swipl to move on to the next iteration and try to fix that
- Make use of the scream perception instead of the dead() check in the loop. Strangely, Scream is always no, even when dead() is true.

Useful refs: https://www.metalevel.at/wumpusworld/wumpus.pl, https://github.com/hilios/wumpus-prolog.
