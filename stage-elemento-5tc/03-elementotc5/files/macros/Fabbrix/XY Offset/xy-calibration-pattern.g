; ==============================================================================
; CALIBRAZIONE OFFSET XY - PATTERN STAMPATO + MISURAZIONE MANUALE
; ==============================================================================
; Versione: 1.0
; Metodo: T0 stampa 5 punti riferimento -> T1-T4 stampano gli stessi 5 punti
;         -> Misurazione manuale offset con calibro/spessimetro
; Precisione: ±0.1mm

M118 P0 S"====================================================" L3
M118 P0 S"CALIBRAZIONE OFFSET XY - PATTERN METHOD" L3
M118 P0 S"Metodo: Pattern stampato + misurazione manuale" L3
M118 P0 S"====================================================" L3
echo >>"eventlog.txt" "CALIBRAZIONE OFFSET XY AVVIATA: "^ state.time

M291 P"CALIBRAZIONE OFFSET XY. Stampa pattern T0 -> T1-T4 -> Misura offset manualmente con calibro" R"Calibrazione XY" S2

; ==============================================================================
; FASE 1: PREPARAZIONE
; ==============================================================================
M291 P"FASE 1: PREPARAZIONE. Riscaldamento bed e estrusori" R"Fase 1" S0 T10

M190 S60
M290 S0 R0
M561
M501
G29 S2

M104 T0 S200
M104 T1 S200
M104 T2 S200
M104 T3 S200
M104 T4 S200

M109 T0 S200

M118 P0 S"PREPARAZIONE COMPLETATA - T0 pronto a 200°C" L3
M291 P"Sistema pronto. T0 a 200°C, Bed 60°C" R"OK" S0 T3

; ==============================================================================
; FASE 2: STAMPA PATTERN RIFERIMENTO T0 (5 PUNTI)
; ==============================================================================
M291 P"FASE 2: STAMPA PATTERN T0. Stampa 5 punti di riferimento" R"Stampa T0" S0 T5

G28
T0
G1 Z0.3 F1000
M400

M118 P0 S"PATTERN T0 - Stampa 5 punti:" L3
M118 P0 S"1-Centro (150,150) 2-+X (200,150) 3--X (100,150)" L3
M118 P0 S"4-+Y (150,200) 5--Y (150,100)" L3

; PUNTO 1: Centro (150, 150) - PRINCIPALE
G1 X150 Y150 F3000
G1 Z0.2 F100
G1 E15 F300
G1 E-1 F300
G1 Z5 F1000

; PUNTO 2: +X (200, 150)
G1 X200 Y150 F3000
G1 Z0.2 F100
G1 E15 F300
G1 E-1 F300
G1 Z5 F1000

; PUNTO 3: -X (100, 150)
G1 X100 Y150 F3000
G1 Z0.2 F100
G1 E15 F300
G1 E-1 F300
G1 Z5 F1000

; PUNTO 4: +Y (150, 200)
G1 X150 Y200 F3000
G1 Z0.2 F100
G1 E15 F300
G1 E-1 F300
G1 Z5 F1000

; PUNTO 5: -Y (150, 100)
G1 X150 Y100 F3000
G1 Z0.2 F100
G1 E15 F300
G1 E-1 F300
G1 Z5 F1000

G1 Z20 F1000
M400

M118 P0 S"PATTERN T0 STAMPATO - 5 punti visibili" L3
M291 P"PATTERN T0 STAMPATO! 5 punti chiari. Procedere con T1-T4" R"OK" S0 T3

; ==============================================================================
; FASE 3: STAMPA PATTERN PER TOOL T1-T4 (IDENTICI A T0)
; ==============================================================================
var toolList = {1, 2, 3, 4}
var toolIdx = 0

