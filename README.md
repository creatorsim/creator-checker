<html>
 <h1 align="center">CREATOR (didaCtic and geneRic assEmbly progrAmming simulaTOR) Checker</h1><br>
</html>

## 1. Main files and directories:
* **container_start.sh**: script that generates the container and executes it.
* **ec_p1_corrector**: directory where the correction is made.
  * **solution**: directory which contains the solutions.
  * **test**: directory where the tests to be carried out are defined, one directory per exercise and one file per test case.
  * **unzip_all.sh**: unzips all submissions from a reduced-group, receives a parameter which is the group number, for example: ```./unzip_all 81```
  * **checker.sh**: script that checks all the submissions of a reduced-group, this script gets a parameter that is the group number, for example: ```./checker 81```
  
## 2. Steps to check all submissions from a reduced-group
1. Clone this repository:
   ```console
   git clone https://github.com/creatorsim/checker.git
   ```
2. Build the container:
   ```console
   ./container_start.sh
   ```
3. Update the *solutions* and *tests* in the *ec_p1_corrector directory*.
4. Make reduced-group directory and include all deliveries (\*.zip) in the directory.
5. Execute for each reduced-group directory:
   ```console
   ./unzip_all.sh <reduced group>
   ```
6. Execute for each group the corresponding script, checker_esp.sh (Spanish) or checker_eng.sh (English). <br/>
   Those scripts generate a CSV file with the results of the assigment checks.
   ```console
   ./checker_esp.sh <reduced group>
   ```
   ```console
   ./checker_eng.sh <reduced group>
   ```

