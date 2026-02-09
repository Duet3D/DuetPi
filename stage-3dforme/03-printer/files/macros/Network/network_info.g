;echo "WIFI - HostName",network.hostname,"Nome Rete",network.interfaces[1].ssid,"Indirizzo",network.interfaces[1].actualIP
;echo "LAN - HostName",network.hostname,"Indirizzo",network.interfaces[0].actualIP
if network.interfaces[1].actualIP != null
    M291 R"Wifi Connection" P{"Wifi Name: " ^ network.interfaces[1].ssid ^ " Address : " ^network.interfaces[1].actualIP} S2
else
    M291 R"Wifi Connection not found" P"See manual for connecting wifi network" S2
if network.interfaces[0].actualIP != null
    M291 R"LAN Connection" P{"Address : " ^network.interfaces[0].actualIP} S2
else
    M291 R"Lan Connection not found" P"See manual for connecting lan network or connect ethernet cable on the rear left of printer" S2
M291 R"HostName" P{"" ^ network.hostname ^ ".local"} S2