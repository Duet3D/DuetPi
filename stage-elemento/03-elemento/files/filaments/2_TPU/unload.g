if state.status = "processing"
    T1
    M109 S{heat.heaters[1].active}
    M118 P0 S"Unloading TPU"
    M83
    G1 E30 F100
    M106 S255
    G10 T0 S170
    G4 S5
    M116
    G1 E-80 F1000
    G1 E-250 F3000
    M400
    M117 "TPU Unloaded"
    M118 P0 S"TPU Unloaded"
else
    T1
    M117 "Heating for TPU"
    M118 P0 S"Heating for TPU" 
    M83
    M109 S220
    M118 P0 S"Unloading TPU"
    G1 E30 F100
    M106 S255
    G10 T0 S170
    G4 S5
    M116
    G1 E-80 F1000
    G1 E-250 F3000
    M400
    M117 "TPU Unloaded"
    M118 P0 S"TPU Unloaded"
    M117 "Cooling"
    M118 P0 S"Cooling"
    M106 S255
    M109 S41
    M116
    M106 S0
    M118 P0 S"TPU Unloaded on T1"