M25
M83            ; relative extruder moves
G91            ; relative positioning
G1 Z5 F360     ; lift Z by 5mm
G90            ; absolute positioning
G1 Y30 F6000
M118 S"Filament T3 End"
