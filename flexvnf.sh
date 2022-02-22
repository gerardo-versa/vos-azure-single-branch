#!/bin/bash
log_path="/etc/bootLog.txt"
if [ -f "$log_path" ]
then
	echo "Cloud Init script already ran earlier during first time boot.." >> $log_path
else
	touch $log_path
SSHKey="${sshkey}"
LOCALauth="${localauth}"
REMOTEauth="${remoteauth}"
SERIALnum="${serialnum}"    
KeyDir="/home/admin/.ssh"
KeyFile="/home/admin/.ssh/authorized_keys"
echo "Starting cloud init script..." > $log_path

echo "Openning password auth" > $log_path
sudo sed -i '/PasswordAuthentication no/c\PasswordAuthentication yes' /etc/ssh/sshd_config
sudo service ssh restart

echo "Modifying /etc/network/interface file.." >> $log_path
cp /etc/network/interfaces /etc/network/interfaces.bak
cat > /etc/network/interfaces << EOF
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
iface eth0 inet dhcp

EOF
echo -e "Modified /etc/network/interface file. Refer below new interface file content:\n`cat /etc/network/interfaces`" >> $log_path

echo -e "Injecting ssh key into admin user.\n" >> $log_path
if [ ! -d "$KeyDir" ]; then
    echo -e "Creating the .ssh directory and injecting the SSH Key.\n" >> $log_path
    sudo mkdir $KeyDir
    sudo echo $SSHKey >> $KeyFile
    sudo chown admin:versa $KeyDir
    sudo chown admin:versa $KeyFile
    sudo chmod 600 $KeyFile
elif ! grep -Fq "$SSHKey" $KeyFile; then
    echo -e "Key not found. Injecting the SSH Key.\n" >> $log_path
    sudo echo $SSHKey >> $KeyFile
    sudo chown admin:versa $KeyDir
    sudo chown admin:versa $KeyFile
    sudo chmod 600 $KeyFile
else
    echo -e "SSH Key already present in file: $KeyFile.." >> $log_path
fi
fi

echo -e "Starting staging script\n" >> $log_path
echo $LOCALauth >> $log_path
echo $REMOTEauth >> $log_path
echo $SERIALnum >> $log_path
echo "sudo /opt/versa/scripts/staging.py -l $LOCALauth -r $REMOTEauth -n $SERIALnum -c 3.9.120.41 -w 0  -d | at 'now + 5 minutes'" >> $log_path
sudo /opt/versa/scripts/staging.py -l $LOCALauth -r $REMOTEauth -n $SERIALnum -c 3.9.120.41 -w 0  -d | at now + 9 minutes
echo -e "Starting staging script (+5)\n" >> $log_path | at 'now + 5 minutes'
