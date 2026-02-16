; ==============================================================================
; SUBMACRO CALIBRAZIONE Z OFFSET - TOOL T2
; ==============================================================================

M118 P0 S"====================================================" L3
M118 P0 S"CALIBRAZIONE Z OFFSET T2" L3
M118 P0 S"====================================================" L3
echo >>"eventlog.txt" "INIZIO CALIBRAZIONE T2: "

; Variabili movimento (condivise da main, valori di default)
if !exists(var.zCoarseStep)
    var zCoarseStep = 5
if !exists(var.zMediumStep)
    var zMediumStep = 1
if !exists(var.zFineStep)
    var zFineStep = 0.2
if !exists(var.zUltraFineStep)
    var zUltraFineStep = 0.05

; Preparazione T2
T2 P0
M18 C
G28 C
G1 Z50 F600
T-1 P0
T2
G1 X{move.axes[0].max/2} Y{move.axes[1].max/2} F2000
G1 Z45 F600
M564 H0 S0

M291 P{"T2 - AVVICINAMENTO GROSSOLANO " ^ var.zCoarseStep ^ "mm"} R"T2: Grossolano" S0 T3

; Loop 1: Grossolano
while true
    M291 R{"T2 Grossolano " ^ var.zCoarseStep ^ "mm"} P"Regolare:" S4 K{"-" ^ var.zCoarseStep ^ "mm","+" ^ var.zCoarseStep ^ "mm","Avanti","Annulla"}
    if input = 0
        G91
        G1 Z{-var.zCoarseStep} F600
        G90
        M400
    elif input = 1
        G91
        G1 Z{var.zCoarseStep} F600
        G90
        M400
    elif input = 2
        break
    elif input = 3
        abort "T2 annullato"

M291 P{"T2 - REGOLAZIONE MEDIA " ^ var.zMediumStep ^ "mm"} R"T2: Media" S0 T3

; Loop 2: Media
while true
    M291 R{"T2 Media " ^ var.zMediumStep ^ "mm"} P"Regolare:" S4 K{"-" ^ var.zMediumStep ^ "mm","+" ^ var.zMediumStep ^ "mm","Avanti","Indietro","Annulla"}
    if input = 0
        G91
        G1 Z{-var.zMediumStep} F100
        G90
        M400
    elif input = 1
        G91
        G1 Z{var.zMediumStep} F100
        G90
        M400
    elif input = 2
        break
    elif input = 3
        continue
    elif input = 4
        abort "T2 annullato"

M291 P{"T2 - REGOLAZIONE FINE " ^ var.zFineStep ^ "mm"} R"T2: Fine" S0 T3

; Loop 3: Fine
while true
    M291 R{"T2 Fine " ^ var.zFineStep ^ "mm"} P"Regolare:" S4 K{"-" ^ var.zFineStep ^ "mm","+" ^ var.zFineStep ^ "mm","Avanti","Indietro","Annulla"}
    if input = 0
        G91
        G1 Z{-var.zFineStep} F50
        G90
        M400
    elif input = 1
        G91
        G1 Z{var.zFineStep} F50
        G90
        M400
    elif input = 2
        break
    elif input = 3
        continue
    elif input = 4
        abort "T2 annullato"

M291 P{"T2 - ULTRA-FINE " ^ var.zUltraFineStep ^ "mm"} R"T2: Ultra-Fine" S0 T3

; Loop 4: Ultra-Fine
while true
    M291 R{"T2 Ultra-Fine " ^ var.zUltraFineStep ^ "mm"} P"Tocco leggero bed:" S4 K{"-" ^ var.zUltraFineStep ^ "mm","+" ^ var.zUltraFineStep ^ "mm","SALVA","Indietro","Annulla"}
    if input = 0
        G91
        G1 Z{-var.zUltraFineStep} F25
        G90
        M400
    elif input = 1
        G91
        G1 Z{var.zUltraFineStep} F25
        G90
        M400
    elif input = 2
        M291 P"Salvataggio T2..." R"Salvataggio" S0 T3
        G10 L1 P0 Z{-(move.axes[2].machinePosition)}
        M500 P10
        
        M118 P0 S"T2 OFFSET SALVATO" L3
        M118 P0 S{"Valore: " ^ -(move.axes[2].machinePosition) ^ "mm"} L3
        echo >>"eventlog.txt" "T2 CALIBRATO: " ^ -(move.axes[2].machinePosition) ^ "mm"
        break
    elif input = 3
        continue
    elif input = 4
        abort "T2 annullato"

M291 P"T2 COMPLETATO!" R"T2 OK" S0 T5