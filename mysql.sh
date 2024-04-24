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
#Install MySQL Server 8.0.x

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installation of MySql"

#Start MySQL Service

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "enabled  of MySql"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "starting  of MySql"

#We need to change the default root password in order to start using the database service. Use password ExpenseApp@1 or any other as per your choice.
# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIDATE $? "setting up root passwd"
mysql -h db.daws78s.online -uroot -pExpenseApp@1 -e 'SHOW DATABASES;' &>>$LOGFILE
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
    VALIDATE $? "MySQL Root password Setup"
else
    echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
fi