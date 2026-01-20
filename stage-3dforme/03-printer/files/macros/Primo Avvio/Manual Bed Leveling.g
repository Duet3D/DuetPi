M561 ;Disable previous bed compesation
M290 R0 S0
M291 P"Start Maunal calibration.. Heating up bed and Nozzle" S1
M291 P"This procedure help to calibrate the plane, you will need the calibration tool for setting the height from nozzle to bed" S1
M190 S60
M109 S130
M291 P"Homing" S0
M98 P"0:/sys/homeall.g"
G0 Z0.15
G1 X50 Y220 F2000
G91
G1 Z-10 F300
G90
M400
M291 P"Set first point" S2 
G91
G1 Z10 F300
G90
G1 X180 Y220 F2000
G91
G1 Z-10 F300
G90
M400
M291 P"Set second point" S2 
G91
G1 Z10 F300
G90
G1 X180 Y10 F2000
G91
G1 Z-10 F300
G90
M291 P"Set third point" S2
G91
G1 Z10 F300
G90
G1 X50 Y10 F2000
G91
G1 Z-10 F300
G90
M291 P"Set 4 point" S2

M291 P"Restart"

G91
G1 Z10 F300
G90
G1 X50 Y220 F2000
G91
G1 Z-10 F300
G90
M400
M291 P"Set first point" S2 
G91
G1 Z10 F300
G90
G1 X180 Y220 F2000
G91
G1 Z-10 F300
G90
M400
M291 P"Set second point" S2 
G91
G1 Z10 F300
G90
G1 X180 Y10 F2000
G91
G1 Z-10 F300
G90
M291 P"Set third point" S2
G91
G1 Z10 F300
G90
G1 X50 Y10 F2000
G91
G1 Z-10 F300
G90
M291 P"Set 4 point" S2