while toolIdx < #toolList
    var currentTool = toolList[toolIdx]
    
    M291 P{"Stampa pattern T" ^ currentTool ^ "..."} R{"Stampa T" ^ currentTool} S0 T3
    
    ; Riscalda tool
    M104 T{currentTool} S200
    M109 T{currentTool} S200
    
    ; Seleziona tool
    T{currentTool}
    G1 Z0.3 F1000
    M400
    
    M118 P0 S{"PATTERN T" ^ currentTool ^ " - Stampa 5 punti"} L3
    
    ; PUNTO 1: Centro (150, 150)
    G1 X150 Y150 F3000
    G1 Z0.2 F100
    G1 E15 F300
    G1 E-1 F300
    G1 Z5 F1000
    
    ; PUNTO 2: +X (200, 150)
    G1 X200 Y150 F3000
    G1 Z0.2 F100
    G1 E15 F300
    G1 E-1 F300
    G1 Z5 F1000
    
    ; PUNTO 3: -X (100, 150)
    G1 X100 Y150 F3000
    G1 Z0.2 F100
    G1 E15 F300
    G1 E-1 F300
    G1 Z5 F1000
    
    ; PUNTO 4: +Y (150, 200)
    G1 X150 Y200 F3000
    G1 Z0.2 F100
    G1 E15 F300
    G1 E-1 F300
    G1 Z5 F1000
    
    ; PUNTO 5: -Y (150, 100)
    G1 X150 Y100 F3000
    G1 Z0.2 F100
    G1 E15 F300
    G1 E-1 F300
    G1 Z5 F1000
    
    G1 Z20 F1000
    M400
    
    M118 P0 S{"PATTERN T" ^ currentTool ^ " STAMPATO"} L3
    echo >>"eventlog.txt" "PATTERN T" ^ currentTool ^ " STAMPATO"
    
    M291 P{"PATTERN T" ^ currentTool ^ " STAMPATO! Verificare sovrapposizione con T0"} R{"OK"} S0 T2
    
    toolIdx = toolIdx + 1

; ==============================================================================
; FASE 4: MISURAZIONE MANUALE OFFSET
; ==============================================================================
M291 P"FASE 4: MISURAZIONE MANUALE. Usare calibro/spessimetro per misurare offset tra T0 e T1-T4" R"Misurazione" S2

; ========== CALIBRAZIONE T1 ==========
M291 P"MISURAZIONE T1: Posizionare il calibro tra punto T0 (centro) e punto T1 (centro). Misurare la distanza in X e Y" R"Misura T1" S2

M291 R"T1 OFFSET X (in mm, decimali ok)" P"Negativo se T1 è a sinistra, Positivo se a destra rispetto a T0" S3
var t1OffsetX = input

M291 R"T1 OFFSET Y (in mm, decimali ok)" P"Negativo se T1 è dietro, Positivo se avanti rispetto a T0" S3
var t1OffsetY = input

M118 P0 S{"T1 MISURATO: X=" ^ var.t1OffsetX ^ " Y=" ^ var.t1OffsetY} L3
M291 P{"T1 offset misurato: X=" ^ var.t1OffsetX ^ "mm Y=" ^ var.t1OffsetY ^ "mm. Salvare?"} R"Conferma T1" S4 K{"Salva","Riesegui misura"}

if input = 0
    G10 L1 P1 X{var.t1OffsetX} Y{var.t1OffsetY}
    M500 P10
    M118 P0 S"T1 OFFSET SALVATO" L3
    echo >>"eventlog.txt" "T1 OFFSET SALVATO: X=" ^ var.t1OffsetX ^ " Y=" ^ var.t1OffsetY
    M291 P"T1 SALVATO!" R"OK" S0 T2

; ========== CALIBRAZIONE T2 ==========
M291 P"MISURAZIONE T2: Misurare offset X e Y tra T0 (centro) e T2 (centro)" R"Misura T2" S2

M291 R"T2 OFFSET X (in mm)" P"Inserire valore" S3
var t2OffsetX = input

M291 R"T2 OFFSET Y (in mm)" P"Inserire valore" S3
var t2OffsetY = input

M118 P0 S{"T2 MISURATO: X=" ^ var.t2OffsetX ^ " Y=" ^ var.t2OffsetY} L3
M291 P{"T2 offset: X=" ^ var.t2OffsetX ^ "mm Y=" ^ var.t2OffsetY ^ "mm. Salvare?"} R"Conferma T2" S4 K{"Salva","Riesegui"}

