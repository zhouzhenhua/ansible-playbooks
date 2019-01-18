# only zabbix-agent
`ansible-playbook -i hosts --extra-vars 'remote_server=x.x.x.x remote_hostname=xxx.haomoney.local remote_ip=xx-xx ansible_python_interpreter=/usr/bin/python2.6' zabbix-agent.yaml`

# zabbix-agent rds
`zbx_rds=yes  [optional]`

# zabbix-agent rmq
`zbx_rmq=yes [optional]`
