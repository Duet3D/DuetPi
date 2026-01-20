M118 S"Print End"
M118 P3 S{"Extruded Material T0= " ^ move.extruders[0].rawPosition} ; send high reading to DWC console
M300 S4000 P1000
G4 P500
;NEOPIXEL
M150 S1 U255 P80 F1
M150 S1 R255 U255 B255 P120 F1
M150 S1 R255 P255
