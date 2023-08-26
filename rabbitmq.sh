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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$LOGFILE

VALIDATE $? "install"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$LOGFILE

VALIDATE $? "rabbitmq-server installing"

yum install rabbitmq-server -y &>>$LOGFILE

VALIDATE $? "install rabbitmq"

systemctl enable rabbitmq-server &>>$LOGFILE

VALIDATE $? "enable rabbitmq"

systemctl start rabbitmq-server &>>$LOGFILE

VALIDATE $? "start rabbitmq"

rabbitmqctl add_user roboshop roboshop123 &>>$LOGFILE

VALIDATE $? "add suer"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGFILE

VALIDATE $? "set permissions"