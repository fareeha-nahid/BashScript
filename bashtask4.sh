#!/bin/bash

set -x

check_webServer(){
	ps -ef | grep apache
	[ $?  -eq "0" ] && echo "Web server is installed" || install_apache2
}


install_apache2(){
	sudo apt-get install apache2
}

cd ovs

var_commit=$(git rev-parse HEAD)
echo "$var_commit" > ~/Desktop/commit_no.txt
#or echo $(git rev-parse HEAD)>~/Desktop/commit_no.txt 

check_webServer

sudo make>~/Desktop/buildoutput4.txt

var_status=$?
echo "$var_status" > ~/Desktop/build_status.txt
#or echo $?>>~/Desktop/build_status.txt

#cd /var/www/html/
cd /home/fareeha/Desktop/

firefox myIndex.html


