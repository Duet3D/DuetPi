    T1
	M564 H1 S0
	G0 X{global.xPT1Position}  Y{-global.yPT1Position} F5000
    M109 S260
    M118 P0 S"Unloading GFF"
    M83
    G1 E30 F100
    M106 S255
    G10 T1 S220
    G4 S5
    M116
    G1 E-180 F1000
    G1 E-100 F3000
    M400
    M117 "GFF Unloaded"
    M118 P0 S"GFF Unloaded"