#!/bin/bash

    R="\e[31m"
    G="\e[32m"
    Y="\e[33m"
    N="\e[0m"

    TIMESTAMP=$(date +%F-%H-%M-%S)
    LOGFILE="/tmp/$0-$TIMESTAMP.log"

    exec &>$LOGFILE

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

VALIDATE $? "Disabling Default NodeJS"

dnf module enable nodejs:18 -y

VALIDATE $? "Enabiling Default NodeJS:18"

dnf install nodejs -y 

VALIDATE $? "Installing nodejs:18"

id roboshop
if [ $? -ne 0 ]
   then
    useradd roboshop
    VALIDATE $? "successfully created roboshop user"
   else
     echo -e "roboshop user is already exist $Y SKIPPING $N"
fi

mkdir /app

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip 

VALIDATE $? "Downloading cart.zip file"

unzip /tmp/cart.zip

VALIDATE $? "Unzipping cart.zip file"

cd /app 

npm install 

VALIDATE $? "Installing Depedencies"

cp -p /home/centos/roboshop-shell/cart.service /etc/systemd/system/

VALIDATE $? "copying cart.service file"

systemctl daemon-reload

VALIDATE $? "reloading the deamon"

systemctl enable cart 

VALIDATE $? "enabling the cart service"

systemctl start cart

VALIDATE $? "starting catalog service"











