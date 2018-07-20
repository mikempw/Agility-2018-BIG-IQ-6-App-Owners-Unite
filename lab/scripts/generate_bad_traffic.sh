#!/bin/bash
# Uncomment set command below for code debuging bash
# set -x

already=$(ps -ef | grep $0 | grep bash | grep -v grep | wc -l)
if [  $already -gt 3 ]; then
    echo "The script is already running $already time."
    exit 1
fi

# Test Websites
sitefqdn[1]="site4.example.com"
siteport[1]="80"
sitepages[1]="%windir% %APPDATA% fake_login_page.html?textRedirect=google.com fake_login_page.html?username=rob&?password=testme"
sitefqdn[2]="site1.example.com"
siteport[2]="80"
sitepages[2]="privatedata.html badlinks.html calc.exe %windir% %APPDATA% fake_login_page.html?textRedirect=google.com fake_login_page.html?username=rob&?password=testme %windir% %APPDATA% fake_login_page.html?textRedirect=google.com fake_login_page.html?username=rob&?password=testme"
sitefqdn[3]="site1.example.com"
siteport[3]="443"
sitepages[3]="${sitepages[2]}"
sitefqdn[4]="site1.example.com"
siteport[4]="8081"
sitepages[4]="${sitepages[2]}"
sitefqdn[5]="site2.example.com"
siteport[5]="80"
sitepages[5]="${sitepages[2]}"
sitefqdn[6]="site2.example.com"
siteport[6]="443"
sitepages[6]="${sitepages[2]}"
sitefqdn[7]="site2.example.com"
siteport[7]="8081"
sitepages[7]="${sitepages[2]}"
sitefqdn[8]="site3.example.com"
siteport[8]="80"
sitepages[8]="${sitepages[2]}"
sitefqdn[9]="site3.example.com"
siteport[9]="443"
sitepages[9]="${sitepages[2]}"
sitefqdn[10]="site3.example.com"
siteport[10]="8081"
sitepages[10]="${sitepages[2]}"

