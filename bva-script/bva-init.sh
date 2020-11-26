echo -e "\n$(date "+%d-%m-%Y --- %T") --- BVALAB config...\n"
export PATH=$PATH:/usr/local/bin
export NFS_SERVER=192.168.210.10
mkdir -p /bvalab/nfs ; mount -t nfs -vvvv ${NFS_SERVER}:/bvalab/nfs /bvalab/nfs
echo '${NFS_SERVER}:/bvalab/nfs                 /bvalab/nfs              nfs          defaults    0       0' >> /etc/fstab
grep -ir "PasswordAuthentication no" /etc/ssh/sshd_config | sed -i.bak 's/no/yes/g' /etc/ssh/sshd_config
systemctl restart sshd
modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
swapoff -a
yum install -y ansible telnet nfs-utils firewalld yum-utils epel-release git curl unzip wget yum-utils device-mapper-persistent-data lvm2 docker
timedatectl set-timezone America/Sao_Paulo
mkdir -p /etc/bvalab 
git clone https://github.com/brunobva/vagrant-ansible.git /etc/bvalab/
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i /etc/bvalab/Ansible/inventory /etc/bvalab/Ansible/playbook.yml
systemctl enable firewalld --now
systemctl enable docker --now
systemctl enable kubelet --now
sudo systemctl daemon-reload
sudo firewall-cmd --permanent --add-port={6443,2379,2380,10250,10251,10252,8200,8201,8500}/tcp ; firewall-cmd --reload
echo -e "\n$(date "+%d-%m-%Y --- %T") --- BVALAB config...DONE\n"