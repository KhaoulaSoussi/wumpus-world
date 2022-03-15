# wumpus-world

Todos:
- [ ] finish rules in main.pl
  - [ ] test fall
  - [ ] test climb
  - [ ] test eaten
  - [ ] test perceptors
  - [ ] implement when the player dies after a fall (not having gold)
  - [x] re-check climb/fall/has_gold rules (correctness, remove redundancy)
- [ ] hard part: design heuristics (where to move next based on current KB?)
  - [x] score (risk + cost) for each applicable cell
  - [x] define explorable rooms if necessary
  - [x] define heuristic for each sensor: given each sensor, what to do (4 rules)
  - [x] if we score all explorable cells, we need to think about the path to be taken (it should be safe and ideally efficient) -- parent cells?
  - [ ] come up with more rules general enough to ensure wumpus-yes or pit-yes
  - [ ] make a few passes over all heuristics, ensuring consistency, correctness
- [x] build a couple more worlds
- [ ] answer the questions or address the ideas we left for ourselves in the code comments
- [ ] trace a couple of worlds through the code to make everything is in place
- [ ] test, debug
- [ ] make sure the final work isn't too similar to our refs (if we have time and khater to do that hahah)
- [ ] screenshots of runs, code comments

Useful refs: https://www.metalevel.at/wumpusworld/wumpus.pl, https://github.com/hilios/wumpus-prolog.
