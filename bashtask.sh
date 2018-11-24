#!/bin/bash
cd ovs
#prints the working on screen
set -x 
while true
do
	var_localcommit=$(git rev-parse HEAD 2>&1)
	var_remotecommit=$(git rev-parse origin/master 2>&1)

	if [ var_localcommit != var_remotecommit ]
	then 
		git pull 
		git push -u origin master	
	fi
	
	./boot.sh
	./configure --build=x86_64

	make>~/Desktop/buildoutput.txt

		if [ $? -eq 0 ] #$? stores status of last command, if !=0 then error
		then
			echo "Build successful"
		else
			echo "Build failed"
		fi
	make clean
	sleep 3m
done
