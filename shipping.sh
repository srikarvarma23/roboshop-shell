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

USER_CHECK=$(id roboshop)
if [ $? -ne 0 ];
then
    echo -e "$Y...USER roboshop is not present so creating now..$N"
    useradd roboshop &>>$LOGFILE
else
    echo -e "$G...USER roboshop is already present so skipping now.$N"
 fi

VALIDATE $? "user added"

mkdir /app &>>$LOGFILE

APP_DIR=$(cd /app)
if [ $? -ne 0 ];
then
    echo -e " $Y /app directory not there so creating now $N"
    mkdir /app &>>$LOGFILE  
else
    echo -e "$G /app directory already present so skipping now $N"
    fi

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

 cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service &>>$LOGFILE

 VALIDATE $? "copying shipping serivce"

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

