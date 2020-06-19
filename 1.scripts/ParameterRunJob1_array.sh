#!/bin/bash
#SBATCH --job-name=ParameterRun1_array
#SBATCH --partition=popgenom,kamiak,cas,cahnrs
#SBATCH --output=/data/cornejo/projects/e.jimenezschwarzkop/LDModel/1.scripts/1.log/ParameterRun1_array.out
#SBATCH --error=/data/cornejo/projects/e.jimenezschwarzkop/LDModel/1.scripts/1.log/ParameterRun1_array.err
#SBATCH --time=7-00:00:00
#SBATCH --nodes=1
#SBATCH --workdir="/data/cornejo/projects/e.jimenezschwarzkop/LDModel"
#SBATCH --array=1-13440:1# Number of jobs, in steps of 1

i=${SLURM_ARRAY_TASK_ID}

module load r/3.6.3

Rscript --vanilla 1.scripts/ParameterRun1_array.R 3.aux/Parameters_run1.txt ${i}