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
fi

VALIDATE(){
    if [ $1 -ne 0 ]
    then    
        echo -e "$2..$R failed $N"
    else
        echo -e "$2..$G Success $N"
    exit 1      
    fi      
}
#Install MySQL Server 8.0.x

dnf install mysql-server -y
VALIDATE $? "Installation of MySql"

#Start MySQL Service

systemctl enable mysqld
VALIDATE $? "enabled  of MySql"

systemctl start mysqld
VALIDATE $? "starting  of MySql"

#We need to change the default root password in order to start using the database service. Use password ExpenseApp@1 or any other as per your choice.
mysql_secure_installation --set-root-pass ExpenseApp@1
VALIDATE $? "ssetting up root passwd"