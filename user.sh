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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE

VALIDATE $? "rmp setup"

yum install nodejs -y &>>$LOGFILE

VALIDATE $? "installing nodejs"

useradd roboshop &>>$LOGFILE

USER_ROBOSHOP=$(id roboshop)

VALIDATE $? "adding user"

mkdir /app &>>$LOGFILE


VALIDATE $? "creating directory"

curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>$LOGFILE

VALIDATE $? "zip"

cd /app &>>$LOGFILE

VALIDATE $? "change dir"

unzip -o /tmp/user.zip &>>$LOGFILE

VALIDATE $? "unzip"

npm install  &>>$LOGFILE

VALIDATE $? "install npm"

cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service &>>$LOGFILE

VALIDATE $? "copying catalog.service"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "daemon reload"

systemctl enable user &>>$LOGFILE

VALIDATE $? "enabling user"

systemctl start user &>>$LOGFILE

VALIDATE $? "starting user"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? "mongo.repo"

yum install mongodb-org-shell -y &>>$LOGFILE

VALIDATE $? "installing mongo client"

mongo --host mongodb.join-devops.online </app/schema/user.js &>>$LOGFILE

VALIDATE $? "loading the data"