# get length of the array
arraylength=${#sitefqdn[@]}

# Browser's list
browser[1]="Mozilla/5.0 (compatible; MSIE 7.01; Windows NT 5.0)"
browser[2]="Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/7.0; rv:11.0; Trident/7.0)"
browser[3]="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36"
browser[4]="Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20100101 Firefox/7.0.1"
browser[5]="Mozilla/4.0 (compatible; MSIE 9.0; Windows NT 6.1)"
browser[6]="Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.0; Trident/5.0)"
browser[7]="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.89 Safari/537.36"
browser[8]="Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36 OPR/43.0.2442.991"
browser[9]="Mozilla/5.0 (Linux; Android 4.2.1; en-us; Nexus 5 Build/JOP40D) AppleWebKit/535.19 (KHTML, like Gecko; googleweblight) Chrome/38.0.1025.166 Mobile Safari/535.19"
browser[10]="Mozilla/5.0 (Linux; Android 6.0.1; vivo 1603 Build/MMB29M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.83 Mobile Safari/537.36"
browser[11]="Mozilla/5.0 (Linux; U; Android 4.0.4; pt-br; MZ608 Build/7.7.1-141-7-FLEM-UMTS-LA) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Safari/534.30"
browser[12]="Mozilla/5.0 (Linux; Android 7.0; SM-J730GM Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.111 Mobile Safari/537.36"
browser[13]="Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1"
browser[14]="Mozilla/5.0 (iPad; CPU OS 10_2_1 like Mac OS X) AppleWebKit/602.4.6 (KHTML, like Gecko) Version/10.0 Mobile/14D27 Safari/602.1"
browser[15]="Mozilla/5.0 (iPhone; CPU iPhone OS 9_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13E188a Safari/601.1"
browser[16]="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.1 Safari/603.1.30"
browser[17]="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/601.7.7 (KHTML, like Gecko) Version/9.1.2 Safari/601.7.7"
browser[18]="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36"
browser[19]="Mozilla/5.0 (BlackBerry; U; BlackBerry 9320; en) AppleWebKit/534.11+ (KHTML, like Gecko) Version/7.1.0.714 Mobile Safari/534.11+"
browser[20]="Opera/9.63 (X11; FreeBSD 7.1-RELEASE i386; U; en) Presto/2.1.1"
browser[21]="Mozilla/5.0 (Mobile; Windows Phone 8.1; Android 4.0; ARM; Trident/7.0; Touch; rv:11.0; IEMobile/11.0; NOKIA; Lumia 520) like iPhone OS 7_0_3 Mac OS X AppleWebKit/537 (KHTML, like Gecko) Mobile Safari/537"

arraylengthbrowser=${#sitefqdn[@]}


for (( i=1; i<${arraylength}+1; i++ ));
do
  if [ ! -z "${sitefqdn[$i]}" ]; then
	# Only generat traffic on alive VIP
	ip=$(ping -c 1 -w 1 ${sitefqdn[$i]} | grep PING | awk '{ print $3 }')
	timeout 1 bash -c "cat < /dev/null > /dev/tcp/${ip:1:-1}/${siteport[$i]}"
	if [  $? == 0 ]; then
				
		echo -e "\n# site $i ${sitefqdn[$i]} curl traffic gen (${sitepages[$i]})"
		
		# add random number for loop
		r=`shuf -i 20-80 -n 1`;
		for k in `seq 1 $r`; do
			for j in ${sitepages[$i]}; do
		
				#Randome IP
				source_ip_address=$(dd if=/dev/urandom bs=4 count=1 2>/dev/null | od -An -tu1 | sed -e 's/^ *//' -e 's/  */./g')
				source_ip_address2=$(dd if=/dev/urandom bs=4 count=1 2>/dev/null | od -An -tu1 | sed -e 's/^ *//' -e 's/  */./g')
				
				# add random number for browsers
				rb=`shuf -i 1-$arraylengthbrowser -n 1`;
					
				echo -e "\n# site $i curl traffic gen ${sitefqdn[$i]}"
				if [  ${siteport[$i]} == 443 ]; then
					/usr/local/bin/curl -k -s -m 4 -o /dev/null --header "X-Forwarded-For: $source_ip_address"  -A "${browser[$rb]}" -w "$j\tstatus: %{http_code}\tbytes: %{size_download}\ttime: %{time_total}\n" https://${sitefqdn[$i]}/$j
				else
					/usr/local/bin/curl -s -m 4 -o /dev/null --header "X-Forwarded-For: $source_ip_address"  -A "${browser[$rb]}" -w "$j\tstatus: %{http_code}\tbytes: %{size_download}\ttime: %{time_total}\n" http://${sitefqdn[$i]}/$j
				fi
				echo "-X GET \"http://${sitefqdn[$i]}:${siteport[$i]}/$j\"" >> /home/f5/scripts/curl$i.txt
				echo "-X FETCH \"http://${sitefqdn[$i]}:${siteport[$i]}/$j\"" >> /home/f5/scripts/curl$i.txt
				echo "-X PATCH \"http://${sitefqdn[$i]}:${siteport[$i]}/$j\"" >> /home/f5/scripts/curl$i.txt
				echo "-X POST \"http://${sitefqdn[$i]}:${siteport[$i]}/$j\"" >> /home/f5/scripts/curl$i.txt
			done	
		done

		# cpbNorEaster.py script
		/home/f5/scripts/cpbNorEaster.py -v ${sitefqdn[$i]}:${siteport[$i]} -f /home/f5/scripts/curl$i.txt
		rm -f /home/f5/scripts/curl*.txt

		echo -e "\n# site $i ${sitefqdn[$i]} nmap"
		
		/usr/bin/nmap --system-dns -p ${siteport[$i]} -script http-sql-injection -T5 -Pn ${sitefqdn[$i]}
		/usr/bin/nmap --system-dns -p ${siteport[$i]} -script http-waf-detect -T4 -Pn ${sitefqdn[$i]}
		/usr/bin/nmap --system-dns -p ${siteport[$i]} -script http-enum -T5 -Pn ${sitefqdn[$i]}
		/usr/bin/nmap --system-dns -p ${siteport[$i]} -script http-generator -T4 -Pn ${sitefqdn[$i]}
		
	fi
  fi
done

