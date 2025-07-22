T-1
if sensors.probes[0].value[0] = 1000
	M564 H0 S0
	G1 Z50 F1000
	M564 H1 S1
if move.axes[0].homed != true || move.axes[1].homed != true || move.axes[2].homed != true
	G28                    
M18 C
G1 X{move.axes[0].max/2} Y{move.axes[1].max}
G30 K0 S-3
M558.1 K1 S0.5
M558.2 K1 S-1
G1 Z50
G1 X{move.axes[0].max/2} Y{move.axes[1].max/2} 
F2000
G30
M501    
