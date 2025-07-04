if state.status = "processing"
    T1
    M109 S{heat.heaters[1].active}
    M118 P0 S"Unloading GFF"
    M83
    G1 E30 F100
    M106 S255
    G10 T0 S170
    G4 S5
    M116
    G1 E-80 F1000
    G1 E-250 F3000
    M400
    M117 "GFF Unloaded"
    M118 P0 S"GFF Unloaded"
else
    T1
    M117 "Heating for GFF"
    M118 P0 S"Heating for GFF" 
    M83
    M109 S270
    M118 P0 S"Unloading GFF"
    G1 E30 F100
    M106 S255
    G10 T0 S220
    G4 S5
    M116
    G1 E-80 F1000
    G1 E-250 F3000
    M400
    M117 "GFF Unloaded"
    M118 P0 S"GFF Unloaded"
    M117 "Cooling"
    M118 P0 S"Cooling"
    M106 S255
    M109 S41
    M116
    M106 S0
    M118 P0 S"GFF Unloaded on T1"