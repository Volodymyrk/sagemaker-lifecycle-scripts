#!/bin/bash
sudo -u ec2-user -i <<'EOF'

ENV=pytorch_p36
set -e

export PATH=/home/ec2-user/anaconda3/bin/:$PATH

/bin/bash  -c "source activate $ENV && 
pip install pyexasol[pandas,rapidjson]>=0.5.1 && \
pip install -i https://bi-reader:XXYYYZZZ@wooga.jfrog.io/wooga/api/pypi/pybi/simple wgdatautils --no-dependencies"

ENVVARSSH=/home/ec2-user/anaconda3/envs/$ENV/etc/conda/activate.d/env_vars.sh
touch $ENVVARSSH 
echo "export EXASOL_USR=USR" >> $ENVVARSSH
echo "export EXASOL_PW=PSW" >> $ENVVARSSH
echo "export EXASOL_DSN=IP.." >> $ENVVARSSH

mkdir -p /home/ec2-user/SageMaker/efs

sudo mount -t nfs \
    -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport \
    fs-c2196c0a.efs.eu-west-1.amazonaws.com:/persistentvolumes/efs-notebooks-pvc-aaaa-bbbb-12345 \
    /home/ec2-user/SageMaker/efs
    
sudo chmod -R 0777 /home/ec2-user/SageMaker/efs

EOF
