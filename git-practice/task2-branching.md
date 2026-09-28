# Task 2: Branching

## Commands
- git checkout -b feature/name      # create + switch
- git checkout master               # switch back
- git merge feature/name            # merge
- git branch -d feature/name        # delete merged branch
- git branch -D feature/name        # force delete
- git log --oneline --graph         # visualize

## Merge types
- Fast-forward: no merge commit (pointer moves forward)
- 3-way: creates merge commit (shows |\ in graph)
- Force merge commit: git merge --no-ff

## Conflict markers
<<<<<<< HEAD          ← current branch
=======               ← divider
>>>>>>> branch-name   ← incoming branch

## Resolve conflict
1. Edit file
2. Remove markers, keep desired content
3. git add <file>
4. git commit -m "Resolve conflict"

## Interview Q
Q: What causes conflict?

A: Same line modified in both branches

Q: FF vs 3-way merge?

A: FF = no commit, 3-way = merge commit

## Debug
Changes disappear when switching branches → commit or stash first
