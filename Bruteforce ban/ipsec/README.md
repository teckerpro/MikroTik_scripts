# MikroTik IPsec ban script
This script parses log and add to blacklist IP which caused IPsec errors

This script adds to the blacklist IPv4 addresses which:

- caused IPsec errors like these:
		
		192.0.2.1 failed to get valid proposal.
		192.0.2.1 failed to pre-process ph1 packet (side: 1, status 1).
		192.0.2.1 phase1 negotiation failed.

How to use

Create logging action

	/system logging action
	add memory-lines=60 name=YOUR_ACTION target=memory
	/system logging
	add action=YOUR_ACTION topics=ipsec,error

Create firewall rule and address-list

	/ip firewall address-list add list=YOUR_BLACKLIST
	/ip firewall raw
	add action=drop chain=prerouting comment="Drop from blacklist" in-interface=ether-YOUR_WAN_INTERFACE \
		src-address-list=YOUR_BLACKLIST	

Create script

	/system script
	add dont-require-permissions=no name=ipsecBan owner=admin policy=\
		ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
		source="PUT HERE CODE FROM ipsecBan.rsc"

Setup script

	bufferName is YOUR_ACTION (e.g. ipsecBuffer)
	listName is YOUR_BLACKLIST (e.g blacklist)
	timeout is YOUR_TIMEOUT (e.g. 90d if you want dynamic or leave empty if you want static)

Create scheduler witch your own interval, start-date and start-time

	/system scheduler
	add interval=1d name=ipsecBan on-event="/system script run ipsecBan" policy=\
		ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=oct/01/2018 start-time=00:00:00



