yum -y install firewalld
systemctl enable firewalld.service --now
firewall-cmd --permanent --add-service=nfs ; firewall-cmd --reload
yum -y install nfs-utils dhcp
timedatectl set-timezone America/Sao_Paulo
systemctl enable nfs-server.service --now
mkdir -pv /bvalab/nfs/{rundeck,ansible,loadbalance,samba,docker,k8s}
chown -R nfsnobody:nfsnobody /bvalab/nfs
chmod 755 -R /bvalab/nfs
cat <<EOF > /etc/exports
/bvalab/nfs    * (rw,sync,no_subtree_check)
EOF
#everytime this file is modified, need to run:
exportfs -a
cat <<EOF > /etc/dhcp/dhcpd.conf
option domain-name                      "bvalab.local";
option domain-name-servers              bvalab003.bvalab.local;
default-lease-time                      86400;
#max-lease-time                          172800;
max-lease-time                          -1;
ddns-update-style                       none;
one-lease-per-client true;
authoritative;
option ntp-servers                      192.168.210.10;
ignore client-updates;
allow booting;
allow bootp;
allow unknown-clients;

subnet 192.168.210.0 netmask 255.255.255.0 {
  range 192.168.210.10 192.168.210.200;
  option domain-name-servers 192.168.210.10;
  option domain-search "bvalab.local";
  option subnet-mask 255.255.255.0;
  option routers 192.168.210.10;
}
EOF
systemctl enable dhcpd.service --now
yum -y install epel-release yum-utils mariadb mariadb-server pdns pdns-backend-mysql bind-utils
yum-config-manager --enable remi-php72
systemctl enable mariadb --now
root
JMDva93bZdn9GuyH
create database db_powerdns;
 grant all privileges on db_powerdns.* to pdns@localhost identified by 'f2K3Hjw72rg5uwEC';
 flush privileges;
 cd /etc/pdns/
 vim pdns.conf
 #launch=bind

launch=gmysql
gmysql-host=localhost
gmysql-user=pdns
gmysql-password=f2K3Hjw72rg5uwEC
gmysql-dbname=db_powerdns

# admin user powerdns
# kswTNC43krr6QmJU

GRANT SELECT, INSERT, UPDATE, DELETE
 ON db_powerdns.*
 TO 'user'@'localhost'
 IDENTIFIED BY 'GMjQfd9JqFGjN5Pd';

yum -y install httpd php php-devel php-gd php-imap php-ldap php-mysql php-odbc php-pear php-xml php-xmlrpc php-mbstring php-mcrypt php-mhash gettext
yum -y install php-pear-DB php-pear-MDB2-Driver-mysqli
systemctl enable httpd --now
cd /var/www/html/
wget http://downloads.sourceforge.net/project/poweradmin/poweradmin-2.1.7.tgz
tar xvf poweradmin-2.1.7.tgz
mv poweradmin-2.1.7/ poweradmin/
firewall-cmd --add-service={http,https} --permanent
firewall-cmd --reload