#bin/bash
#reverse ip & detect CMS
#how to work it ? bash namefile.sh domain.com without https or http 
#if your have socks5 using this script bash namefile.sh domain.com 127.0.0.1:2222
source detectcms.sh
if [ ! $1 ];then
	echo "bash $0 example.com"
	echo "bash $0 example.com 127.0.0.1:2020"
	exit 1
fi
echo "Scanning : $1"
if [ $2 ];then
	curl --socks5 $2 -s http://domains.yougetsignal.com/domains.php --data "remoteAddress=$1&key=" > domain
else
	curl -s http://domains.yougetsignal.com/domains.php --data "remoteAddress=$1&key=" > domain
fi
cat domain | grep 'false' > /dev/null;checkblock=$?
if [ $checkblock -eq 0 ];then
echo "Limit Per Day Please Using Socks5 :))"
exit 1
fi
	if [ -f "domain" ]
	then
		ipaddress=`jsonresult remoteIpAddress`
		echo "Ip Server : $ipaddress"
		echo "Domain List : "
		domainresult
		for sites in `cat domainarray.txt`
		do
			cmsy=`detectcms $sites`
			if [ ! $cmsy ];then
				cmsy='Unknown'
			fi
			echo "	[+] $sites $cmsy"
			echo "$sites [$cmsy]" >> sites.txt
		done
	fi
