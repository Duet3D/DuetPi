; homeall.g
; called to home all axes
if sensors.probes[0].value[0] = 1000
	M564 H0 S0
	G1 Z50 F1000
	M564 H1 S1
M98 P"homey.g"
M98 P"homex.g"
T-1
M18 C
M98 P"homez.g"
