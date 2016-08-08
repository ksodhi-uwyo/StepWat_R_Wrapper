Following are the steps to run the wrapper on MT Moran, and get the results in a SQLite Database:
Note: The method to run a shell script, is present as a comment in the respective script.
1. Extract/Copy the contents of the tar file, in a folder.
2. Make sure the folder also has the database, for input.
3. Set line 27 (location of the input database) in the STEPWAT.Wrapper.MAIN_V3.R script, located in StepWat_R_Wrapper_Parallel.
4. Add site ids, you wish to run the wrapper on, to the siteid variable (third line from top) in the generate_stepwat_sites.sh script. Site ids 1-10 are already present, to exemplify.
5. Run the generate_stepwat_sites.sh script.
6. Edit jobname, accountname and the location of results.txt (last line) in the sample.sh script, located in StepWat_R_Wrapper_Parallel.
7. Run the callsbatch.sh script.
8. Once all the computations are carried out,edit the makedatabse.R script to add the location of the source directory, number of sites and location of the output database.
9. Edit jobname and accountname in the makedatabase.sh script.
10. Run the makedatabase.sh script to compile the results into a SQLite database, using sbatch. Example: In source directory, use the terminal to type sbatch makedatabase.sh
11. Once the makedatabase.sh is executed, copy the database to your personal system using globus/scp/sftp.
