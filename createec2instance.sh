#!/bin/bash

NAMES=("mongodb" "redis" "rabbitmq" "mysql" "catalogue" "user" "cart" "shipping" "payments" "dispatch")

for i in "${NAMES[@]}"
do 
  echo "NAMES: $i"
done