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

yum install golang -y &>>$LOGFILE

VALIDATE $? "install golang"

useradd roboshop &>>$LOGFILE

VALIDATE $? "added user"

mkdir /app &>>$LOGFILE

VALIDATE $? "created dir"

curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip &>>$LOGFILE

VALIDATE $? "zip"

cd /app &>>$LOGFILE

VALIDATE $? "change dir"

unzip -o /tmp/dispatch.zip &>>$LOGFILE

VALIDATE $? "unzip"

go mod init dispatch &>>$LOGFILE

VALIDATE $? "init dispatch"

go get &>>$LOGFILE

VALIDATE $? "get the package"

go build &>>$LOGFILE

VALIDATE $? "build the package"

cp /home/centos/roboshop-shell/dispatch.service /etc/systemd/system/dispatch.service &>>$LOGFILE

VALIDATE $? "service"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "reload"

systemctl enable dispatch  &>>$LOGFILE

VALIDATE $? "enabling dispatch"

systemctl start dispatch &>>$LOGFILE

VALIDATE $? "starting dispatch"
