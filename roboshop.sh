#!/bin/bash
AMI=ami-03265a0778a880afb
SG_ID=sg-0c40ab29368c1d034

INSTANCES=('mongodb" "catalogue" "user")

for  i in "${INSTANCES[@]}"
do
   if [ $i == "mongodb" ]
     then 
        INSTANCE_TYPE="t3.small"
     else
        INSTANCE_TYPE="t2.micro"
    fi
aws ec2 run-instances --image-id $AMI --count 1 --instance-type $INSTANCE_TYPE --security-group-ids $SG_ID
 done