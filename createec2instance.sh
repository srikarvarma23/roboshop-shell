#!/bin/bash

NAMES=("mongodb" "redis" "rabbitmq" "mysql" "catalogue" "user" "cart" "shipping" "payments" "dispatch")
INSTANCE_TYPE=""
IMAGE_ID=ami-03265a0778a880afb
SECURITY_GROUP=sg-00e5e92a347f79a10


for i in "${NAMES[@]}"
do 
 if [[ $i == "mongodb" || $i == "mysql" ]]
 then 
  INSTANCE_TYPE="t3.medium"
  else
  INSTANCE_TYPE="t2.micro"
  fi
  echo "creating instance: $i"
  IP_ADDRESS=$(aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type t2.micro --security-group-ids sg-00e5e92a347f79a10  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')
  echo "created instance: $IP_ADDRESS"

done