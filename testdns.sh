##### DNS Servers #####

local_DNS=$(cat /etc/resolv.conf | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' | head -n1 )

export DNS_l=(
"$local_DNS"
1.1.1.1
8.8.8.8
9.9.9.9
195.46.39.39
208.67.222.222
216.146.35.35
64.6.64.6
209.244.0.3
64.81.79.2
216.27.175.2
64.81.45.2
64.81.127.2
64.81.159.2
66.92.159.2
216.254.95.2
)

export DNS_Name_l=(
"Local DNS"
"Cloudflare DNS"
"Google DNS"
"Quad9 DNS"
"SafeDNS"
"Cisco OpenDNS"
"Dyn DNS"
"VeriSign DNS"
"Level 3 DNS"
"dns.sfo1.speakeasy.net"
"dns.atl1.speakeasy.net"
"dns.lax1.speakeasy.net"
"dns.dfw1.speakeasy.net"
"dns.chi1.speakeasy.net"
"dns.wdc1.speakeasy.net"
"dns.nyc1.speakeasy.net"
)

##### Input Sanitization #####

        if [ $# -gt 2 ]; then
                echo "Too many arguments. Please only enter a domain or IP + type (mx, a, etc)."
                exit 1 #Failure
        fi

        if [[ "$1" =~ ^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$ ]]; then
                rdns=1
        else
                rdns=0
        fi

        if [ "$1" = "" ]; then
                echo "No Input Detected"
                exit 1
        fi

        if [ "$2" = "" ]; then
                r_type=a
        else
                if [ "$2" == "mx" ] || [ "$2" == "MX" ] ; then
                        r_type=mx
                else
                        echo "Unknown type detected, defaulting to A records."
                        r_type=a
                fi
        fi
		
	if [ "$r_type" == "mx" ] || [ "$r_type" == "MX" ] && [ "$rdns" -eq "1" ]; then
		echo "You cannot lookup MX records against an IP address."
		exit 1
	fi
		
##### Functions #####

lookup_f()
{
server_name="${DNS_Name_l[$loop_n]}"

lookup_DNS=$(host -4sv -t $r_type $input $dns_server)
lookup_DNS_Success=$?

        if [ "$r_type" == "mx" ] || [ "$r_type" == "MX" ] ; then
                mx=1
        else
				mx=0
                if [ "$rdns" -eq "1" ]; then
			lookup_DNS_IPs=$( echo "$lookup_DNS" | grep -A 1 "ANSWER SECTION" |  grep -o -P '(?<=PTR).*(?=.*)' | awk '{$1=$1};1' | sed 's/\.$//' )
                else
			lookup_DNS_IPs=$( echo "$lookup_DNS" | grep IN | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' )
				fi
        fi

lookup_DNS_time_var=$( echo "$lookup_DNS" | grep "bytes from $dns_server#53" )
lookup_DNS_time=${lookup_DNS_time_var#*in }

if [ $lookup_DNS_Success -eq "0" ]; then
	if [ "$mx" = "1" ] && [ "$rdns" -eq "0" ]; then
		echo "Reply from $dns_server ($server_name):"
		echo "$lookup_DNS" | sed '1,/^;; ANSWER SECTION:$/d' | grep -v "bytes from $dns_server" | sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba'
        echo "Time to query: $lookup_DNS_time"
		echo "------------------------------------------------------------------------"
	fi
	if [ "$mx" = "0" ] && [ "$rdns" -eq "0" ]; then
		echo "Reply from $dns_server ($server_name):"
		echo "$input points to $lookup_DNS_IPs"
		echo "Time to query: $lookup_DNS_time"
		echo ""
	fi
	if [ "$mx" = "0" ] && [ "$rdns" -eq "1" ]; then
		echo "Reply from $dns_server ($server_name):"
		echo "$input rDNS is $lookup_DNS_IPs"
		echo "Time to query: $lookup_DNS_time"
		echo ""
	fi
else
	echo "DNS Lookup Failed against $dns_server"
	echo ""
fi
}

##### Main #####

if [ "$mx" = "1" ]; then
echo "------------------------------------------------------------------------"
fi

export "input=$1"

export loop_n=0

for dns_server in ${DNS_l[@]}; do

lookup_f
((loop_n++))

wait

done
