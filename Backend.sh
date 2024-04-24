#!/bin/bash

USERID=$(id -u)
TIME_STAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log


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
#list modules
dnf module list
VALIDATE $? "list of modules"
dnf module disable nodejs -y
VALIDATE $? "disabled  modules"
dnf module enable nodejs:20 -y
VALIDATE $? "enaabled  module20"
dnf install nodejs -y
VALIDATE $? "installation of Nodejs"
useradd expense
mkdir /app
curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
cd /app
unzip /tmp/backend.zip
cd /app
npm install
