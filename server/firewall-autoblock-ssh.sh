for ip in `cat /var/log/audit/audit.log | grep -v addr=192.168.178 | grep res=failed | grep -v addr=? | grep -v hostname=? | awk '{print $12}' | sort | uniq | sed 's/addr=//g'`;do firewall-cmd --permanent --zone="public" --add-rich-rule="rule family='ipv4' source address='$ip' reject" && logger "Blocked IP in firewalld, for being a dick!: $ip";done
systemctl restart firewalld.service
logger "Firewalld restarted"
