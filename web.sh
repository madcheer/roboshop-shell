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

dnf install nginx -y

VALIDATE $? "Installing Nginx"

systemctl enable nginx

VALIDATE $? "Enabling ngnis servrice"

systemctl start nginx

VALIDATE $? "Starting nginx service"

rm -rf /usr/share/nginx/html/*

VALIDATE $? "Removing Default html content"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip

VALIDATE $? "Downloading the front content"

cd /usr/share/nginx/html

unzip /tmp/web.zip

VALIDATE $? "Unzipping web.zip file into /tmp dir"

cp -p /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/

VALIDATE $? "Copying roboshop config file"

systemctl restart nginx 

VALIDATE $? "Re-starting ngnix service"

