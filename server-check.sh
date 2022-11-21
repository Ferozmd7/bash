
#!/bin/bash
USERNAME=${1}
IP=${2}
PASS=${3}

sc="lscpu | grep -i '^CPU(s)';lscpu | grep 'Core(s) per socket';lscpu | grep 'Model name';lscpu | grep 'Socket(s)';hostnamectl |grep ' hostname';hostnamectl | grep 'Operating System';grep MemTotal /proc/meminfo"

ping -c1 -W1 -q ${2} &>/dev/null

status=$( echo $? )

if [[ $status == 0 ]] ; then
  echo "server is up"
  while sshpass -p ${3} ssh  -o StrictHostKeyChecking=no ${1}@${2} "${sc}" ;

    do
      sshpass -p ${3} ssh  -o StrictHostKeyChecking=no ${1}@${2} "${sc}"  |sed -r 's/\s+//g'   > output_of_${2}.csv
     
        echo "collected details of ${2} as output_of_${2} "
        exit 0
    done 

else 
   echo "server is down"

fi




