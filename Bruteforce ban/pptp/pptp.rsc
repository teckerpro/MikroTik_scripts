:local bufferName "pptpBuffer";
:local listName "blacklist";
:local timeout 180d;

:local prevMess "";
:local notFirstRunCheck false;

:foreach line in=[/log find buffer=$bufferName] do={
    :do {
        :local content [/log get $line message];
        :local badIP "";
        :local user "";

        :if ($notFirstRunCheck and\
        ([:find $prevMess "TCP connection established from"] >= 0) and\
        ([:find $content "logged in,"] < 0) )\
        do={
            :set badIP [:pick $prevMess 32 [:len $prevMess]];
            :if ([:find $content "authentication failed"] > 0)\
            do={
                :set user [:pick $content ([:find $content ": user "]+7) [:find $content " authentication failed"]];
                :log warning "Did you make a mistake in PPTP password for $user from $badIP?";
                }

            :if ([:len [/ip firewall address-list find address=$badIP and list=$listName]] <= 0)\
            do={
                /ip firewall address-list add list=$listName address=$badIP timeout=$timeout comment="pptp ban script ($user)";
                :log warning "$badIP has been banned (PPTP $user)";
                }
            }
            :if ($notFirstRunCheck = false) do={ :set notFirstRunCheck true; }

            :set prevMess $content;
        } on-error={ :log error "PPTP ban script has crashed"; }
    }
:log info "PPTP ban script was executed properly";