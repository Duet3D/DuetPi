; ========================================
; GENERIC UNLOAD.G - TEMPLATE FOR 5 TOOLS
; ========================================
M292 S3
M291 P"Seleziona Estrusore" R"Scelta Estrusore" S4 K{"T0","T1","T2","T3","T4"}

; TOOL 0
if input = 0
    T0
    M564 H1 S0
	G0 X{global.xPT0Position}  Y{-global.yPT0Position} F5000
    M109 S240
    M118 P0 S"Unloading TPU"
    M83
    G1 E30 F100
    M106 S255
    G10 T0 S170
    G4 S5
    M116
    G1 E-180 F1000
    G1 E-100 F3000
    M400
    M117 "TPU Unloaded"
    M118 P0 S"TPU Unloaded"

; TOOL 1
elif input = 1
    T1
    M564 H1 S0
	G0 X{global.xPT1Position}  Y{-global.yPT1Position} F5000
    M109 S240
    M118 P0 S"Unloading TPU"
    M83
    G1 E30 F100
    M106 S255
    G10 T0 S170
    G4 S5
    M116
    G1 E-180 F1000
    G1 E-100 F3000
    M400
    M117 "TPU Unloaded"
    M118 P0 S"TPU Unloaded"

; TOOL 2
elif input = 2
    T2
    M564 H1 S0
	G0 X{global.xPT2Position}  Y{-global.yPT2Position} F5000
    M109 S240
    M118 P0 S"Unloading TPU"
    M83
    G1 E30 F100
    M106 S255
    G10 T0 S170
    G4 S5
    M116
    G1 E-180 F1000
    G1 E-100 F3000
    M400
    M117 "TPU Unloaded"
    M118 P0 S"TPU Unloaded"

; TOOL 3
elif input = 3
    T3
    M564 H1 S0
	G0 X{global.xPT3Position}  Y{-global.yPT3Position} F5000
    M109 S240
    M118 P0 S"Unloading TPU"
    M83
    G1 E30 F100
    M106 S255
    G10 T0 S170
    G4 S5
    M116
    G1 E-180 F1000
    G1 E-100 F3000
    M400
    M117 "TPU Unloaded"
    M118 P0 S"TPU Unloaded"

; TOOL 4
elif input = 4
    T4
    M564 H1 S0
	G0 X{global.xPT4Position}  Y{-global.yPT4Position} F5000
    M109 S240
    M118 P0 S"Unloading TPU"
    M83
    G1 E30 F100
    M106 S255
    G10 T0 S170
    G4 S5
    M116
    G1 E-180 F1000
    G1 E-100 F3000
    M400
    M117 "TPU Unloaded"
    M118 P0 S"TPU Unloaded"