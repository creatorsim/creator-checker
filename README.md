<html>
 <h1 align="center">CREATOR: <br>didaCtic and geneRic assEmbly progrAmming simulaTOR</h1>
 <h2 align="center"> Checker </h2>
</html>

## Files and directories:
* container_start.sh: script that generates the container and executes it.
* ec_p1_corrector: directory where the correction is made.
  * 90: example directory with two deliverables.
  * solution: directory which contains practice solutions.
  * test: directory where the tests to be carried out are defined, one directory per exercise and one file per test case.
  * checker.sh: script that checks all the practices of a small group, this script gets a parameter that is the number of the group ./checker <group>
  * mk_solution.sh: script that generates the final states of all tests with the correct solutions ./mk_solution
  * unzip_all.sh: unzips all deliveries from a small group, receives a parameter which is the group number ./unzip_all <group>
  
## Steps to correct all deliveries of a group
1. Clone this repository git clone https://github.com/creatorsim/checker.git
2. Execute ./container_start.sh
3. Include the solutions, tests and deliveries in the corresponding directories
4. Execute for each group unzip_all.sh <group>
5. Execute ./mk_solution.sh to generate the final state
6. Execute for each group ./checker.sh <group> This script generates a csv file with the results of the correction
