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

dnf module disable nodejs -y &>>$LOGFILE

VALIDATE $? "Disabling NodeJS 10 version to install"

dnf module enable nodejs:18 -y &>>$LOGFILE

VALIDATE $? "Enabling NodeJS 18 version to install"

dnf install nodejs -y &>>$LOGFILE

VALIDATE $? "Installing nodejs18"

id roboshop
if [ $? -ne 0 ]
  then
     useradd roboshop &>>$LOGFILE
     VALIDATE $? "creating roboshop user"
else
     echo -e "roboshop user was already exist $SKIPPING$N"
fi

mkdir -p /app &>>$LOGFILE

VALIDATE $? "creating /app folder"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOGFILE &>>$LOGFILE

VALIDATE $? "Downloading Application code to app Dir "

cd /app 

unzip -o /tmp/catalogue.zip &>>$LOGFILE

VALIDATE $? "unzipping catalog.zip file"

npm install  &>>$LOGFILE

VALIDATE $? "Installing depencies"

cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service ?>>$LOGFILE

VALIDATE $? "copying catalouge service file"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "reloading the service"

systemctl enable catalogue &>>$LOGFILE

VALIDATE $? "Enabling Catalogue service"

systemctl start catalogue &>>$LOGFILE

VALIDATE $? "Starting Catalogue servive"

cp  /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/ &>>$LOGFILE

VALIDATE $? "Coying mongoDB repo"

dnf install mongodb-org-shell -y &>>$LOGFILE

VALIDATE $? "Installing MongoDB Client"

mongo --host mongodb.madcheer.online </app/schema/catalogue.js &>>LOGFILE

VALIDATE $? "Loading the schema"






