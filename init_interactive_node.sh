#!/usr/bin/env bash


USERNAME="spinney"

# this is a trap for ctrl + c
trap ctrl_c INT

function ctrl_c()
{ echo "Cancelling Job."
  cat cancel_job_cedar.sh | ssh CEDAR
  exit
}


cat create_run_script.sh | ssh CEDAR

# SSH Tunneling
# keep this running as long as you want to connect
ssh -L 8888:cdr767.int.cedar.computecanada.ca:8888 $USERNAME@cedar.computecanada.ca



#echo "Go to browser to view notebook: http://localhost:8888/?token=$TOKEN"