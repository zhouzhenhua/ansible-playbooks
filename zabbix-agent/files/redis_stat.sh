#!/bin/bash

REDIS="/usr/local/bin/redis-cli"
SECRET="h2wLS6EMuIdKMBIiQiVb"
HOSTNAME="127.0.0.1"
PORT=6379


ZABBIX_SENDER='/usr/bin/zabbix_sender'
CONFIG='/etc/zabbix/zabbix_agentd.conf'


if [[ ! -z $SECRET ]]; then
	RespStr=$($REDIS -h $HOSTNAME -a $SECRET -p $PORT info all 2>/dev/null)
else 
	RespStr=$($REDIS -h $HOSTNAME -p $PORT info all 2>/dev/null)
fi

[ $? != 0 ] && echo 0 && exit 1


if [ -z $1 ]; then

(cat <<EOF
$RespStr
EOF
 ) | awk -F: \
 '$1~/^(mem_fragmentation_ratio|uptime_in_seconds|(blocked|connected)_clients|used_memory(_rss|_peak)?|total_(connections_received|commands_processed)|instantaneous_ops_per_sec|total_net_(input|output)_bytes|rejected_connections|(expired|evicted)_keys|keyspace_(hits|misses))$/ {
  print "- redis." $1, int($2)
 }
 $1~/^cmdstat_[a-z]+$/ {
  split($2, C, ",|=")
  print "- redis.cmd[" $1 "]", int(C[2])
 }
 $1~/^db[0-9]+$/ {
  split($2, C, ",|=")
  for(i=1; i < 6; i+=2) print "- redis." C[i] "[" $1 "]", int(C[i+1])
 }' | $ZABBIX_SENDER --config $CONFIG --input-file - >>/var/log/zabbix/$(basename $0).log 2>&1

 echo 1
 exit 0


elif [ "$1" = 'db' ]; then

 (cat <<EOF
$RespStr
EOF
 ) | awk -F: '$1~/^db[0-9]+$/ {
  OutStr=OutStr es "{\"{#DBNAME}\":\"" $1 "\"}"
  es=","
 }
 END { print "{\"data\":["OutStr"]}" }'

 elif [ "$1" = 'cmd' ]; then

 (cat <<EOF
$RespStr
EOF
 ) | awk -F: '$1~/^cmdstat_[a-z]+$/ {
 CmdStr=CmdStr es "{\"{#CMDSTAT}\":\"" $1 "\"}"
 es=","
 }
 END { print "{\"data\":["CmdStr"]}" }'
fi
