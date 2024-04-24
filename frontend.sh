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