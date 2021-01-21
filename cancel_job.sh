
USERNAME="spinney"

# get job id
JOBID=$(squeue -u $USERNAME | awk 'NR==2{print $1}')

echo "Trap: CTRL+C received, cancelling job $JOBID"
scancel $JOBID