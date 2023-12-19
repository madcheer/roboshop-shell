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

dnf module disable nodejs -y &>$LOGFILE

VALIDATE $? "Disabling Default NodeJS"

dnf module enable nodejs:18 -y  &>$LOGFILE

VALIDATE $? "Enabiling Default NodeJS:18"

dnf install nodejs -y  &>$LOGFILE

VALIDATE $? "Installing nodejs:18"

id roboshop
if [ $? -ne 0 ]
   then
    useradd roboshop
    VALIDATE $? "successfully created roboshop user" &>$LOGFILE
   else
     echo -e "roboshop user is already exist $Y SKIPPING $N" &>$LOGFILE
fi

mkdir /app

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip  &>$LOGFILE

VALIDATE $? "Downloading cart.zip file"

unzip /tmp/cart.zip &>$LOGFILE

VALIDATE $? "Unzipping cart.zip file"

cd /app 

npm install &>$LOGFILE

VALIDATE $? "Installing Depedencies" 

cp -p /home/centos/roboshop-shell/cart.service /etc/systemd/system/ &>$LOGFILE

VALIDATE $? "copying cart.service file" 

systemctl daemon-reload &>$LOGFILE

VALIDATE $? "reloading the deamon"

systemctl enable cart &>$LOGFILE

VALIDATE $? "enabling the cart service"

systemctl start cart &>$LOGFILE

VALIDATE $? "starting catalog service"











