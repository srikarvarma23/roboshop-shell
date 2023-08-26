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

yum install maven -y &>>$LOGFILE

VALIDATE $? "installing maven"

useradd roboshop &>>$LOGFILE

VALIDATE $? "user added"

mkdir /app &>>$LOGFILE

VALIDATE $? "created directory"

curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip &>>$LOGFILE

VALIDATE $? "installing zip"

cd /app &>>$LOGFILE

VALIDATE $? "change dir"

unzip -o /tmp/shipping.zip &>>$LOGFILE

VALIDATE $? "unzip dir"

mvn clean package &>>$LOGFILE

VALIDATE $? "clean package"

mv target/shipping-1.0.jar shipping.jar &>>$LOGFILE

VALIDATE $? "moving jar file"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "reload"

systemctl enable shipping &>>$LOGFILE

VALIDATE $? "enabling shipping"

systemctl start shipping &>>$LOGFILE

VALIDATE $? "start shipping"

yum install mysql -y  &>>$LOGFILE

VALIDATE $? "installing mysql"

mysql -h mysql.join-devops.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>$LOGFILE

VALIDATE $? "root pswd"

systemctl restart shipping &>>$LOGFILE

VALIDATE $? "restart shipping"

