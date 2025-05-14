M569 P71.0 S1 D2                                      ; driver 71.0 goes forwards (Y axis)
M569 P72.0 S1 D2 
M915 P71.0 S2 F0 H150 R0
M915 P72.0 S2 F0 H150 R0
M574 Y2 S3		


M400 ; Wait for current moves to finish
G91 ; relative positioning
G1 H2 Z5 F1000    ; lift Z relative to current position
G1 H1 Y900 F3000     ; go back a few mm
G1 H2 Z-5 F000   ; lower Z again
G90 ; absolute positioning
M400

M569 P71.0 S1 D4                                       ; driver 71.0 goes forwards (Y axis)
M569 P72.0 S1 D4                                       ; driver 71.0 goes forwards (Y axis)
