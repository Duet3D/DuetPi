if sensors.gpIn[6].value == 1
    G92 C60
    M118 P0 S"Tool on TC, no home"
else 
    m906 c800
    M915 P0.0 S2 F0 H225 R0			        ; Coupler
    G91                ; relative positioning
    M913 C60
    G1 H1 C-200 F2000 ; move quickly to X axis endstop and stop there (first pass)
    G1 C20 F1000     ; go back a few mm
    G1 H1 C-200 F2000; move slowly to X axis endstop once more (second pass)
    G90                ; absolute positioning
    M913 C100
m906 c1400

