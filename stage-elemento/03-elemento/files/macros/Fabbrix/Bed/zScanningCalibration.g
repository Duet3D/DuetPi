T-1
if sensors.probes[0].value[0] = 1000
	M564 H0 S0
	G1 Z50 F1000
	M564 H1 S1
if move.axes[0].homed != true || move.axes[1].homed != true || move.axes[2].homed != true
	G28 
G31 K0 P25 X0 Y55 Z0.6                         
G31 K1 X0 Y36 Z0.6 
M18 C
G1 X500 Y300
G30 K0 S-3
M558.1 K1 S0.5
M558.2 K1 S-1
G31 K0 P500 X0 Y55 Z-24.30                           
G31 K1 X0 Y36 Z0.6 
