#!/bin/bash
warname=$1
username=user
userpassword=password
deployname=laba
hostport=localhost:8080


read -p "Deploy or undeploy (d\u)" -n 1 -r
  echo
  if [[ $REPLY =~ ^[Dd]$ ]]; then
    if [[ -z $1 ]]; then
      echo "Please specify a .war file to deploy"
      exit 1
    fi
    curl -u $username:$userpassword "http://$hostport/manager/text/deploy?path=/$deployname&war=file:$(pwd)/$warname"
  elif  [[ $REPLY =~ ^[Uu]$ ]]; then
    curl -u $username:$userpassword "http://$hostport/manager/text/undeploy?path=/$deployname&$warname"
  else exit 1
  fi
