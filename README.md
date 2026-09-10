<h1 align="center">CREATOR Checker</h1>

## 1. Main Files and Directories

* 📄 `creator_checker.sh` – Main execution script.
* 🗂️ `docker/` – Contains Docker-related configuration files.
* 🗂️ `submissions/` – Student submissions organized by group.
* 🗂️ `tests/` – Test programs and reference solutions.
* 🗂️ `results/` – Evaluation results and grades.
* 🗂️ `scripts/` – Helper correction scripts:
  * 📄 `s10_unzip.sh` – Unzips group submissions.
  * 📄 `s20_checker.sh` – Executes tests for a group.
 


## 2. Steps to check all submissions from a group

1. Clone this repository:
   ```console
   git clone https://github.com/creatorsim/creator-checker.git
   ```
   
2. Build the container or pull the container from Docker Hub:

   * Build the container:
   ```console
   ./creator_checker.sh build
   ```

   * Pull the container:
   ```console
   ./creator_checker.sh pull
   ```
   
4. Start the container:
   ```console
   ./creator_checker.sh start
   ```
      
3. Replace the example test files in the *tests* directory with the correction files.
   
4. Replace the example submissions in the *submission* directory with the student submissions (\*.zip).

5. Unzip all group submissions:
   ```console
   ./scripts/./scripts/s10_unzip.sh <group>
   ```

6. Check all group submissions. This script generates a CSV file with the assignment-check results.
   ```console
   ./scripts/s20_checker.sh <group>
   ```

7. Stop the container:
   ```console
   ./creator_checker.sh stop
   ```
