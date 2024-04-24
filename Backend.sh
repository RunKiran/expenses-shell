#!/bin/bash

USERID=$(id -u)
TIME_STAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
echo "Please enter DB password:"
read  mysql_root_password

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]
then
    echo "you need root access to install packages"
    exit 1
else
    echo "you are super user"    
fi

VALIDATE(){
    if [ $1 -ne 0 ]
    then    
        echo -e "$2..$R failed $N"
        exit 1
    else
        echo -e "$2..$G Success $N"
          
    fi      
}


dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "disabled  modules"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "enaabled  module20"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "installation of Nodejs"

id expense &>>$LOGFILE
if [ $? -ne 0 ]
then
    useradd expense &>>$LOGFILE
    VALIDATE $? "Creating expense user"
else
    echo -e "Expense user already created...$Y SKIPPING $N"

fi

mkdir -p /app &>>$LOGFILE
VALIDATE $? "creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
VALIDATE $? "downloading backend code"

cd /app 
rm -rf /app/*
unzip /tmp/backend.zip &>>$LOGFILE
VALIDATE $? "extracting backend code"
cd /app 
npm install &>>$LOGFILE

#coping backend file 
cp /home/ec2-user/expenses-shell/backend.service /etc/systemd/system/backend.service &>>$LOGFILE

VALIDATE $? "installation of nodejs dependencies"
systemctl daemon-reload

VALIDATE $? "deamon-reloaded"
systemctl enable backend.service
VALIDATE $? "enabled backend"
systemctl start backend.service
VALIDATE $? "started backend"

# we need to install mysql client
dnf install mysql -y &>>$LOGFILE
VALIDATE $? "installation of mysql-client"

#Load Schema
mysql -h 172.31.84.211 -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE

#Restart the service &>>$LOGFILE
systemctl restart backend.service
VALIDATE $? "restarting backend"