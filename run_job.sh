

module load nixpkgs/16.09 gcc/7.3.0
module load nodejs/14.4.0
module load python/3.7.4
module load gcc rstudio-server


VIRTUAL_ENV=$SCRATCH/venv
GROUP=def-patricia
MEMPERCPU=1024M
CPUSPERTASK=2
NTASKS=1
USERNAME="spinney"

# check if run file exists on destination directory /home/spinney/scratch.
if [ -d "$VIRTUAL_ENV" ]; then
    source $VIRTUAL_ENV/bin/activate
else
    echo "$VIRTUAL_ENV does not exist. Creating init script, this may take a few minutes."
    virtualenv $VIRTUAL_ENV
    source $VIRTUAL_ENV/bin/activate
    pip install jupyter
    echo -e '#!/bin/bash\nunset XDG_RUNTIME_DIR\njupyter notebook --ip $(hostname -f) --no-browser' > $VIRTUAL_ENV/bin/notebook.sh
    chmod u+x $VIRTUAL_ENV/bin/notebook.sh
    pip install jupyterlab jupyter-server-proxy nbserverproxy ipykernel dask jedi==0.17.2 jupyterlmod ipykernel
    jupyter nbextension enable --py jupyterlmod --sys-prefix
    jupyter serverextension enable --py jupyterlmod --sys-prefix
    python -m ipykernel install --user --name cedar --display-name 'Python 3.7.4 Cedar Kernel'
    #echo ""> "$FILE"
    #sbatch "$FILE"
fi

echo "Running the jupyter notebook in interactive node:
ntasks: $NTASKS
cpus-per-task: $CPUSPERTASK
mem-per-cpu: $MEMPERCPU"

cd $SCRATCH
trap ctrl_c INT
salloc --time=0:10:0 --ntasks=$NTASKS --cpus-per-task=$CPUSPERTASK --mem-per-cpu=$MEMPERCPU --account=$GROUP srun $VIRTUAL_ENV/bin/notebook.sh
