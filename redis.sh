#!/bin/bash

    R="\e[31m"
    G="\e[32m"
    Y="\e[33m"
    N="\e[0m"

    TIMESTAMP=$(date +%F-%H-%M-%S)

    LOGFILE="/tmp/$0-$TIMESTAMP.log"

ID=$(id -u)

if [ $ID -ne 0 ]
  then
      echo -e "ERROR: $R you are not a root user to install $N"
      exit 1
  else
    echo "you are root user"
fi

VALIDATE()
{

if [ $? -ne 0 ]
   then
        echo -e "$2.... $R FAILED $N"
        exit 1
    else
         echo -e "$2.... $G SUCCESSFUL $N"
fi

}

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOGFILE

VALIDATE $? "Installing remi rlease"

dnf module enable redis:remi-6.2 -y &>>$LOGFILE

VALIDATE $? "Enabling redis"

dnf install redis -y &>>$LOGFILE

VALIDATE $? "Installing Redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>>LOGFILE

VALIDATE $? "Allowing remote connections"

systemctl enable redis &>>$LOGFILE

VALIDATE $? "Enabling Redis"

systemctl start redis &>>$LOGFILE

VALIDATE $? "starting redis"






