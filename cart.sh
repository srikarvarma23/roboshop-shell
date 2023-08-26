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



VALIDATE $? "adding user"

mkdir /app &>>$LOGFILE



VALIDATE $? "creating directory"

curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip &>>$LOGFILE

VALIDATE $? "zip"

cd /app &>>$LOGFILE

VALIDATE $? "change dir"

unzip -o /tmp/cart.zip &>>$LOGFILE

VALIDATE $? "unzip"

npm install  &>>$LOGFILE

VALIDATE $? "install npm"

cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service &>>$LOGFILE

VALIDATE $? "copying catalog.service"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "daemon reload"

systemctl enable cart &>>$LOGFILE

VALIDATE $? "enabling cart"

systemctl start cart &>>$LOGFILE

VALIDATE $? "starting cart"




