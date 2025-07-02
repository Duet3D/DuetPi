M557 X0:1080 Y-10:565 P10:5                            ; define grid for mesh bed compensation
T-1
G32
G1 Z50 F600
M558 A2 Z1 K0 B1 P8 C"io4.in" H5 F300:150 T9000 S0.1 R0.5    ; set Z probe type to bltouch and the dive height + speeds
M561 ;Disable previous bed compesation
G29 S2
T0 P0
G1 X550 Y300 F1000
G30 K0 S-2
G29 S0 K0 
G29 S3 K0 P"probe_leveling.csv"
T-1 P0
G1 Z50 F600    
;T0 P0
;G1 X550 Y300
;G30 K0 S-2
;T-1 P0
M558 A2 Z1 K0 B1 P8 C"io4.in" H35 F300:150 T9000 S0.1 R0.5    ; set Z probe type to bltouch and the dive height + speeds
