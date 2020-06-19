#!/bin/bash
#SBATCH --job-name=ParameterRun1
#SBATCH --partition=popgenom
#SBATCH --output=/data/cornejo/projects/e.jimenezschwarzkop/LDModel/1.scripts/1.log/ParameterRun1.out
#SBATCH --error=/data/cornejo/projects/e.jimenezschwarzkop/LDModel/1.scripts/1.log/ParameterRun1.err
#SBATCH --time=14-00:00:00
#SBATCH --nodes=1
#SBATCH --workdir="/data/cornejo/projects/e.jimenezschwarzkop/LDModel"

module load r/3.6.3

Rscript 1.scripts/ParameterRun1.R
