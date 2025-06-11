if state.status = "processing"
    T1
    M109 S{heat.heaters[1].active}
    M118 P0 S"Unloading PETG"
    M83
    G1 E30 F100
    M106 S255
    G10 T0 S170
    G4 S5
    M116
    G1 E-80 F1000
    G1 E-250 F3000
    M400
    M117 "PETG Unloaded"
    M118 P0 S"PETG Unloaded"
else
    T1
    M117 "Heating for PETG"
    M118 P0 S"Heating for PETG" 
    M83
    M109 S230
    M118 P0 S"Unloading PETG"
    G1 E30 F100
    M106 S255
    G10 T0 S180
    G4 S5
    M116
    G1 E-80 F1000
    G1 E-250 F3000
    M400
    M117 "PETG Unloaded"
    M118 P0 S"PETG Unloaded"
    M117 "Cooling"
    M118 P0 S"Cooling"
    M106 S255
    M109 S41
    M116
    M106 S0
    M118 P0 S"PETG Unloaded on T1"