#!/bin/bash
HOME=/opt
TAR_PATH=${HOME}/tar
#修改为阿里云源
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

#mv /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.bak
#wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

yum clean all && yum makecache
yum -y update

#关闭防火墙
systemctl stop firewalld.service
systemctl disable firewalld.service 
mv /etc/sysconfig/selinux /etc/sysconfig/selinux.bak
echo "SELINUX=disabled" > /etc/sysconfig/selinux
echo "SELINUXTYPE=targeted" >> /etc/sysconfig/selinux

wget -P ${TAR_PATH} https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/stable/apache-zookeeper-3.5.5-bin.tar.gz
wget -P ${TAR_PATH} http://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-2.9.2/hadoop-2.9.2.tar.gz
wget -P ${TAR_PATH} http://mirrors.tuna.tsinghua.edu.cn/apache/flink/flink-1.9.0/flink-1.9.0-bin-scala_2.12.tgz

tar -zxvf ${TAR_PATH}/apache-zookeeper-3.5.5-bin.tar.gz -C ${HOME}
tar -zxvf ${TAR_PATH}/hadoop-2.9.2.tar.gz -C ${HOME}
tar -zxvf ${TAR_PATH}/flink-1.9.0-bin-scala_2.12.tgz -C ${HOME}

mv ${HOME}/apache-zookeeper-3.5.5 ${HOME}/zookeeper
mv ${HOME}/hadoop-2.9.2 ${HOME}/hadoop
mv ${HOME}/flink-1.9.0 ${HOME}/flink

cat >> /etc/profile << EOF
export ZOOKEEPER_HOME=/opt/zookeeper
export HADOOP_HOME=/opt/hadoop
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export FLINK_HOME=/opt/flink
export PATH=$PATH:${ZOOKEEPER_HOME}/bin:${HADOOP_HOME}/bin:${FLINK_HOME}/bin
EOF

mv ${HOME}/zookeeper/conf/zoo_sample.cfg ${HOME}/zookeeper/conf/zoo.cfg
