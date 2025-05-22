M190 S65
M290 S0 R0                                          
M561
G29 S2 
G10 P1 Z0 R150 S150
M558 A1 Z1 K0 B0 P8 C"io4.in" H50 F500:250 T9000 R1 ; set Z probe type to bltouch and the dive height + speeds
G32 
G1 Z50 F1000
M400
G1 X500 Y300 F2000
T0 P0
G30 S-1
G1 Z50 F250
T-1 P0
T1
G1 X500 Y300 F2000
G1 Z50 F250
M291 P"Jog nozzle to touch bed" R"Set nozzle to zero" S3 Z1
G10 L1 P1 Z{-(move.axes[2].machinePosition)}
M500 P10
M558 A1 Z1 K0 B0 P8 C"io4.in" H50 F500:250 T9000 R2 ; set Z probe type to bltouch and the dive height + speeds
G1 Z300 F1000