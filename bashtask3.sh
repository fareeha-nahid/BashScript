#!/bin/bash
cd ovs
#prints the working on screen
set -x 

var_localcommit=$(git rev-parse HEAD 2>&1)
var_remotecommit=$(git rev-parse origin/master 2>&1)

check_new_commit(){
        if [ var_localcommit != var_remotecommit ]
	then
		clone_and_build
	fi
}

clone_and_build(){
        
	git checkout master

	git pull origin master
	git push -u origin master	
	
	./boot.sh
	./configure --build=x86_64

	sudo make>~/Desktop/buildoutput.txt

	print_build_status

	make clean	
}

print_build_status(){
	if [ $? -eq 0 ] 
	then
		echo "Build successful"
	else
		echo "Build failed"
	fi
}


while true
do
	check_new_commit
	sleep 3m
done




