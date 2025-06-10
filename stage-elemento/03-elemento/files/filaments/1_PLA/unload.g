if state.status = "processing"
    T0
    M117 "Unloading"
    M118 P0 S"Unloading" 
    M83
    M109 S{heat.heaters[1].active}
    G1 E50 F100
    M106 S255
    G10 T0 S170
    G4 S5
    M116
    G1 E-80 F1000
    G1 E-250 F3000
    M400
    M117 "Unloaded"
    M118 P0 S"Unloaded"
else
    T0
    M117 "Unloading"
    M118 P0 S"Unloading" 
    M83
    M109 S{heat.heaters[1].active}
    G1 E50 F100
    M106 S255
    G10 T0 S170
    G4 S5
    M116
    G1 E-80 F1000
    G1 E-250 F3000
    M400
    M117 "Unloaded"
    M118 P0 S"Unloaded"
    M106 S255
    M109 S41
    M106 S0