if input = 0
    G10 L1 P2 X{var.t2OffsetX} Y{var.t2OffsetY}
    M500 P10
    M118 P0 S"T2 OFFSET SALVATO" L3
    echo >>"eventlog.txt" "T2 OFFSET SALVATO: X=" ^ var.t2OffsetX ^ " Y=" ^ var.t2OffsetY
    M291 P"T2 SALVATO!" R"OK" S0 T2

; ========== CALIBRAZIONE T3 ==========
M291 P"MISURAZIONE T3: Misurare offset X e Y tra T0 (centro) e T3 (centro)" R"Misura T3" S2

M291 R"T3 OFFSET X (in mm)" P"Inserire valore" S3
var t3OffsetX = input

M291 R"T3 OFFSET Y (in mm)" P"Inserire valore" S3
var t3OffsetY = input

M118 P0 S{"T3 MISURATO: X=" ^ var.t3OffsetX ^ " Y=" ^ var.t3OffsetY} L3
M291 P{"T3 offset: X=" ^ var.t3OffsetX ^ "mm Y=" ^ var.t3OffsetY ^ "mm. Salvare?"} R"Conferma T3" S4 K{"Salva","Riesegui"}

if input = 0
    G10 L1 P3 X{var.t3OffsetX} Y{var.t3OffsetY}
    M500 P10
    M118 P0 S"T3 OFFSET SALVATO" L3
    echo >>"eventlog.txt" "T3 OFFSET SALVATO: X=" ^ var.t3OffsetX ^ " Y=" ^ var.t3OffsetY
    M291 P"T3 SALVATO!" R"OK" S0 T2

; ========== CALIBRAZIONE T4 ==========
M291 P"MISURAZIONE T4: Misurare offset X e Y tra T0 (centro) e T4 (centro)" R"Misura T4" S2

M291 R"T4 OFFSET X (in mm)" P"Inserire valore" S3
var t4OffsetX = input

M291 R"T4 OFFSET Y (in mm)" P"Inserire valore" S3
var t4OffsetY = input

M118 P0 S{"T4 MISURATO: X=" ^ var.t4OffsetX ^ " Y=" ^ var.t4OffsetY} L3
M291 P{"T4 offset: X=" ^ var.t4OffsetX ^ "mm Y=" ^ var.t4OffsetY ^ "mm. Salvare?"} R"Conferma T4" S4 K{"Salva","Riesegui"}

if input = 0
    G10 L1 P4 X{var.t4OffsetX} Y{var.t4OffsetY}
    M500 P10
    M118 P0 S"T4 OFFSET SALVATO" L3
    echo >>"eventlog.txt" "T4 OFFSET SALVATO: X=" ^ var.t4OffsetX ^ " Y=" ^ var.t4OffsetY
    M291 P"T4 SALVATO!" R"OK" S0 T2

; ==============================================================================
; FASE 5: VERIFICA FINALE (OPZIONALE)
; ==============================================================================
M291 P"FASE 5: Eseguire una stampa test di verifica con tutti i tool sullo stesso punto (150,150)?" R"Verifica" S4 K{"Si","No"}

