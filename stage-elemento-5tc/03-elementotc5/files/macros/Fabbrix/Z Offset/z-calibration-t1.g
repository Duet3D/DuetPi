; ==============================================================================
; SUBMACRO CALIBRAZIONE Z OFFSET - TOOL T1
; ==============================================================================

M118 P0 S"====================================================" L3
M118 P0 S"CALIBRAZIONE Z OFFSET T1" L3
M118 P0 S"====================================================" L3
echo >>"eventlog.txt" "INIZIO CALIBRAZIONE T1: "

; Variabili movimento (condivise da main, valori di default)
if !exists(var.zCoarseStep)
    var zCoarseStep = 5
if !exists(var.zMediumStep)
    var zMediumStep = 1
if !exists(var.zFineStep)
    var zFineStep = 0.2
if !exists(var.zUltraFineStep)
    var zUltraFineStep = 0.05

; Preparazione T1
T1 P0
M18 C
G28 C
G1 Z50 F600
T-1 P0
T1
G1 X{move.axes[0].max/2} Y{move.axes[1].max/2} F2000
G1 Z45 F600
M564 H0 S0

M291 P{"T1 - AVVICINAMENTO GROSSOLANO " ^ var.zCoarseStep ^ "mm"} R"T1: Grossolano" S0 T3

; Loop 1: Grossolano
while true
    M291 R{"T1 Grossolano " ^ var.zCoarseStep ^ "mm"} P"Regolare:" S4 K{"-" ^ var.zCoarseStep ^ "mm","+" ^ var.zCoarseStep ^ "mm","Avanti","Annulla"}
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
        abort "T1 annullato"

M291 P{"T1 - REGOLAZIONE MEDIA " ^ var.zMediumStep ^ "mm"} R"T1: Media" S0 T3

; Loop 2: Media
while true
    M291 R{"T1 Media " ^ var.zMediumStep ^ "mm"} P"Regolare:" S4 K{"-" ^ var.zMediumStep ^ "mm","+" ^ var.zMediumStep ^ "mm","Avanti","Indietro","Annulla"}
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
        abort "T1 annullato"

M291 P{"T1 - REGOLAZIONE FINE " ^ var.zFineStep ^ "mm"} R"T1: Fine" S0 T3

; Loop 3: Fine
while true
    M291 R{"T1 Fine " ^ var.zFineStep ^ "mm"} P"Regolare:" S4 K{"-" ^ var.zFineStep ^ "mm","+" ^ var.zFineStep ^ "mm","Avanti","Indietro","Annulla"}
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
        abort "T1 annullato"

M291 P{"T1 - ULTRA-FINE " ^ var.zUltraFineStep ^ "mm"} R"T1: Ultra-Fine" S0 T3

; Loop 4: Ultra-Fine
while true
    M291 R{"T1 Ultra-Fine " ^ var.zUltraFineStep ^ "mm"} P"Tocco leggero bed:" S4 K{"-" ^ var.zUltraFineStep ^ "mm","+" ^ var.zUltraFineStep ^ "mm","SALVA","Indietro","Annulla"}
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
        M291 P"Salvataggio T1..." R"Salvataggio" S0 T3
        G10 L1 P0 Z{-(move.axes[2].machinePosition)}
        M500 P10
        
        M118 P0 S"T1 OFFSET SALVATO" L3
        M118 P0 S{"Valore: " ^ -(move.axes[2].machinePosition) ^ "mm"} L3
        echo >>"eventlog.txt" "T1 CALIBRATO: " ^ -(move.axes[2].machinePosition) ^ "mm"
        break
    elif input = 3
        continue
    elif input = 4
        abort "T1 annullato"

M291 P"T1 COMPLETATO!" R"T1 OK" S0 T5