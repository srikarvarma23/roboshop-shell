#!/bin/bash

NAMES=("mongodb" "redis" "rabbitmq" "mysql" "catalogue" "user" "cart" "shipping" "payments" "dispatch")
INSTANCE_TYPE=""
IMAGE_ID=ami-03265a0778a880afb
SECURITY_GROUP=sg-00e5e92a347f79a10
DOMAIN_NAME=join-devops.online


for i in "${NAMES[@]}"
do 
 if [[ $i == "mongodb" || $i == "mysql" ]]
 then 
  INSTANCE_TYPE="t3.medium"
  else
  INSTANCE_TYPE="t2.micro"
  fi
  echo "creating instance: $i"
  IP_ADDRESS=$(aws ec2 run-instances --image-id $IMAGE_ID --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')
  echo "created instance: $IP_ADDRESS"


aws route53 change-resource-record-sets --hosted-zone-id Z011074929JEGW8SOZO4S --change-batch '
{
                 
                 "Changes": [{
                             "Action": "CREATE",
                            "ResourceRecordSet": {
                                "Name": "'$i.$DOMAIN_NAME'",
                                    "Type": "A",
                                     "TTL": 300,
                                  "ResourceRecords": [{"Value": "'$IP_ADDRESS'"}]
                            }}]
                            }
                            '
                            
done