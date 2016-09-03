#!/bin/bash

function greenEcho () {
    echo -e "\033[32m $1 \033[0m"
}
function redEcho () {
    echo -e "\033[31m $1 \033[0m"
}
function command_exists() {
    command -v "$@" > /dev/null 2>&1
}
echo "#### 系统基本环境检查 ####"
[ "$(id -u)" != "0" ] && { redEcho "您当前不是root账户 ..."; exit 1; } || greenEcho "您当前是root用户 ..."
[ "$(uname -r)" != "3.10.0-327.28.2.el7.x86_64" ] && { redEcho "内核版本不对,非3.10.0-327.28.2.el7.x86_64 ..."; } || greenEcho "内核版本正确3.10.0-327.28.2.el7.x86_64 ..."
[ "$(rpm --query centos-release)" != "centos-release-7-2.1511.el7.centos.2.10.x86_64" ] && { redEcho "系统版本不对 ..."; } || greenEcho "系统版本正确centos-release-7-2.1511.el7.centos.2.10.x86_64 ..."
echo "#### selinux, firewalld, iptables检查 ####"
[ "$(getenforce)" != "Disabled" ] && redEcho "Selinux 状态不对 ..." || greenEcho "Selinux 已经设置Disabled ..."
[ ! "$(systemctl status firewalld | grep dead)" ] && redEcho "Firewalld 状态不对 ..." || greenEcho "Firewalld 开机自启动关闭 ..."
[ ! "$(systemctl status iptables | grep dead)" ] && redEcho "iptables 状态不对 ..." || greenEcho "iptables 开机自启动关闭 ..."
echo "#### 文件系统检查 ####"
[ ! "$(df -lhT /data | grep " xfs ")" ] && redEcho "/data文件夹所在的文件系统非xfs ..." || greenEcho "/data文件夹所在的文件系统是xfs ..."

echo "#### ntp服务检查 ####"
echo  -e "\033[33;5;7m 当前时间是 $(date) \033[0m"
[ "$(systemctl is-active ntpd)" != "active" ] && redEcho "ntpd service 没有运行 ..." || greenEcho "ntpd service 服务正在运行 ..."
[ "$(systemctl is-enabled ntpd)" != "enabled" ] && redEcho "ntpd service 开机没有自启动 .." || greenEcho "ntpd service 开机自启动 ..."

echo "#### docker服务检查 ####"
[ "$(command_exists docker)" ] && redEcho "docker 未安装 ..." || greenEcho "$(docker --version) 已安装 ..."
[ ! "$(docker info 2>&1 | grep overlay)" ] && redEcho "docker 不是overlay存储 ..." || greenEcho "docker 是overlay存储 ..."
[ "$(systemctl is-active docker)" != "active" ] && redEcho "docker service 没有运行 ..." || greenEcho "docker service 服务正在运行 ..."
[ "$(systemctl is-enabled docker)" != "enabled" ] && redEcho "docker service 开机没有自启动 .." || greenEcho "docker service 开机自启动 ..."

echo "#### rsyslog服务检查 ####"
[ "$(command_exists rsyslogd)" ] && redEcho "rsyslogd 未安装 ..." || greenEcho "rsyslogd 已安装 ..."
[ "$(systemctl is-active rsyslog)" != "active" ] && redEcho "rsyslog service 没有运行 ..." || greenEcho "rsyslog service 服务正在运行 ..."
[ "$(systemctl is-enabled rsyslog)" != "enabled" ] && redEcho "rsyslog service 开机没有自启动 .." || greenEcho "rsyslog service 开机自启动 ..."

echo "#### ssh服务检查 ####"
[ "$(command_exists ssh)" ] && redEcho "sshd 未安装 ..." || greenEcho "sshd 已安装 ..."
[ "$(systemctl is-active sshd)" != "active" ] && redEcho "sshd service 没有运行 ..." || greenEcho "sshd service 服务正在运行 ..."
[ "$(systemctl is-enabled sshd)" != "enabled" ] && redEcho "sshd service 开机没有自启动 .." || greenEcho "sshd service 开机自启动 ..."
