# wumpus-world

Todos:
- [ ] finish rules in main.pl
  - [ ] test fall
  - [ ] test climb
  - [ ] test eaten
  - [ ] test perceptors
  - [ ] think of when the player dies after a fall (not having gold)
- [ ] hard part: design heuristics (where to move next based on current KB?)
  - [ ] score (risk + cost) for each applicable cell
  - [ ] score only neighbors or all explorable cells?
  - [ ] define explorable rooms if necessary
  - [ ] define heuristic for each sensor: given each sensor, what to do (4 rules)
  - [ ] if we score all explorable cells, we need to think about the path to be taken (it should be safe and ideally efficient) -- parent cells?
- [x] build a couple more worlds
- [ ] test, debug
- [ ] make sure the final work isn't too similar to our refs (if we have time and khater to do that hahah)
- [ ] screenshots of queries, code comments

Useful refs: https://www.metalevel.at/wumpusworld/wumpus.pl, https://github.com/hilios/wumpus-prolog.
