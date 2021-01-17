:local WAN "ether1-WAN";
:local IPv4URL "http://sync.afraid.org/u/Token/";
:local IPv6URL "http://v6.sync.afraid.org/u/Token/";

:delay 90s;

:global currentIPv4 [/ip address get [/ip address find interface=$WAN] address]; #:set IPv4 [:pick [:tostr $IPv4] 0 [:find [:tostr $IPv4] "/"]];
:global currentIPv6 [/ipv6 address get [:pick [/ipv6 address find interface=$WAN] 1] address]; #[:pick $fromArray 0]
:global currentIPv6LinkLocal [/ipv6 address get [:pick [/ipv6 address find interface=$WAN] 0] address];

:log warning "Dynamic DNS: IPv4 $currentIPv4";
/tool fetch mode=http url=$IPv4URL keep-result=no;

:log warning "Dynamic DNS: IPv6 $currentIPv6";
/tool fetch mode=http url=$IPv6URL keep-result=no;

:log warning "IPv6 Link Local $currentIPv6LinkLocal";
