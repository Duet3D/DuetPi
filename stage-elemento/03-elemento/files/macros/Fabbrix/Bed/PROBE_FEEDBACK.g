; Macro Probe Leveling con Feedback Utente
; Nome file: probe_leveling_feedback.g

; === FASE 1: CONFIGURAZIONE GRIGLIA ===
M291 P"Avvio probe leveling. Configurazione griglia mesh..." R"Setup Probe Leveling" S1 T3
M557 X0:1060 Y-10:565 P10:5                            ; define grid for mesh bed compensation
M291 P"Griglia configurata: X0:1060 Y-10:565 con 10x5 punti (50 punti totali)" R"Griglia OK" S1 T3

; === FASE 2: PREPARAZIONE ASSI ===
M291 P"Preparazione sistema..." R"Preparazione" S1 T2
T-1                             ; Deseleziona tutti i tool

M291 P"Esecuzione homing completo..." R"Homing" S1 T3
G28
M291 P"Homing completato!" R"Homing OK" S1 T2

M291 P"Esecuzione calibrazione G32..." R"Calibrazione G32" S1 T3
G32
M291 P"Calibrazione G32 completata!" R"G32 OK" S1 T2

; === FASE 3: POSIZIONAMENTO E RESET ===
M291 P"Posizionamento asse Z di sicurezza..." R"Posizionamento" S1 T2
G1 Z50 F600

M291 P"Reset mesh precedente..." R"Reset Mesh" S1 T2
;M561 ;Disable previous bed compesation
G29 S2                          ; Clear mesh bed compensation

; === FASE 4: PREPARAZIONE PROBE ===
M291 P"Preparazione probe per scansione..." R"Setup Probe" S1 T2
T0 P0                           ; Seleziona tool T0

M291 P"Posizionamento centrale piatto..." R"Posizionamento" S1 T2
G1 X{move.axes[0].max/2} Y{move.axes[1].max} F1000
M18 C                           ; Rilascia motore C

M291 P"Reset asse C e preparazione probe..." R"Reset Asse C" S1 T2
G92 C0                          ; Reset posizione asse C
;G30 K0

; === FASE 5: SCANSIONE MESH ===
M291 P"ATTENZIONE: Avvio scansione mesh con probe K0. Processo di circa 50 punti in corso..." R"Scansione Probe" S1 T5
G29 S0 K0                       ; Avvia mesh bed leveling con probe K0

M291 P"Scansione completata! Salvataggio mesh su file..." R"Salvataggio" S1 T3
G29 S3 K0 P"probe_leveling.csv" ; Salva mesh su file CSV
M291 P"Mesh salvata in probe_leveling.csv!" R"File Salvato" S1 T2

; === FASE 6: FINALIZZAZIONE ===
M291 P"Finalizzazione probe leveling..." R"Finalizzazione" S1 T2
T-1 P0                          ; Deseleziona tool
G1 Z50 F600                     ; Solleva asse Z
M18 C                           ; Rilascia motore C

M291 P"Posizionamento finale e probe di verifica..." R"Verifica Finale" S1 T3
G1 X{move.axes[0].max/2} Y{move.axes[1].max} F2000
G30                             ; Probe finale di controllo

M291 P"Ricaricamento configurazione..." R"Config Finale" S1 T2
M501

; === COMPLETAMENTO ===
M291 P"Probe leveling completato con successo! Mesh bed compensation attivo con 50 punti di misurazione." R"Leveling Completato" S1 T5