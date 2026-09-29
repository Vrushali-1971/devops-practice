# Task 2: Checkout + Run Script

## Goal
Create a GitHub Actions workflow that:
1. Checks out the repo code
2. Makes `scripting/greet.sh` executable
3. Runs `scripting/greet.sh`

## Task steps (what I did)
1. Created `scripting/greet.sh` bash script with:
   - Shebang line
   - Print "Hello from scripting/greet.sh!"
   - Print today's date using `$(date)`
   - Print current directory using `$(pwd)`
   - Print "Files in repo:" and run `ls -la`
2. Made the script executable locally: `chmod +x scripting/greet.sh`
3. Created workflow file `.github/workflows/run-script.yml`
4. Triggered on:
   - `push` to `master`
   - `workflow_dispatch` (manual)
5. Job `run_my_script` runs on `ubuntu-latest` with 3 steps:
   - Checkout code (`uses: actions/checkout@v4`)
   - Make script executable (`run: chmod +x scripting/greet.sh`)
   - Run the script (`run: ./scripting/greet.sh`)
6. Committed and pushed both files
7. Verified success on GitHub Actions tab

## My workflow — run-script.yml

```yaml
name: Run Script Workflow

on:
  push:
    branches: [ master ]
  workflow_dispatch:

jobs:
  run_my_script:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Make script executable
        run: chmod +x scripting/greet.sh

      - name: Run the script
        run: ./scripting/greet.sh
