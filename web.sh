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

yum install nginx -y &>>$LOGFILE

VALIDATE $? "installing nginx"

systemctl enable nginx &>>$LOGFILE

VALIDATE $? "enabling nginx"

systemctl start nginx &>>$LOGFILE

VALIDATE $? "starting nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE

VALIDATE $? "remove the directory"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$LOGFILE

VALIDATE $? "zip"

cd /usr/share/nginx/html &>>$LOGFILE

VALIDATE $? "change directory"

unzip -o /tmp/frontend.zip &>>$LOGFILE

VALIDATE $? "unzip"

cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf  &>>$LOGFILE

VALIDATE $? "copied roboshop.conf"

systemctl restart nginx &>>$LOGFILE

VALIDATE $? "restarting nginx"

