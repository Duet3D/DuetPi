M561 ;Disable previous bed compesation
M291 P"Start Maunal calibration...Heating up bed and Nozzle" S1
M190 S60
M109 S150
M291 P"This procedure help to calibrate the plane, you will need the calibration tool for setting the height from nozzle to bed" S1
M291 P"Homing" S0
M98 P"0:/sys/homeall.g"
G0 Z0.15
G91
G1 Z10 F300
G90
G1 X540 Y520 F3000
G91
G1 Z-10 F300
G90
M400
M291 P"Set first point" S2 
G91
G1 Z10 F300
G90
G1 X870 Y80 F3000
G91
G1 Z-10 F300
G90
M400
M291 P"Set second point" S2 
G91
G1 Z10 F300
G90
G1 X210 Y80 F3000
G91
G1 Z-10 F300
G90
M291 P"Set third point" S2

M291 P"Restart"

G91
G1 Z10 F300
G90
G1 X540 Y520 F3000
G91
G1 Z-10 F300
G90
M400
M291 P"Set first point" S2 
G91
G1 Z10 F300
G90
G1 X870 Y80 F3000
G91
G1 Z-10 F300
G90
M400
M291 P"Set second point" S2 
G91
G1 Z10 F300
G90
G1 X210 Y80 F3000
G91
G1 Z-10 F300
G90
M291 P"Set third point" S2

M291 P"Finish"
