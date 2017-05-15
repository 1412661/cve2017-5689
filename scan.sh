#!/bin/bash

#if [ "$(id -u)" != "0" ]; then
#   echo "This script must be run as root" 1>&2
#   exit 1
#fi

if [ ! -f http-vuln-cve2017-5689.nse ]; then
    wget https://svn.nmap.org/nmap/scripts/http-vuln-cve2017-5689.nse 2> /dev/null
fi

echo -n "" > active.list
echo -n "" > vul.list

for ip in 123.123.{20..23}.{1..255}
do
	echo -n "Testing $ip..."
	result=$(nmap -p 16992 --script http-vuln-cve2017-5689 $ip)
	ip=$(echo $result | awk '{match($0,/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/); ip = substr($0,RSTART,RLENGTH); print ip}')
	echo $ip >> active.list

	echo $result | grep '16992/tcp open' > /dev/null
	if [ "$?" == "0" ]; then
		echo $ip >> vunl.list
		echo -e "\tCVE-2017-5689"
	else
		echo -e "\tOK"
	fi
done

sed -i '/^$/d' active.list
sed -i '/^$/d' vul.list

exit 0
