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
        echo -e "$2.... $R got failed $N"
        exit 1
    else
         echo -e "$2.... $G got succesful $N"
fi

}

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? "Copying MongoDB Repo"

dnf install mongodb-org -y  &>>$LOGFILE

VALIDATE $? "Installing MongoDB "

systemctl enable mongod &>>$LOGFILE

VALIDATE $? "Enabling MongoDB"

systemctl start mongod &>>$LOGFILE

VALIDATE $? "starting MongoDB "

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf &>>$LOGFILE

VALIDATE $? "Providing Remote access to MongoDB"

systemctl restart mongod &>>$LOGFILE

VALIDATE $? "restarting MongoDB"







