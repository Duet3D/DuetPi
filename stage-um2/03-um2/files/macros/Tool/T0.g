M190 S60
M290 S0 R0                                          
M561
G28
G29 S2 
G10 P0 Z0 R150 S150
M400
G1 X120 Y120 F2000
G91
G30 S-2
G1 Z5 F250
M291 P"Jog nozzle to touch bed" R"Set nozzle to zero" S3 Z1
G10 L1 P0 Z{-(move.axes[2].machinePosition)+0.2}
M500 P10
