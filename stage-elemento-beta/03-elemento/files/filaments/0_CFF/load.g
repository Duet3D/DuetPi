if state.status = "processing"
    T0
    M109 S{heat.heaters[1].active}
    M118 P0 S"Loading CFF"
    M83
    G1 E10 F100
    G1 E70 F200
    G1 E50 F100
    M400
else
    T0
    M118 P0 S"Heating for CFF"
    M109 S220
    M118 P0 S"Loading CFF"
    M83
    G1 E10 F100
    G1 E70 F200
    G1 E50 F100
    M400
    M106 S255
    M109 S41
    M116
    M106 S0
M118 P0 S"CFF Loaded on T0"

