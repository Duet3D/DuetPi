; ========================================
; GENERIC LOAD.G - TEMPLATE FOR 5 TOOLS
; ========================================
; Questo file deve essere adattato per ogni combinazione Tool/Filament
; Esempio: filaments/0_PLA/load.g, filaments/2_PETG/load.g, etc.

; Dialog di selezione estrusore (per 5 tool)
M291 P"Seleziona Estrusore" R"Scelta Estrusore" S4 K{"T0","T1","T2","T3","T4"}

; TOOL 0
if input = 0
    T0
	M564 H1 S0
	G0 X{global.xPT0Position}  Y{-global.yPT0Position} F5000
    M109 S220
    M118 P0 S"Loading TPU"
    M83
    G1 E10 F100
    G1 E70 F200
    G1 E50 F100
    M400


; TOOL 1
elif input = 1
    T1
	M564 H1 S0
	G0 X{global.xPT1Position}  Y{-global.yPT1Position} F5000
    M109 S220
    M118 P0 S"Loading TPU"
    M83
    G1 E10 F100
    G1 E70 F200
    G1 E50 F100
    M400


; TOOL 2
elif input = 2
    T2
	M564 H1 S0
	G0 X{global.xPT2Position}  Y{-global.yPT2Position} F5000
    M109 S220
    M118 P0 S"Loading TPU"
    M83
    G1 E10 F100
    G1 E70 F200
    G1 E50 F100
    M400


; TOOL 3
elif input = 3
    T3
	M564 H1 S0
	G0 X{global.xPT3Position}  Y{-global.yPT3Position} F5000
    M109 S220
    M118 P0 S"Loading TPU"
    M83
    G1 E10 F100
    G1 E70 F200
    G1 E50 F100
    M400


; TOOL 4
elif input = 4
    T4
	M564 H1 S0
	G0 X{global.xPT4Position}  Y{-global.yPT4Position} F5000
    M109 S220
    M118 P0 S"Loading TPU"
    M83
    G1 E10 F100
    G1 E70 F200
    G1 E50 F100
    M400

