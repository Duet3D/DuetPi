M300 S2000 P200
G4 P200
M300 S2500 P300
G4 P300
M291 P"Please wait while the nozzle is being heated up" R"Loading ABS" T5 ; Display message
G10 P0 S200:200 ; heat nozzle to 190 degC and wait until reached
M116 ; Wait for the temperatures to be reached
M291 P"Feeding filament..." R"Loading ABS" T5 ; Display new message
M83 ; Extruder to relative mode
G1 E10 F60 ; Feed 10mm of filament at 600mm/min
G1 E270 F100 ; Feed 470mm of filament at 3000mm/min
G1 E20 F60 ; Feed 20mm of filament at 300mm/min
G4 P1000 ; Wait one second
M400 ; Wait for moves to complete
M292 ; Hide the message
G10 S0 ; Turn off the heater again
M300 S2000 P200
G4 P200
M300 S2500 P300
G4 P300