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

yum module disable mysql -y &>>$LOGFILE

VALIDATE $? "disable mysql version"

cp  /home/centos/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo &>>$LOGFILE

VALIDATE $? "copied mysql.repo"

yum install mysql-community-server -y &>>$LOGFILE

VALIDATE $? "install mysql community"

systemctl enable mysqld &>>$LOGFILE

VALIDATE $? "enabling mysql"

systemctl start mysqld &>>$LOGFILE

VALIDATE $? "starting mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOGFILE

VALIDATE $? "user & pass"

mysql -uroot -pRoboShop@1 &>>$LOGFILE

VALIDATE $? "hello"

