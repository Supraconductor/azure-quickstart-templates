#!/bin/bash
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#   http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# 
# See the License for the specific language governing permissions and
# limitations under the License.

echo "initializing nodes..."
IPPREFIX=$1
WORKERSTARTINGIP=$2
NAMEPREFIX=$3
NAMESUFFIX=$4
DATANODES=$5


# Converts a domain like machine.domain.com to domain.com by removing the machine name
NAMESUFFIX=`echo $NAMESUFFIX | sed 's/^[^.]*\.//'`

#Generate IP Addresses for the cloudera setup
NODES=()

let "DATAEND=DATANODES-1"
for i in $(seq 0 $DATAEND)
do 
  let "IP=i+WORKERSTARTINGIP"
  NODES+=("$IPPREFIX$IP:${NAMEPREFIX}-dn$i.$NAMESUFFIX:${NAMEPREFIX}-dn$i")
done

OIFS=$IFS
IFS=',';NODE_IPS="${NODES[*]}";IFS=$' \t\n'

IFS=','
for x in $NODE_IPS
do
  line=$(echo "$x" | sed 's/:/ /' | sed 's/:/ /')
  echo "$line" >> /etc/hosts
done
IFS=${OIFS}