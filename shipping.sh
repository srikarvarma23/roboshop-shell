#!/bin/bash
LOGSDIR=/tmp

DATE=$(date +%F)
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$SCRIPT_NAME-$DATE.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

USERID=$(id -u)

if [ $USERID -ne 0 ]
then 
 echo -e " $R error: please do it with root access $N"
     exit 1 
fi 

VALIDATE(){
 
 if [ $1 -ne 0 ]
 then 
  echo -e  " $R  $2 ..... failure $N"
  exit 1
  else 
   echo -e " $G  $2 ..... success $N"
   fi 
}

yum install maven -y

useradd roboshop

mkdir /app

curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip

cd /app

unzip -o /tmp/shipping.zip

mvn clean package

mv target/shipping-1.0.jar shipping.jar

systemctl daemon-reload

systemctl enable shipping 

systemctl start shipping

yum install mysql -y 

mysql -h mysql.join-devops.online -uroot -pRoboShop@1 < /app/schema/shipping.sql 

systemctl restart shipping

