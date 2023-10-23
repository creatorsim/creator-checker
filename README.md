<html>
 <h1 align="center">CREATOR: <br>didaCtic and geneRic assEmbly progrAmming simulaTOR</h1>
 <h2 align="center"> Checker </h2>
</html>

## Files and directories:
* container_start.sh: script that generates the container and executes it.
* ec_p1_corrector: directory where the correction is made.
  * solution: directory which contains practice solutions.
  * test: directory where the tests to be carried out are defined, one directory per exercise and one file per test case.
  * unzip_all.sh: unzips all deliveries from a reduced-group, receives a parameter which is the group number, for example ```./unzip_all 81```
  * checker.sh: script that checks all the practices of a small group, this script gets a parameter that is the number of the group ```./checker 81```
  
## Steps to correct all deliveries of a group
1. Clone this repository:
   ```console
   git clone https://github.com/creatorsim/checker.git
   ```
2. Build container:
   ```console
   ./container_start.sh
   ```
3. Update the solutions and tests in the ec_p1_corrector directory
4. Make reduced-group directory and include all deliveries (\*.zip) in the directory.
5. Execute for each reduced-group directory:
   ```console
   ./unzip_all.sh <reduced group>
   ```
6. Execute for each group the corresponding script, checker_esp.sh (Spanish) or checker_eng.sh (English). Those scripts generate a CSV file with the results of the assigment checks.
   ```console
   ./checker_esp.sh <reduced group>
   ```
   ```console
   ./checker_eng.sh <reduced group>
   ```

