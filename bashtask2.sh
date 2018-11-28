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
	 
	git checkout v2.5.0
	./boot.sh
	./configure --build=x86_64

	make>~/Desktop/buildoutputv2.5.0.txt

	if [ $? -eq 0 ] #$? stores status of last command, if !=0 then error
	then
		echo "Build successful"
	else
		echo "Build failed"
	fi
	
	sudo make install

	export PATH=$PATH:/usr/local/share/openvswitch/scripts
	
	mkdir -p /usr/local/etc/openvswitch
	sudo ovsdb-tool create /usr/local/etc/openvswitch/conf.db \
    	vswitchd/vswitch.ovsschema

	sudo ovs-ctl start #setup initial conditions and start the daemons in the correct order

	sudo mkdir -p /usr/local/var/run/openvswitch
	sudo ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock \
        --remote=db:Open_vSwitch,Open_vSwitch,manager_options \
        --pidfile --detach --log-file
	
	sudo ovs-vsctl --no-wait init #initialize the database
	sudo ovs-vswitchd --pidfile --detach --log-file #Start the main Open vSwitch daemon

	#sudo ovs-vsctl add-br br0
        #sudo ovs-vsctl add-port br0 enp0s3
	#sudo ovs-vsctl add-port br0 enp0s8

	sudo ovs-vsctl show #shows existing bridges along with ports and interfaces

	sudo ovs-ofctl dump-flows br0 #for testing the bridge working

	sudo ovs-ofctl show br0 #shows mapping of ofports + mac addrs/dl_scr
	
	###100 FLOW RULES: Pckets with ip b/w 10.0.0.1 to 10.0.0.100 will be dropped
	
	sudo ovs-ofctl del-flows br0 	

		i=1
		while [ $i -le 100 ]
		do 
			ip=10.0.0.$i
			sudo ovs-ofctl add-flow br0 priority=500,ip,nw_src=$ip,actions=drop
			((i++))
		done

	#enp0s3=1 & enp0s8=1
	

	make clean
	sleep 3m
done
