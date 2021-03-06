#!/bin/sh

IPT="/sbin/iptables"

# flush old rules
$IPT -F
$IPT -X

# set default policies to drop
$IPT -P INPUT DROP
$IPT -P FORWARD DROP
$IPT -P OUTPUT DROP

# enable all communication on loopback interface
$IPT -A INPUT -i lo -j ACCEPT
$IPT -A OUTPUT -o lo -j ACCEPT

# accept DNS
$IPT -A INPUT -p udp -m udp --dport 53 -s 0.0.0.0/0 -j ACCEPT
$IPT -A OUTPUT -p udp --dport 53 -j ACCEPT

# accept DCHP
#$IPT -A INPUT -p udp -m udp --dport 67 -s 0.0.0.0/0 -j ACCEPT

# accept ssh, http, and https
$IPT -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPT -A INPUT -p tcp --dport 22 -j ACCEPT
$IPT -A INPUT -p tcp --dport 80 -j ACCEPT
$IPT -A INPUT -p tcp --dport 443 -j ACCEPT
$IPT -A OUTPUT -p tcp --sport 22 -j ACCEPT
$IPT -A OUTPUT -p tcp --sport 80 -j ACCEPT
$IPT -A OUTPUT -p tcp --sport 443 -j ACCEPT

# save firewall file as SAVE_LOC 
SAVE_LOC="/etc/iptables.rules"
iptables-save > $SAVE_LOC