if input = 0
    M118 P0 S"STAMPA TEST VERIFICA" L3
    
    ; Riscalda tutti
    M104 T1 S200
    M104 T2 S200
    M104 T3 S200
    M104 T4 S200
    
    M109 T1 S200
    M109 T2 S200
    M109 T3 S200
    M109 T4 S200
    
    ; Stampa punto test T0
    T0
    G28
    G1 Z0.3 F1000
    G1 X150 Y150 F3000
    G1 Z0.2 F100
    G1 E10 F300
    G1 E-1 F300
    G1 Z20 F1000
    
    M291 P"T0 stampato. Ora stamperanno T1, T2, T3, T4 nello STESSO PUNTO (150,150). Verificare sovrapposizione" R"Test Start" S2
    
    ; Stampa T1
    T1
    G1 Z0.3 F1000
    G1 X150 Y150 F3000
    G1 Z0.2 F100
    G1 E10 F300
    G1 E-1 F300
    G1 Z20 F1000
    
    M291 P"Verificare: il punto T1 è sovrapposto a T0? Offset OK?" R"Test T1" S4 K{"Si","No"}
    var t1OK = input
    
    ; Stampa T2
    T2
    G1 Z0.3 F1000
    G1 X150 Y150 F3000
    G1 Z0.2 F100
    G1 E10 F300
    G1 E-1 F300
    G1 Z20 F1000
    
    M291 P"Verificare: il punto T2 è sovrapposto a T0? Offset OK?" R"Test T2" S4 K{"Si","No"}
    var t2OK = input
    
    ; Stampa T3
    T3
    G1 Z0.3 F1000
    G1 X150 Y150 F3000
    G1 Z0.2 F100
    G1 E10 F300
    G1 E-1 F300
    G1 Z20 F1000
    
    M291 P"Verificare: il punto T3 è sovrapposto a T0? Offset OK?" R"Test T3" S4 K{"Si","No"}
    var t3OK = input
    
    ; Stampa T4
    T4
    G1 Z0.3 F1000
    G1 X150 Y150 F3000
    G1 Z0.2 F100
    G1 E10 F300
    G1 E-1 F300
    G1 Z20 F1000
    
    M291 P"Verificare: il punto T4 è sovrapposto a T0? Offset OK?" R"Test T4" S4 K{"Si","No"}
    var t4OK = input
    
    G1 Z50 F1000
    T-1
    
    ; Spegni heater
    M109 T0 S0
    M109 T1 S0
    M109 T2 S0
    M109 T3 S0
    M109 T4 S0
    
    ; Risultati
    if var.t1OK = 0 && var.t2OK = 0 && var.t3OK = 0 && var.t4OK = 0
        M118 P0 S"====================================================" L3
        M118 P0 S"TEST VERIFICA: SUCCESSO!" L3
        M118 P0 S"Tutti gli offset XY sono CORRETTI" L3
        M118 P0 S"====================================================" L3
        echo >>"eventlog.txt" "TEST VERIFICA SUPERATO - Offset XY verificati"
        M291 P"TEST SUPERATO! Tutti gli offset XY sono perfetti!" R"Success" S0
    else
        M118 P0 S"====================================================" L3
        M118 P0 S"TEST VERIFICA: ATTENZIONE" L3
        M118 P0 S"Alcuni offset potrebbero necessitare rettifica" L3
        M118 P0 S"====================================================" L3
        echo >>"eventlog.txt" "TEST VERIFICA - Alcuni offset potrebbero necessitare rettifica"
        M291 P"Alcuni offset potrebbero necessitare rettifica. Ripetere misurazione?" R"Attenzione" S0

; ==============================================================================
; FINALIZZAZIONE
; ==============================================================================
M501
G1 Z100 F1000
T-1

M118 P0 S"====================================================" L3
M118 P0 S"CALIBRAZIONE OFFSET XY COMPLETATA!" L3
M118 P0 S"RIEPILOGO OFFSET SALVATI:" L3
M118 P0 S"T0: Riferimento (0.00mm, 0.00mm)" L3
M118 P0 S{"T1: X=" ^ var.t1OffsetX ^ "mm Y=" ^ var.t1OffsetY ^ "mm"} L3
M118 P0 S{"T2: X=" ^ var.t2OffsetX ^ "mm Y=" ^ var.t2OffsetY ^ "mm"} L3
M118 P0 S{"T3: X=" ^ var.t3OffsetX ^ "mm Y=" ^ var.t3OffsetY ^ "mm"} L3
M118 P0 S{"T4: X=" ^ var.t4OffsetX ^ "mm Y=" ^ var.t4OffsetY ^ "mm"} L3
M118 P0 S"====================================================" L3
echo >>"eventlog.txt" "CALIBRAZIONE OFFSET XY COMPLETATA - Offset salvati in config"

M291 P"CALIBRAZIONE OFFSET XY COMPLETATA CON SUCCESSO!" R"Done" S0