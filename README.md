数人云线下实施批量操作脚本
==========================

### features

1. 为 CentOS 批量安装 docker, ntp, lrzsz, telnet, strace, docker-compose, net-tools
2. 配置 hostname 解析(mesos 需要)
3. 修改 hosts 使之能够访问
4. 为 CentOS 关闭 firewalld
5. 为 CentOS 关闭 selinux
6. kernel 优化

### 使用
inventory/group_vars/all
ntpIP: "172.16.1.100"            需要同步的时间服务器
registryIP: "192.168.1.174"      docker RTCConfiguration --insecure-registry
dockerVersion: "1.12.1"          安装的docker的版本
yumMirrorIP: "192.168.1.244:8081"离线的mirror源地址

inventory/hosts
[init]
172.16.1.101 hostname=master ansible_ssh_host=172.16.1.101 配置要初始化的主机，主机名，在/etc/hosts里添加记录172.16.1.101 master
172.16.1.102 hostname=slave ansible_ssh_host=172.16.1.102

- 初始化系统
    ansible-playbook playbook/host-init/host-init.yml
- 检查系统
    ansible-playbook playbook/check/check.yml
