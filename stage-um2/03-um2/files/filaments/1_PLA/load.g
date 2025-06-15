M117 "Heating"
M118 P0 S"Heating"
M83
M109 S200
if sensors.filamentMonitors[0].status == "ok"
	M117 "Filament Loaded" 
	M118 P0 S"Loading Filament" 
	G1 E720 F1000
	G1 E32 F100	
	M400
	M117 "Filament Loaded" 
	M118 P0 S"Loaded" 
	;M109 R0
