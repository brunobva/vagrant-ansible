echo -e "\n$(date "+%d-%m-%Y --- %T") --- BVALAB config...\n"
export PATH=$PATH:/usr/local/bin
export NFS_SERVER=192.168.210.10
yum install epel-release git ansible -y
mkdir -p /bvalab/nfs ; mount -t nfs -vvvv ${NFS_SERVER}:/bvalab/nfs /bvalab/nfs
echo '${NFS_SERVER}:/bvalab/nfs                 /bvalab/nfs              nfs          defaults    0       0' >> /etc/fstab
grep -ir "PasswordAuthentication no" /etc/ssh/sshd_config | sed -i.bak 's/no/yes/g' /etc/ssh/sshd_config
systemctl restart sshd
modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
swapoff -a
mkdir -p /etc/bvalab 
git clone https://github.com/brunobva/vagrant-ansible.git /etc/bvalab/
ansible-playbook -i /etc/bvalab/Ansible/inventory /etc/bvalab/Ansible/playbook.yml
systemctl enable firewalld --now
systemctl enable docker --now
systemctl enable kubelet --now
sudo systemctl daemon-reload
sudo firewall-cmd --permanent --add-port={6443,2379,2380,10250,10251,10252,8200,8201,8500}/tcp ; firewall-cmd --reload
echo -e "\n$(date "+%d-%m-%Y --- %T") --- BVALAB config...DONE\n"