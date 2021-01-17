:local WAN "ether1-WAN";
:local IPv4URL "http://sync.afraid.org/u/TOKEN/";
:local IPv6URL "http://v6.sync.afraid.org/u/TOKEN/";
:global currentIPv4;
:global currentIPv6;
:global currentIPv6LinkLocal;

:local newIPv4 [/ip address get [/ip address find interface=$WAN] address]; #:set IPv4 [:pick [:tostr $mewIPv4] 0 [:find [:tostr $newIPv4] "/"]];

:local newIPv6 [/ipv6 address get [:pick [/ipv6 address find interface=$WAN] 1] address]; #[:pick $fromArray 0]
:local newIPv6LinkLocal [/ipv6 address get [:pick [/ipv6 address find interface=$WAN] 0] address];

:if ($newIPv4 != $currentIPv4)\
do={
    :log warning "Dynamic DNS: IPv4 $newIPv4";
    :set currentIPv4 $newIPv4;
    /tool fetch mode=http url=$IPv4URL keep-result=no;
}

:if ($newIPv6 != $currentIPv6)\
do={
    :log warning "Dynamic DNS: IPv6 $newIPv6";
    :set currentIPv6 $newIPv6;
    /tool fetch mode=http url=$IPv6URL keep-result=no;
}

:if ($currentIPv6LinkLocal != $newIPv6LinkLocal)\
do={
    :log warning "IPv6 Link Local $newIPv6LinkLocal";
    :set currentIPv6LinkLocal $newIPv6LinkLocal;
}

:log info "Dynamic DNS has been checked";
