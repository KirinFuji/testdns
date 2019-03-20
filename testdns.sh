#!/bin/bash
#testdns - Coded by kfuji
#Primarily used to get a visual of GEO IP/DNS Routing and DNS propagation.

if [ $# -gt 1 ]; then
echo "Too many arguments. Please only enter a domain or IP."
exit 1 #Failure
fi

if [[ "$1" =~ ^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$ ]]; then
#debug#echo "rDNS lookup detected."
echo ""
rdns=1
else
rdns=0
fi

if [ "$1" = "" ]; then
echo "No Input Detected"
exit 1
fi

local_DNS=$(host -4sv -t a $1 )
local_DNS_Success=$?

if [ "$rdns" -eq "1" ]; then
local_DNS_IPs=$( echo "$local_DNS" | grep -A 1 ";; ANSWER SECTION:" |  grep -o -P '(?<=PTR).*(?=.*)' | awk '{$1=$1};1' | sed 's/\.$//' ); else
local_DNS_IPs=$( echo "$local_DNS" | grep IN | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' ); fi

local_DNS_time_var=$( echo "$local_DNS" | grep "bytes from" )
local_DNS_time=${local_DNS_time_var#*in }

if [ $local_DNS_Success -eq 0 ]; then
echo "Local DNS Server reply:"
echo "$local_DNS_IPs"
echo "Time to query: $local_DNS_time"
echo ""
else
echo "Local DNS Lookup Failed"
echo ""
fi

wait

Google=$(host -4sv -t a $1 8.8.8.8 )
Google_Success=$?

if [ "$rdns" -eq "1" ]; then
Google_IPs=$( echo "$Google" | grep -A 1 ";; ANSWER SECTION:" |  grep -o -P '(?<=PTR).*(?=.*)' | awk '{$1=$1};1' | sed 's/\.$//' ); else
Google_IPs=$( echo "$Google" | grep IN | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' ); fi

Google_time_var=$( echo "$Google" | grep "bytes from" )
Google_time=${Google_time_var#*in }

if [ $Google_Success -eq 0 ]; then
echo "Google DNS reply:"
echo "$Google_IPs"
echo "Time to query: $Google_time"
echo ""
else
echo "Google DNS Lookup Failed"
echo ""
fi

wait

Cloudflare=$(host -4sv -t a $1 1.1.1.1 )
Cloudflare_Success=$?

if [ "$rdns" -eq "1" ]; then
Cloudflare_IPs=$( echo "$Cloudflare" | grep -A 1 ";; ANSWER SECTION:" |  grep -o -P '(?<=PTR).*(?=.*)' | awk '{$1=$1};1' | sed 's/\.$//' ); else
Cloudflare_IPs=$( echo "$Cloudflare" | grep IN | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' ); fi

Cloudflare_time_var=$( echo "$Cloudflare" | grep "bytes from" )
Cloudflare_time=${Cloudflare_time_var#*in }

if [ $Cloudflare_Success -eq 0 ]; then
echo "Cloudflare reply:"
echo "$Cloudflare_IPs"
echo "Time to query: $Cloudflare_time"
echo ""
else
echo "Cloudflare DNS Lookup Failed"
echo ""
fi

wait

Quad9=$(host -4sv -t a $1 9.9.9.9 )
Quad9_Success=$?

if [ "$rdns" -eq "1" ]; then
Quad9_IPs=$( echo "$Quad9" | grep -A 1 ";; ANSWER SECTION:" |  grep -o -P '(?<=PTR).*(?=.*)' | awk '{$1=$1};1' | sed 's/\.$//' ); else
Quad9_IPs=$( echo "$Quad9" | grep IN | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' ); fi

Quad9_time_var=$( echo "$Quad9" | grep "bytes from" )
Quad9_time=${Quad9_time_var#*in }

if [ $Quad9_Success -eq 0 ]; then
echo "Quad9 reply:"
echo "$Quad9_IPs"
echo "Time to query: $Quad9_time"
echo ""
else
echo "Quad9 DNS Lookup Failed"
echo ""
fi

wait

Level3=$(host -4sv -t a $1 209.244.0.3 )
Level3_Success=$?

if [ "$rdns" -eq "1" ]; then
Level3_IPs=$( echo "$Level3" | grep -A 1 ";; ANSWER SECTION:" |  grep -o -P '(?<=PTR).*(?=.*)' | awk '{$1=$1};1' | sed 's/\.$//' ); else
Level3_IPs=$( echo "$Level3" | grep IN | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' ); fi

Level3_time_var=$( echo "$Level3" | grep "bytes from" )
Level3_time=${Level3_time_var#*in }

if [ $Level3_Success -eq 0 ]; then
echo "Level3 DNS reply:"
echo "$Level3_IPs"
echo "Time to query: $Level3_time"
echo ""
else
echo "Level3 DNS Lookup Failed"
echo ""
fi

wait

Verisign=$(host -4sv -t a $1 64.6.64.6 )
Verisign_Success=$?

if [ "$rdns" -eq "1" ]; then
Verisign_IPs=$( echo "$Verisign" | grep -A 1 ";; ANSWER SECTION:" |  grep -o -P '(?<=PTR).*(?=.*)' | awk '{$1=$1};1' | sed 's/\.$//' ); else
Verisign_IPs=$( echo "$Verisign" | grep IN | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' ); fi

Verisign_time_var=$( echo "$Verisign" | grep "bytes from" )
Verisign_time=${Verisign_time_var#*in }

if [ $Verisign_Success -eq 0 ]; then
echo "Verisign DNS reply:"
echo "$Verisign_IPs"
echo "Time to query: $Verisign_time"
echo ""
else
echo "Verisign DNS Lookup Failed"
echo ""
fi

wait

DynDNS=$(host -4sv -t a $1 216.146.35.35 )
DynDNS_Success=$?

if [ "$rdns" -eq "1" ]; then
DynDNS_IPs=$( echo "$DynDNS" | grep -A 1 ";; ANSWER SECTION:" |  grep -o -P '(?<=PTR).*(?=.*)' | awk '{$1=$1};1' | sed 's/\.$//' ); else
DynDNS_IPs=$( echo "$DynDNS" | grep IN | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' ); fi

DynDNS_time_var=$( echo "$DynDNS" | grep "bytes from" )
DynDNS_time=${DynDNS_time_var#*in }

if [ $DynDNS_Success -eq 0 ]; then
echo "DynDNS reply:"
echo "$DynDNS_IPs"
echo "Time to query: $DynDNS_time"
echo ""
else
echo "DynDNS Lookup Failed"
echo ""
fi

wait

OpenDNS=$(host -4sv -t a $1 208.67.222.222 )
OpenDNS_Success=$?

if [ "$rdns" -eq "1" ]; then
OpenDNS_IPs=$( echo "$OpenDNS" | grep -A 1 ";; ANSWER SECTION:" |  grep -o -P '(?<=PTR).*(?=.*)' | awk '{$1=$1};1' | sed 's/\.$//' ); else
OpenDNS_IPs=$( echo "$OpenDNS" | grep IN | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' ); fi

OpenDNS_time_var=$( echo "$OpenDNS" | grep "bytes from" )
OpenDNS_time=${OpenDNS_time_var#*in }

if [ $OpenDNS_Success -eq 0 ]; then
echo "OpenDNS reply:"
echo "$OpenDNS_IPs"
echo "Time to query: $OpenDNS_time"
echo ""
else
echo "OpenDNS Lookup Failed"
echo ""
fi

wait

SafeDNS=$(host -4sv -t a $1 195.46.39.39 )
SafeDNS_Success=$?

if [ "$rdns" -eq "1" ]; then
SafeDNS_IPs=$( echo "$SafeDNS" | grep -A 1 ";; ANSWER SECTION:" |  grep -o -P '(?<=PTR).*(?=.*)' | awk '{$1=$1};1' | sed 's/\.$//' ); else
SafeDNS_IPs=$( echo "$SafeDNS" | grep IN | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' ); fi

SafeDNS_time_var=$( echo "$SafeDNS" | grep "bytes from" )
SafeDNS_time=${SafeDNS_time_var#*in }

if [ $SafeDNS_Success -eq 0 ]; then
echo "SafeDNS reply:"
echo "$SafeDNS_IPs"
echo "Time to query: $SafeDNS_time"
echo ""
else
echo "SafeDNS Lookup Failed"
echo ""
fi

#KFuji