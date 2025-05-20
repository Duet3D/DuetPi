M190 S60
T-1 P0
M98 P"0:/macros/Calibration Setting Unlock/Medium Setting.g"
G32
M117 "K1 CALIB"
M118 P0 S"K1 CALIB" L3
G1 Z100 F2000
M18 C
G1 X500 Y300 F3000
G30 K0 S-1
M558.1 K1 S0.5
M558.2 K1 S-1
G28 C
G1 Z55 F1000
M117 "K1 BED CALIBRATING"
M118 P0 S"K1 BED CALIBRATING" L3
M18 C
G29 S2
M290 S0 R0
M561
M18 C
G1 X500 Y300 F2000
G30 K0 S-1
G92 C0 
G29 S0 K1
G29 S3 P"scan_leveling.csv"       ; Save the current height map to file "usual.csv"
G91
G0 Z150