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

yum install python36 gcc python3-devel -y &>>$LOGFILE

VALIDATE $? "install python"

useradd roboshop &>>$LOGFILE

VALIDATE $? "add user"

mkdir /app &>>$LOGFILE

VALIDATE $? "create dir"


curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip &>>$LOGFILE

VALIDATE $? "zip"


cd /app &>>$LOGFILE

VALIDATE $? "change dir"

unzip -o /tmp/payment.zip &>>$LOGFILE

VALIDATE $? "unzip"


pip3.6 install -r requirements.txt &>>$LOGFILE

VALIDATE $? "install python dependencies"


cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service &>>$LOGFILE

VALIDATE $? "copying payment"


 systemctl daemon-reload &>>$LOGFILE

 VALIDATE $? "reload"


 systemctl enable payment &>>$LOGFILE

 VALIDATE $? "enabling payment"


 systemctl start payment &>>$LOGFILE

 VALIDATE $? "starting payment"

