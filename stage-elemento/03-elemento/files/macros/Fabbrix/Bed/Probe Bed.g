M557 X0:1060 Y-10:565 P10:5                            ; define grid for mesh bed compensation
T-1
G28
G32
G1 Z50 F600
;M561 ;Disable previous bed compesation
G29 S2
T0 P0
G1 X{move.axes[0].max/2} Y{move.axes[1].max} F1000
M18 C
G92 C0
;G30 K0
G29 S0 K0 
G29 S3 K0 P"probe_leveling.csv"
T-1 P0
G1 Z50 F600    
M18 C
G1 X{move.axes[0].max/2} Y{move.axes[1].max} F2000
G30
M501