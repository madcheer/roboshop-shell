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

dnf module disable nodejs -y 

VALIDATE $? "Disabling Currnet NodeJS version"

dnf module enable nodejs:18 -y

VALIDATE $? "Enabling  NodeJS:18"

dnf install nodejs -y

VALIDATE $? "Installing Nodejs:18"

id roboshop
if [ $? -ne 0 ]
  then
     useradd roboshop &>>$LOGFILE
     VALIDATE $? "creating roboshop user"
else
     echo -e "roboshop user was already exist.. $Y SKIPPING $N"
fi

mkdir -p /app

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip  &>>$LOGFILE

npm install &>>LOGFILE

VALIDATE $? "Installing dependencies"

cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service &>>$LOGFILE

VALIDATE $? "Copying user service file"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "Realoading service"

systemctl enable user &>>$LOGFILE

VALIDATE $? "Enabling the user"

systemctl start user &>>$LOGFILE

VALIDATE $? "Starting user service"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? "Copying MONGODB Repo file"

dnf install mongodb-org-shell -y &>>$LOGFILE

VALIDATE $? "Installing dependencies"

mongo --host mongodb.madcheer.online </app/schema/user.js &>>$>LOGFILE

VALIDATE $? "Loading the schema"


