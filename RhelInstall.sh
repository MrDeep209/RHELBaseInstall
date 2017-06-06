# A RedHat based startup Script by MrDeep

# Add epel repo
yum install wget -y
cd /tmp
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install epel-release-latest-7.noarch.rpm

# Update and install software
yum update -y
yum install screen vim ntp fail2ban whois -y

systemctl stop NetworkManager
systemctl disable NetworkManager
systemctl start fail2ban
systemctl enable fail2ban
systemctl start ntpd
systemctl enable ntpd

# Configure ssh and restart
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
echo "
# Added on Startup Script
AllowTcpForwarding no
ClientAliveCountMax 2
Compression no
MaxAuthTries 5
MaxSessions 2
UsePrivilegeSeparation sandbox
AllowAgentForwarding no" >> /etc/ssh/sshd_config
systemctl restart sshd


# Set a hostname
echo "Hostname?"
read hostname
hostnamectl set-hostname $hostname
echo "127.0.0.1 $hostname" >> /etc/hosts

# Add a root user
echo "Username?"
read username
adduser $username
usermod -aG wheel $username
