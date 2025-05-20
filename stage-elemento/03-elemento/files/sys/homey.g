M569 P71.0 S1 D2                                      ; driver 71.0 goes forwards (Y axis)
M569 P72.0 S1 D2 
M915 P71.0 S0 F0 H190 R0
M915 P72.0 S0 F0 H190 R0
M574 Y2 S4		

M913 Y100

M564 H0 S0
M400 ; Wait for current moves to finish
G91 ; relative positioning
G1 H2 Z5 F1000    ; lift Z relative to current position
G1 H2 Y-5 F500
G1 H1 Y900 F3000     ; go back a few mm
G1 H2 Z-5 F1000   ; lower Z again
G90 ; absolute positioning
M400

M569 P71.0 S1 D4                                       ; driver 71.0 goes forwards (Y axis)
M569 P72.0 S1 D4                                       ; driver 71.0 goes forwards (Y axis)
