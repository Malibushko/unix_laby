#!/bin/bash
warname=sample.war
username=user
userpassword=password
deployname=laba
hostport=localhost:8080

curl -u $username:$userpassword "http://$hostport/manager/text/deploy?path=/$deployname&war=file:$(pwd)/$warname"
