if state.status = "processing"
    T1
    M109 S{heat.heaters[1].active}
    M118 P0 S"Loading PLA"
    M83
    G1 E10 F100
    G1 E70 F200
    G1 E50 F100
    M400
else
    T1
    M118 P0 S"Heating for PLA"
    M109 S270
    M118 P0 S"Loading PLA"
    M83
    G1 E10 F100
    G1 E70 F200
    G1 E50 F100
    M400
    M106 S255
    M109 S41
    M116
    M106 S0
M118 P0 S"PLA Loaded on T1"

