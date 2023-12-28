#!/bin/bash
IP_ADDRESS="10.2.2.1"
EC2_INSTANCE=$(ec2-run-instances --instance-type
t2.micro ami-0edab43b6fa892279)
INSTANCE=$(echo ${EC2_INSTANCE} | sed 's/*INSTANCE //'
| sed 's/ .*//')
# Wait for instance to be ready
while ! ec2-describe-instances $INSTANCE | grep -q
"running"
do
echo Waiting for $INSTANCE is to be ready...
done
# Check if instance is not provisioned and exit
if [ ! $(ec2-describe-instances $INSTANCE | grep -q
"running") ]; then
echo Instance $INSTANCE is stopped.
exit
fi
ec2-associate-address $IP_ADDRESS -i $INSTANCE
echo Instance $INSTANCE was created successfully