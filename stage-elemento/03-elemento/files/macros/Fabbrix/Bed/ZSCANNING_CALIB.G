; Macro Setup Probe con Feedback Utente
; Nome file: probe_setup_feedback.g

; === FASE 1: INIZIALIZZAZIONE ===
M291 P"Avvio setup probe. Inizializzazione sistema..." R"Setup Probe" S1 T3
T-1                             ; Deseleziona tutti i tool

; === FASE 2: CONTROLLO STATO PROBE ===
M291 P"Controllo stato probe K0..." R"Controllo Probe" S1 T2
if sensors.probes[0].value[0] = 1000
    ; Probe in stato triggered - necessario reset posizione
    M291 P"ATTENZIONE: Probe in stato triggered. Esecuzione movimento di sicurezza..." R"Probe Triggered" S1 T4
    M564 H0 S0              ; Disabilita controlli temporaneamente
    G1 Z50 F1000           ; Movimento Z di sicurezza
    M564 H1 S1             ; Riabilita controlli
    M291 P"Movimento di sicurezza completato!" R"Sicurezza OK" S1 T2
else
    M291 P"Probe in stato normale. Nessun movimento di sicurezza necessario." R"Probe OK" S1 T2

; === FASE 3: VERIFICA HOMING ===
M291 P"Verifica stato homing assi..." R"Controllo Homing" S1 T2
if move.axes[0].homed != true || move.axes[1].homed != true || move.axes[2].homed != true
    ; Assi non azzerati - esegui homing
    M291 P"Assi non azzerati rilevati. Esecuzione homing completo..." R"Homing Necessario" S1 T3
    G28                    ; Home tutti gli assi
    M291 P"Homing completato!" R"Homing OK" S1 T2
else
    M291 P"Tutti gli assi già azzerati. Salto homing." R"Homing OK" S1 T2

; === FASE 4: PREPARAZIONE PROBE K0 ===
M291 P"Preparazione probe K0..." R"Setup K0" S1 T2
M18 C                      ; Rilascia motore C

M291 P"Posizionamento per probe K0 (X500 Y300)..." R"Posizionamento K0" S1 T2
G1 X{move.axes[0].max/2} Y{move.axes[1].max}

M291 P"Esecuzione probe K0 con offset -3..." R"Probe K0" S1 T3
G30 K0 S-3                 ; Probe K0 con offset -3
M291 P"Probe K0 completato!" R"K0 OK" S1 T2

; === FASE 5: CONFIGURAZIONE PROBE K1 ===
M291 P"Configurazione parametri probe K1..." R"Config K1" S1 T2
M558.1 K1 S0.5            ; Imposta velocità K1 a 0.5mm/s
M558.2 K1 S-1             ; Imposta offset K1 a -1mm
M291 P"Probe K1 configurato: velocità 0.5mm/s, offset -1mm" R"K1 Configurato" S1 T3

; === FASE 6: VERIFICA FINALE ===
M291 P"Posizionamento per verifica finale..." R"Verifica" S1 T2
G1 Z50                    ; Solleva Z di sicurezza
G1 X{move.axes[0].max/2} Y{move.axes[1].max} F2000       ; Posizionamento centrale

M291 P"Esecuzione probe di verifica..." R"Probe Verifica" S1 T3
G30                       ; Probe finale di controllo
M291 P"Probe di verifica completato!" R"Verifica OK" S1 T2

M291 P"Ricaricamento configurazione..." R"Config Finale" S1 T2
M501

; === COMPLETAMENTO ===
M291 P"Setup probe completato! K0 configurato con offset -3, K1 con velocità 0.5mm/s e offset -1mm." R"Setup Completato" S1 T5