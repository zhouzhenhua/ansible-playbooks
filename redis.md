# redis-allone
`ansible-playbook -i hosts redis.yaml -e remote_server=x.x.x.x -e redis_port2=6380 -e rds_mode=allone -e ansible_python_interpreter=/usr/bin/python2.6`


# redis-cluster
`ansible-playbook -i hosts redis.yaml -e remote_server=x.x.x.x -e redis_port2=6380 -e rds_mode=cluster -e ansible_python_interpreter=/usr/bin/python2.6`


# redis_port2 vars [optional]
