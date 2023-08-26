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

USER_CHECK=$(id roboshop)
if [ $? -ne 0 ];
then
    echo -e "$Y...USER roboshop is not present so creating now..$N"
    useradd roboshop &>>$LOGFILE
else
    echo -e "$G...USER roboshop is already present so skipping now.$N"
 fi


APP_DIR=$(cd /app)
if [ $? -ne 0 ];
then
    echo -e " $Y /app directory not there so creating now $N"
    mkdir /app &>>$LOGFILE  
else
    echo -e "$G /app directory already present so skipping now $N"
    fi
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE

VALIDATE $? "rmp setup"

yum install nodejs -y &>>$LOGFILE

VALIDATE $? "installing nodejs"

#useradd roboshop &>>$LOGFILE



#VALIDATE $? "adding user"

#mkdir /app &>>$LOGFILE


#VALIDATE $? "creating directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>$LOGFILE

VALIDATE $? "zip"

cd /app &>>$LOGFILE

VALIDATE $? "change dir"

unzip -o /tmp/catalogue.zip &>>$LOGFILE

VALIDATE $? "unzip"

npm install  &>>$LOGFILE

VALIDATE $? "install npm"

cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>>$LOGFILE

VALIDATE $? "copying catalog.service"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "daemon reload"

systemctl enable catalogue &>>$LOGFILE

VALIDATE $? "enabling catalogue"

systemctl start catalogue &>>$LOGFILE

VALIDATE $? "starting catalogue"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? "mongo.repo"

yum install mongodb-org-shell -y &>>$LOGFILE

VALIDATE $? "installing mongo client"

mongo --host mongodb.join-devops.online </app/schema/catalogue.js &>>$LOGFILE

VALIDATE $? "loading the data"

