:local bufferName "ipsecBuffer";
:local listName "blacklist";
:local timeout 180d;

:foreach line in=[/log find buffer=$bufferName] do={
    :do {
        :local content [/log get $line message];

        #Bruteforce IPsec
        :if ([:find $content "failed to get valid proposal"] >= 0)\
        do={
            :local position "";
            :local badIP "";
            :set position [:find $content " failed to get valid proposal"];
            :set badIP [:pick $content 0 $position];

            :if ([:len [/ip firewall address-list find address=$badIP and list=$listName]] <= 0)\
            do={
                /ip firewall address-list add list=$listName address=$badIP timeout=$timeout comment="ipsec ban script";
                :log warning "$badIP has been banned (IPsec error)";
            }
        }
    } on-error={ :log error "IPsec ban script has crashed"; }
}
:log info "IPsec ban script was executed properly";