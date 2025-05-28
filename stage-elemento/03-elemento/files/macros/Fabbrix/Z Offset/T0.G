M190 S65
M290 S0 R0                                          
M561
G29 S2 
G10 P0 Z0 R150 S150
M558 A2 Z1 K0 B1 P8 C"io4.in" H50 F300:150 T9000 S0.1 R0.5   ; set Z probe type to bltouch and the dive height + speeds
G32 
G1 Z50 F1000
M400
G1 X500 Y300 F2000
T0 P0
M18 C
G30 S-2
G28 C
G1 Z50 F250
T-1 P0
T0
G1 X500 Y300 F2000
G1 Z30 F250
M291 P"Jog nozzle to touch bed" R"Set nozzle to zero" S3 Z1
G10 L1 P0 Z{-(move.axes[2].machinePosition)+0.2}
M500 P10
M558 A2 Z1 K0 B1 P8 C"io4.in" H50 F300:150 T9000 S0.1 R0.5  ; set Z probe type to bltouch and the dive height + speeds
G1 Z300 F1000
