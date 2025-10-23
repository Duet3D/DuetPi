; Macro K1 Calibration con Feedback Utente
; Nome file: k1_calibration_feedback.g
M98 P"0:/macros/Calibration/inputshaping.g"

; === FASE 1: PREPARAZIONE ===
M291 P"Avvio calibrazione K1. Riscaldamento piatto a 55°C..." R"Preparazione K1" S1 T3
;M190 S60                  ; Riscalda piatto a 55°C e attendi
M291 P"Piatto riscaldato! Inizializzazione sistema..." R"Temperatura OK" S1 T2

T-1                       ; Deseleziona tutti i tool
M291 P"Esecuzione input shaping..." R"Input Shaping" S1 T3
M98 P"0:/macros/Calibration/inputshaping.g"
M291 P"Input shaping completato!" R"Completato" S1 T2

M208 X-30:1100 Y-65:605 Z0:620                         ; set minimum and maximum axis limits
; Definizione griglia mesh
M291 P"Configurazione griglia mesh (X0:1080 Y26:520 P20:10)..." R"Setup Mesh" S1 T2

M557 X0:1060 Y-10:600 P20:10                            ; define grid for mesh bed compensation

; === FASE 2: HOMING E CALIBRAZIONE K1 ===
M291 P"Esecuzione homing completo..." R"Homing" S1 T3
G28
M291 P"Homing completato! Avvio calibrazione G32..." R"Homing OK" S1 T2

G32
M291 P"Calibrazione G32 completata!" R"G32 OK" S1 T2

; Setup K1
M117 "K1 CALIB"
M118 P0 S"K1 CALIB" L3
M291 P"Inizializzazione calibrazione K1..." R"K1 Setup" S1 T3

G1 Z50 F2000             ; Posizionamento sicurezza
G1 X{move.axes[0].max/2} Y{move.axes[1].max/2} F3000       ; Posizionamento centrale
M18 C                    ; Rilascia motore C

M291 P"Esecuzione probe K1 iniziale..." R"Probe K1" S1 T2
G30 K0 S-1

M291 P"Configurazione parametri K1 (velocità 0.5, offset -1)..." R"Config K1" S1 T2
M558.1 K1 S0.5



M291 P"Salvataggio configurazione K1..." R"Salvataggio" S1 T2
M500 P31
M501

; === FASE 3: BED LEVELING ===
M291 P"Preparazione bed leveling..." R"Bed Leveling" S1 T3
G28 C
G1 Z50 F1000
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
G29 S3 K1 P"scan_leveling.csv"   ; Salva mesh su file
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