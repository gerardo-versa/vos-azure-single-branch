#!/bin/bash
log_path="/etc/bootLog.txt"
SSHKey="${sshkey}"
LOCALauth="${localauth}"
REMOTEauth="${remoteauth}"
SERIALnum="${serialnum}"
CONTROLLERip="${controllerip}" 
DirIP="${dirip}"
KeyDir="/home/admin/.ssh"
KeyFile="/home/admin/.ssh/authorized_keys"
#echo "Starting cloud init script..." > $log_path
#echo "Openning password auth" > $log_path
#sudo sed -i '/PasswordAuthentication no/c\PasswordAuthentication yes' /etc/ssh/sshd_config
#sudo service ssh restart
#main

touch $log_path
echo "Modifying /etc/network/interface file.." >> $log_path
echo "$(date)" >> $log_path
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

# The secondary network interface (WAN)
#auto eth1
#iface eth1 inet dhcp

# The third network interface (LAN)
#auto eth2
#iface eth2 inet dhcp
EOF
echo -e "Modified /etc/network/interface file. Refer below new interface file content:\n`cat /etc/network/interfaces`" >> $log_path
echo "$(date)" >> $log_path

echo "Openning password auth" > $log_path
sudo sed -i '/PasswordAuthentication no/c\PasswordAuthentication yes' /etc/ssh/sshd_config
sudo service ssh restart
#sudo sed -i '/net.ipv4.conf.all.arp_ignore = 2/c\net.ipv4.conf.all.arp_ignore = 1' /etc/sysctl.conf
#sudo sed -i '/net.ipv4.conf.default.arp_ignore = 2/c\net.ipv4.conf.default.arp_ignore = 1' /etc/sysctl.conf

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

cat>/etc/stage_data.sh <<EOF
#!/bin/bash

#echo "versa123" | sudo su - admin

echo "versa123" | sudo /opt/versa/scripts/staging.py -w 0 -c $CONTROLLERip -d -l $LOCALauth -r $REMOTEauth -n $SERIALnum
EOF

echo "$(date)" >> $log_path

sudo chmod 777 /etc/stage_data.sh

echo "Ran staging at $(date)" >> $log_

crontab -l > /etc/orig_crontab
file='/var/lib/vs/.serial'
if [ ! -s $file ]; then
    echo "Staging not done yet" >> $log_path
    echo "$(date)" >> $log_path
        echo "`date +%M --date='7 minutes'` `date +%H` `date +%d` `date +%m` * sudo bash /etc/stage_data.sh; sudo crontab -l | grep -v stage_data.sh | crontab " >>  /etc/orig_crontab
        sudo crontab /etc/orig_crontab
        echo "$(date)" >> $log_path
elif [ "`cat $file`" == "Not Specified" ]; then
    echo "Serial Number not set. Continue with Staging." >> $log_path
    echo "$(date)" >> $log_path
        echo "`date +%M --date='7 minutes'` `date +%H` `date +%d` `date +%m` * sudo bash /etc/stage_data.sh; sudo crontab -l | grep -v stage_data.sh | crontab " >>  /etc/orig_crontab
        sudo crontab /etc/orig_crontab
        echo "$(date)" >> $log_path
else
    echo "Staging already happened. So, skipping this step." >> $log_path
    echo "$(date)" >> $log_path
fi

#dir_ssh_exception() {
#sudo su
#echo -e "Enabling ssh login using password from Director to Branch; required for first time login during Branch on-boarding." >> $log_path
#echo "$(date)" >> $log_path
#if ! grep -Fq "$Address" $SSH_Conf; then
#    echo -e "Adding the match address exception for Director Management IP required for first time login during Branch on boarding.\n" >> $log_path
#    echo "$(date)" >> $log_path
#    sed -i.bak "\$a\Match Address $DirIP\n  PasswordAuthentication yes\nMatch all" $SSH_Conf
#    sudo service ssh restart
#else
#    echo -e "Director Management IP address is alredy present in file $SSH_Conf.\n" >> $log_path
#    echo "$(date)" >> $log_path
#fi

#main() {
#modify_e_n_i
#configure_staging
#sudo chmod 777 /etc/stage_data.sh
#sudo chown admin /etc/stage_data.sh
#sudo chgrp versa /etc/stage_data.sh
#run_staging
#echo "Ran staging at $(date)" >> $log_path
#dir_ssh_exception
#main
