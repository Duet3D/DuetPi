; Macro K1 Calibration con Feedback Utente
; Nome file: k1_calibration_feedback.g
M98 P"0:/macros/Calibration/inputshaping.g"
M558 K1 F10000 T10000
T-1                       ; Deseleziona tutti i tool

M208 X-30:1100 Y-65:605 Z0:620                         ; set minimum and maximum axis limits
; Definizione griglia mesh
M291 P"Configurazione griglia mesh (X0:1080 Y26:520 P20:10)..." R"Setup Mesh" S1 T2

M557 X0:1060 Y-10:600 P20:10                            ; define grid for mesh bed compensation

; Setup K1
M117 "K1 CALIB"
M118 P0 S"K1 CALIB" L3
M291 P"Inizializzazione calibrazione K1...
M117 "K1 BED CALIBRATING"
M118 P0 S"K1 BED CALIBRATING" L3
M18 C

M291 P"Reset mesh precedente..." R"Reset Mesh" S1 T2
G29 S2                   ; Clear mesh
M290 S0 R0              ; Reset babystep
;M561                    ; Clear bed transform
M18 C

; === FASE 4: SCANSIONE MESH ===
M291 P"Posizionamento per scansione mesh..." R"Posizionamento" S1 T2
G1 X{move.axes[0].max/2} Y{move.axes[1].max/2} F2000
T0 P0                   ; Seleziona T0

M291 P"ATTENZIONE: Inizia scansione mesh K1. Non interrompere il processo!" R"Scansione Mesh" S1 T5
G92 C0                  ; Reset asse C
G29 S0 K1              ; Avvia mesh bed leveling con K1

M291 P"Scansione completata! Salvataggio mesh..." R"Salvataggio Mesh" S1 T3
G29 S3 K1 P"scan_speed.csv"   ; Salva mesh su file
M291 P"Mesh salvata in scan_leveling.csv!" R"Mesh Salvata" S1 T2

; === FASE 5: FINALIZZAZIONE ===
M291 P"Finalizzazione calibrazione..." R"Finalizzazione" S1 T2
G1 Z50                  ; Solleva asse Z
T-1 P0                  ; Deseleziona tool
M18 C                   ; Rilascia motore C

M291 P"Posizionamento finale e probe di verifica..." R"Verifica Finale" S1 T3
G1 X{move.axes[0].max/2} Y{move.axes[1].max/2} F2000
G30                     ; Probe finale di verifica

M208 X-30:1100 Y-10:605 Z0:620                         ; set minimum and maximum axis limits


M291 P"Ricaricamento configurazione finale..." R"Config Finale" S1 T2
M501

; === COMPLETAMENTO ===
M291 P"Calibrazione K1 completata con successo! Mesh bed leveling attivo e configurazione salvata." R"Calibrazione Completata" S1 T5

; Reset display
M117 ""