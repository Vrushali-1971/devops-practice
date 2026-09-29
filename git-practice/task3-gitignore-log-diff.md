# Task-3 - .gitignore + Log + diff

## 1. Create files to ignore
```
echo "SECRET=abc123" > .env
echo "debug log" > app.log
mkdir -p node_modules && touch node_modules/pkg.js
```
**What i did:**  Practiced adding secrets and log msg in .env and app.log file with echo command , created node_module directory and pkg.js file inside it.

## 2. Create .gitignore

```
cat > .gitignore << 'EOF'
.env
*.log
node_modules/
EOF
```

**What i did:** Added files in .gitignore to prevent them to get committed and tracked by git.

## 3. Check status (ignored files should NOT appear)
```
git status
```
**what it does:** -  Displays the current state of the Git repository. 

**Output:** Ignored files did not appear in git status

## 4. Commit .gitignore
```
git add .gitignore
git commit -m "Add .gitignore"
```
**What i did:** Staged `.gitignore` for the next commit and git commit saved the staged snapshot from the staging area into the local repository history.

## 5. Practice diffs
```
echo "new line" >> task1-git-basics.md
git diff                     # unstaged
git add task1-git-basics.md
git diff --staged            # staged
git commit -m "Update task1 notes"
```

**Terminal snapshot:**
```
diff --git a/.gitignore b/.gitignore
index 6be9b94..f2c4911 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1,8 +1,6 @@
 # Logs
 *.log
 
-# Temp files
-*.txt
```

```
Reading diff output:

--- = old version

+++ = new version

+new line = added line

-old line = removed line
```

**What i did:** Appended text in task1-git-basics.md file without rewriting it, checked git diff before adding and git diff -staged after comitting the .md file. 

`git diff` - compares working directory with staging area.

`git diff --staged` - Compares staging area with repository(last commit)

## 6. View log
```
git log --oneline -5
git log --stat -3
```

**What it does:**

`git log --oneline` -  command is to provide a highly condensed, single-line overview of your Git commit history

`git log --stat` -  command displays a chronological history of commits along with a summary of file-level changes for each commit
