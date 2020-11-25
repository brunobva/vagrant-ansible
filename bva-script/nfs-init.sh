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
/bvalab/nfs 192.168.210.0/24(rw,sync,no_all_squash,root_squash)
EOF
#everytime this file is modified, need to run:
exportfs -a
cat <<EOF > /etc/dhcp/dhcpd.conf
option domain-name                      "bvalab.local";
option domain-name-servers              ns.bvalab.local;
default-lease-time                      86400;
#max-lease-time                          172800;
max-lease-time                          -1;
ddns-update-style                       none;
one-lease-per-client true;
authoritative;
option ntp-servers                      ns.bvalab.local;
ignore client-updates;
allow booting;
allow bootp;
allow unknown-clients;

subnet 192.168.210.0 netmask 255.255.255.0 {
  range 192.168.210.10 192.168.210.200;
  option domain-name-servers ns.bvalab.local;
  option domain-search "bvalab.local";
  option subnet-mask 255.255.255.0;
  option routers 192.168.210.10;
}
EOF
systemctl enable dhcpd.service --now