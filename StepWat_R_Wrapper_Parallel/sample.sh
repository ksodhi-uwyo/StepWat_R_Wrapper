#!/bin/bash

#Assign Job Name
#SBATCH --job-name=stepwatwrappertwo

#Assign Account Name
#SBATCH --account=arccinterns

#Set Max Wall Time
#days-hours:minutes:seconds
#SBATCH --time=48:00:00

#Specify Resources Needed
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=7

#Load Required Modules

module load intel/16.3
module load R/3.2.5

srun Rscript notassigned
echo "Site noid done!" >> /project/sagebrush-steppehab/ksodhi/jobs.txt

