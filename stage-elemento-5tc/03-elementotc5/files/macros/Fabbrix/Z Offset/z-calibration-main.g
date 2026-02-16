; ==============================================================================
; CALIBRAZIONE Z OFFSET SEQUENZIALE PRINCIPALE - T0 TO T4
; ==============================================================================
; Versione: 2.0 Modulare
; Configurazione: Tilt bed -> Riferimento G30 unico -> T0-T4 loop
; Ogni tool viene calibrato con la sua submacro

M118 P0 S"====================================================" L3
M118 P0 S"AVVIO CALIBRAZIONE Z OFFSET SEQUENZIALE T0-T4" L3
M118 P0 S"Sistema: Modulare con submacro per ogni tool" L3
M118 P0 S"====================================================" L3
echo >>"eventlog.txt" "CALIBRAZIONE Z T0-T4 AVVIATA: "^ state.time

M291 P"CALIBRAZIONE Z OFFSET T0-T4" R"Calibrazione Z Offset T0-T4" S2

; ==============================================================================
; FASE 1: PREPARAZIONE
; ==============================================================================
M291 P"FASE 1: PREPARAZIONE..." R"Fase 1" S0 T10

M190 S50
M290 S0 R0
M561
M501
G29 S2
M104 T0 S180
M104 T1 S180
M104 T2 S180
M104 T3 S180
M104 T4 S180

M118 P0 S"FASE 1 COMPLETATA" L3
echo >>"eventlog.txt" "FASE 1 COMPLETATA - Sistema pronto"
M291 P"Sistema pronto - Bed 50°C, tutti i tool a 180°C" R"Preparazione OK" S0 T3

; ==============================================================================
; FASE 2: TILT BED
; ==============================================================================
M291 P"FASE 2: TILT BED..." R"Fase 2" S0 T5

T-1
M18 C
G32

if abs(move.calibration.initial.deviation) < 0.05
    M118 P0 S"TILT: ECCELLENTE" L3
    M291 P{"Tilt ECCELLENTE: " ^ move.calibration.initial.deviation ^ "mm"} R"Tilt OK" S0 T3
elif abs(move.calibration.initial.deviation) < 0.1
    M118 P0 S"TILT: BUONO" L3
    M291 P{"Tilt BUONO: " ^ move.calibration.initial.deviation ^ "mm"} R"Tilt Accettabile" S0 T3
else
    M118 P0 S"TILT: ATTENZIONE" L3
    M291 P{"Tilt elevato: " ^ move.calibration.initial.deviation ^ "mm. Continuare?"} R"Attenzione" S2
    if input = 1
        abort "Calibrazione interrotta - Tilt elevato"

; ==============================================================================
; FASE 3: RIFERIMENTO G30
; ==============================================================================
M291 P"FASE 3: RIFERIMENTO G30..." R"Fase 3" S0 T5

G1 Z50 F1000
M400
G1 X{move.axes[0].max/2} Y{move.axes[1].max/2} F2000
M18 C
T0 P0
G30
T-1 P0
G29 S2

M118 P0 S"RIFERIMENTO G30 CREATO" L3
M291 P"Riferimento G30 stabilito" R"Riferimento OK" S0 T3

; ==============================================================================
; FASE 4-8: LOOP CALIBRAZIONE TOOL T0-T4
; ==============================================================================
var toolList = {0, 1, 2, 3, 4}
var currentToolIndex = 0

while currentToolIndex < #toolList
    var currentTool = toolList[currentToolIndex]
    
    M291 P{"Calibrazione T" ^ currentTool ^ " in corso..."} R{"Fase T" ^ currentTool} S0 T3
    
    ; Chiama la submacro per il tool specifico
    M98 P{"z-calibration-t" ^ currentTool ^ ".g"}
    
    currentToolIndex = currentToolIndex + 1
    G4 P2000

; ==============================================================================
; FINALIZZAZIONE
; ==============================================================================
M291 P"Finalizzazione..." R"Finalizzazione" S0 T5

M501

M291 P"Riattivare compensazione bed?" R"Compensazione" S4 K{"Si", "No"}
if input = 0
    G29 S1 P"scan_leveling.csv"
    M118 P0 S"COMPENSAZIONE RIATTIVATA" L3
    M291 P"Compensazione attiva" R"OK" S0 T3
else
    M118 P0 S"COMPENSAZIONE NON ATTIVATA" L3
    M291 P"Ricordare di attivare G29 S1 prima delle stampe" R"Avviso" S0 T5

G1 Z100 F1000
T-1

M118 P0 S"====================================================" L3
M118 P0 S"CALIBRAZIONE Z T0-T4 COMPLETATA!" L3
M118 P0 S{"T0: " ^ tools[0].offsets[2] ^ "mm"} L3
M118 P0 S{"T1: " ^ tools[1].offsets[2] ^ "mm"} L3
M118 P0 S{"T2: " ^ tools[2].offsets[2] ^ "mm"} L3
M118 P0 S{"T3: " ^ tools[3].offsets[2] ^ "mm"} L3
M118 P0 S{"T4: " ^ tools[4].offsets[2] ^ "mm"} L3
M118 P0 S"====================================================" L3
echo >>"eventlog.txt" "CALIBRAZIONE COMPLETATA - Tutti gli offset salvati"

M291 P"CALIBRAZIONE COMPLETATA!" R"Done" S0