echo -e "\n$(date "+%d-%m-%Y --- %T") --- BVALAB config...\n"
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
swapoff -a
yum update -y
yum install -y telnet nfs-utils firewalld ansible yum-utils timedatectl epel-release git curl unzip wget yum-utils device-mapper-persistent-data lvm2 docker
timedatectl set-timezone America/Sao_Paulo
export NFS_SERVER=192.168.210.10
mkdir -p /bvalab/nfs ; mount -t nfs -vvvv ${NFS_SERVER}:/bvalab/nfs /bvalab/nfs
echo '${NFS_SERVER}:/bvalab/nfs                 /bvalab/nfs              nfs          defaults    0       0' >> /etc/fstab
mkdir -p /etc/docker
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
yum-config-manager --add-repo /etc/yum.repos.d/kubernetes.repo
yum install -y kubelet kubeadm kubectl
systemctl enable firewalld --now
systemctl enable docker --now
systemctl enable kubelet --now
sed -i 's/cgroup-driver=systemd/cgroup-driver=cgroupfs/g' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
sudo systemctl daemon-reload
sudo firewall-cmd --permanent --add-port={6443,2379,2380,10250,10251,10252,8200,8201,8500}/tcp ; firewall-cmd --reload
echo -e "\n$(date "+%d-%m-%Y --- %T") --- BVALAB config...DONE\n"