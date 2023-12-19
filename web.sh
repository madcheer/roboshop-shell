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

dnf install nginx -y &>>$LOGFILE

VALIDATE $? "Installing Nginx"

systemctl enable nginx &>>$LOGFILE

VALIDATE $? "Enabling nginx servrice"

systemctl start nginx &>>$LOGFILE

VALIDATE $? "Starting nginx service"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE

VALIDATE $? "Removing Default html content"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip  &>>$LOGFILE

VALIDATE $? "Downloading the front content"

cd /usr/share/nginx/html  

unzip /tmp/web.zip &>>$LOGFILE

VALIDATE $? "Unzipping web.zip file into /tmp dir"

cp -p /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/ &>>$LOGFILE

VALIDATE $? "Copying roboshop reverse proxy config file"

systemctl restart nginx  &>>$LOGFILE

VALIDATE $? "Re-starting ngnix service"

