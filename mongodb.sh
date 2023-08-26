#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/tmp
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$SCRIPT_NAME-$DATE.log
USERID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ];
then 
 echo -e " $R error: please do it with root access $N"
 exit 1 
fi 

VALIDATE(){
 
 if [ $1 -ne 0 ]
 then 
  echo -e  " $R  $2 failure $N"
  exit 1
  else 
   echo -e " $G  $2 success $N"
   fi 
}

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "copied mongo.repo to yum.repos.d"

yum install mongodb-org -y &>> $LOGFILE


VALIDATE $? "installing mongod" 

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "Enabling mongod" 

systemctl start mongod &>> $LOGFILE

VALIDATE $? "starting mongod" 

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "edit the config"

systemctl restart mongod &>> $LOGFILE

VALIDATE $? "restarting mongod"