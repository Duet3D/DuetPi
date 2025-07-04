; Complete Sequential Z Calibration OPTIMIZED: Bed Tilt -> Single G30 Reference -> T0 -> T1
; Procedura ottimizzata: Tilt bed -> UN SOLO riferimento G30 -> T0 -> T1

M291 P"CALIBRAZIONE Z OFFSET. Sequenza: 1) Tilt bed 2) Riferimento G30 unico 3) Offset T0 4) Offset T1" R"Calibrazione Z Offset T0 - T1" S2

; Definizione variabili per movimenti custom
; Movimenti Z disponibili: 0.1mm, 0.05mm, 0.02mm, 0.01mm
var zCoarseStep = 5    ; Movimento grossolano
var zMediumStep = 1   ; Movimento medio  
var zFineStep = 0.2     ; Movimento fine
var zUltraFineStep = 0.05 ; Movimento ultra-fine

; ========================================
; FASE 1: PREPARAZIONE SISTEMA
; ========================================
M291 P"FASE 1: PREPARAZIONE SISTEMA. Riscaldamento bed a 65°C..." R"Fase 1: Preparazione" S0 T10

M190 S50
M290 S0 R0
M561                                            ; DISABILITA compensazione bed (CRUCIALE!)
M501
G29 S2                                          ; Cancella heightmap esistente
M104 T0 S180
M104 T1 S180

M291 P"Sistema preparato. Bed a 65°C, offset azzerati, LIVELLAMENTO ATTIVO DISABILITATO per calibrazione precisa." R"Preparazione Completata" S0 T3

; ========================================
; FASE 2: CALIBRAZIONE TILT BED (SENZA COMPENSAZIONE ATTIVA)
; ========================================
M291 P"FASE 2: CALIBRAZIONE TILT BED. Calibrazione del tilt fisico senza compensazione attiva per massima precisione..." R"Fase 2: Tilt Fisico" S0 T5

T-1
M18 C
G32                                             ; Calibra tilt ma NON attiva compensazione
;G28
; Verifica risultati tilt
if abs(move.calibration.initial.deviation) < 0.05
    M291 P{"Tilt fisico ECCELLENTE! Deviazione: " ^ move.calibration.initial.deviation ^ "mm - Procedura su bed piano"} R"Tilt Perfetto" S0 T3
elif abs(move.calibration.initial.deviation) < 0.1
    M291 P{"Tilt fisico BUONO. Deviazione: " ^ move.calibration.initial.deviation ^ "mm - Calibrazione precisa possibile"} R"Tilt Accettabile" S0 T3
else
    M291 P{"Tilt fisico elevato: " ^ move.calibration.initial.deviation ^ "mm. Per calibrazione ottimale, considerare regolazione meccanica bed. Continuare?"} R"Attenzione Tilt" S2
    if input = 1  ; No
        abort "Calibrazione interrotta per deviazione tilt elevata"

; ========================================
; FASE 3: RIFERIMENTO G30 SU BED FISICO NON COMPENSATO
; ========================================
M291 P"FASE 3: RIFERIMENTO G30 SU BED FISICO. Creazione riferimento Z sul bed reale senza compensazioni per calibrazione assoluta..." R"Fase 3: Riferimento Fisico" S0 T5
G1 Z50 F1000
M400
G1 X550 Y300 F2000
M18 C
T0 P0
G30                                      ; Riferimento sul bed FISICO non compensato
T-1 P0
G29 S2

M291 P"Riferimento G30 stabilito sul bed fisico reale. Offset calcolati sulla geometria effettiva del sistema." R"Riferimento Fisico Creato" S0 T3

; ========================================
; FASE 4: CALIBRAZIONE Z OFFSET T0
; ========================================
M291 P"FASE 4: CALIBRAZIONE Z OFFSET T0. Posizionamento T0 senza re-probing..." R"Fase 4: Offset T0" S0 T5

; Preparazione T0 SENZA G30 aggiuntivo
T0 P0
M18 C
G28 C
G1 Z50 F600
T-1 P0
T0
G1 X550 Y300 F2000
G1 Z45 F600
M564 H0 S0

M291 P{"T0 - AVVICINAMENTO GROSSOLANO. MOVIMENTO:" ^ var.zCoarseStep ^ "mm"} R"T0: Avvicinamento" S0 T3

; Loop calibrazione grossolana T0
while true
    M291 R{"T0 Movimento Grossolano " ^ var.zCoarseStep ^ "mm"} P"Scegliere l'azione:" S4 K{"-" ^ var.zCoarseStep ^ "mm","+" ^ var.zCoarseStep ^ "mm","Prossima Fase","CANCELLA"}
    
    if input = 0
        G91
        G1 Z{-var.zCoarseStep} F600
        G90
        M400
        ;M291 P{"T0 GIÙ 0.1mm. Z: " ^ move.axes[2].machinePosition ^ "mm"} R"Movimento" S0 T1
    elif input = 1
        G91
        G1 Z{var.zCoarseStep} F600
        G90
        M400
        ;M291 P{"T0 SU 0.1mm. Z: " ^ move.axes[2].machinePosition ^ "mm"} R"Movimento" S0 T1
    elif input = 2
        break
    elif input = 3
        abort "Calibrazione T0 annullata"

M291 P{"T0 - REGOLAZIONE MEDIA. MOVIMENTO:" ^ var.zMediumStep ^ "mm"} R"T0: Regolazione Media" S0 T3

; Loop calibrazione media T0
while true
    M291 R{"T0 Movimento Medio " ^ var.zMediumStep ^ "mm"} P"Scegliere l'azione:" S4 K{"-" ^ var.zMediumStep ^ "mm","+" ^ var.zMediumStep ^ "mm","Prossima Fase","Fase Precedente","CANCELLA"}
    
    if input = 0
        G91
        G1 Z{-var.zMediumStep} F100
        G90
        M400
        ;M291 P{"T0 GIÙ 0.05mm. Z: " ^ move.axes[2].machinePosition ^ "mm"} R"Movimento" S0 T1
    elif input = 1
        G91
        G1 Z{var.zMediumStep} F100
        G90
        M400
        ;M291 P{"T0 SU 0.05mm. Z: " ^ move.axes[2].machinePosition ^ "mm"} R"Movimento" S0 T1
    elif input = 2
        break
    elif input = 3
        M291 P"Ritorno fase grossolana T0..." R"Ritorno" S0 T2
        continue
    elif input = 4
        abort "Calibrazione T0 annullata"

M291 P{"T0 - REGOLAZIONE FINE. MOVIMENTO:" ^ var.zFineStep ^ "mm"} R"T0: Regolazione Fine" S0 T3

; Loop calibrazione fine T0
while true
    M291 R{"T0 Movimento Fine" ^ var.zFineStep ^ "mm"} P"Scegliere l'azione:" S4 K{"-" ^ var.zFineStep ^ "mm","+" ^ var.zFineStep ^ "mm","Prossima Fase","Fase Precedente","CANCELLA"}
    
    if input = 0
        G91
        G1 Z{-var.zFineStep} F50
        G90
        M400
        ;M291 P{"T0 GIÙ 0.02mm. Z: " ^ move.axes[2].machinePosition ^ "mm"} R"Movimento" S0 T1
    elif input = 1
        G91
        G1 Z{var.zFineStep} F50
        G90
        M400
        ;M291 P{"T0 SU 0.02mm. Z: " ^ move.axes[2].machinePosition ^ "mm"} R"Movimento" S0 T1
    elif input = 2
        break
    elif input = 3
        M291 P"Ritorno fase media T0..." R"Ritorno" S0 T2
        continue
    elif input = 4
        abort "Calibrazione T0 annullata"

M291 P{"T0 - REGOLAZIONE ULTRA-FINE. MOVIMENTO:" ^ var.zUltraFineStep ^ "mm"} R"T0: Ultra-Fine" S0 T3

; Loop calibrazione ultra-fine T0
while true
    M291 R{"T0 Ultra-Fine" ^ var.zUltraFineStep ^ "mm"} P"Nozzle T0 deve toccare LEGGERMENTE il bed:" S4 K{"-" ^ var.zUltraFineStep ^ "mm","+" ^ var.zUltraFineStep ^ "mm","SALVA T0","Fase Precedente","CANCELLA"}
    
    if input = 0
        G91
        G1 Z{-var.zUltraFineStep} F25
        G90
        M400
        ;M291 P{"T0 GIÙ 0.01mm. Z: " ^ move.axes[2].machinePosition ^ "mm"} R"Micro" S0 T1
    elif input = 1
        G91
        G1 Z{var.zUltraFineStep} F25
        G90
        M400
        ;M291 P{"T0 SU 0.01mm. Z: " ^ move.axes[2].machinePosition ^ "mm"} R"Micro" S0 T1
    elif input = 2
        M291 P"Salvataggio offset Z per T0..." R"Salvataggio T0" S0 T3
        G10 L1 P0 Z{-(move.axes[2].machinePosition)}
        M500 P10
        break
    elif input = 3
        M291 P"Ritorno fase fine T0..." R"Ritorno" S0 T2
        continue
    elif input = 4
        abort "Calibrazione T0 annullata"

M291 P"OFFSET T0 SALVATO! Passaggio alla calibrazione T1..." R"T0 Completato" S0 T5


M501

G1 Z50 F600

T1





; ========================================
; FASE 5: CALIBRAZIONE Z OFFSET T1
; ========================================
M291 P"🔧 FASE 5: CALIBRAZIONE Z OFFSET T1. Posizionamento T1 usando lo stesso riferimento..." R"Fase 5: Offset T1" S0 T5

G1 X550 Y300 F2000

M291 P{"T1 - AVVICINAMENTO GROSSOLANO. MOVIMENTO:" ^ var.zCoarseStep ^ "mm"} R"T1: Avvicinamento" S0 T3

; Loop calibrazione grossolana T1
while true
    M291 R{"T1 Movimento Grossolano " ^ var.zCoarseStep ^ "mm"} P"Scegliere l'azione:" S4 K{"-" ^ var.zCoarseStep ^ "mm","+" ^ var.zCoarseStep ^ "mm","Prossima Fase","CANCELLA"}
    
    if input = 0
        G91
        G1 Z{-var.zCoarseStep} F600
        G90
        M400
        ;M291 P{"T1 GIÙ 0.1mm. Z: " ^ move.axes[2].machinePosition ^ "mm"} R"Movimento" S0 T1
    elif input = 1
        G91
        G1 Z{var.zCoarseStep} F600
        G90
        M400
        ;M291 P{"T1 SU 0.1mm. Z: " ^ move.axes[2].machinePosition ^ "mm"} R"Movimento" S0 T1
    elif input = 2
        break
    elif input = 3
        abort "Calibrazione T1 annullata"

M291 P{"T1 - REGOLAZIONE MEDIA. MOVIMENTO:" ^ var.zMediumStep ^ "mm"} R"T1: Regolazione Media" S0 T3

; Loop calibrazione media T1
while true
    M291 R{"T1 Movimento Medio " ^ var.zMediumStep ^ "mm"} P"Scegliere l'azione:" S4 K{"-" ^ var.zMediumStep ^ "mm","+" ^ var.zMediumStep ^ "mm","Prossima Fase","Fase Precedente","CANCELLA"}
    
    if input = 0
        G91
        G1 Z{-var.zMediumStep} F100
        G90
        M400
        ;M291 P{"T1 GIÙ 0.05mm. Z: " ^ move.axes[2].machinePosition ^ "mm"} R"Movimento" S0 T1
    elif input = 1
        G91
        G1 Z{var.zMediumStep} F100
        G90
        M400
        ;M291 P{"T1 SU 0.05mm. Z: " ^ move.axes[2].machinePosition ^ "mm"} R"Movimento" S0 T1
    elif input = 2
        break
    elif input = 3
        M291 P"Ritorno fase grossolana T1..." R"Ritorno" S0 T2
        continue
    elif input = 4
        abort "Calibrazione T1 annullata"

M291 P{"T1 - REGOLAZIONE FINE. MOVIMENTO:" ^ var.zFineStep ^ "mm"} R"T1: Regolazione Fine" S0 T3

; Loop calibrazione fine T1
while true
    M291 R{"T0 Movimento Fine" ^ var.zFineStep ^ "mm"} P"Scegliere l'azione:" S4 K{"-" ^ var.zFineStep ^ "mm","+" ^ var.zFineStep ^ "mm","Prossima Fase","Fase Precedente","CANCELLA"}
    
    if input = 0
        G91
        G1 Z{-var.zFineStep} F50
        G90
        M400
        ;M291 P{"T1 GIÙ 0.02mm. Z: " ^ move.axes[2].machinePosition ^ "mm"} R"Movimento" S0 T1
    elif input = 1
        G91
        G1 Z{var.zFineStep} F50
        G90
        M400
        ;M291 P{"T1 SU 0.02mm. Z: " ^ move.axes[2].machinePosition ^ "mm"} R"Movimento" S0 T1
    elif input = 2
        break
    elif input = 3
        M291 P"Ritorno fase media T1..." R"Ritorno" S0 T2
        continue
    elif input = 4
        abort "Calibrazione T1 annullata"

M291 P{"T1 - REGOLAZIONE ULTRA-FINE. MOVIMENTO:" ^ var.zUltraFineStep ^ "mm"} R"T1: Ultra-Fine" S0 T3

; Loop calibrazione ultra-fine T1
while true
    M291 R{"T1 Ultra-Fine" ^ var.zUltraFineStep ^ "mm"} P"Nozzle T1 deve toccare LEGGERMENTE il bed:" S4 K{"-" ^ var.zUltraFineStep ^ "mm","+" ^ var.zUltraFineStep ^ "mm","SALVA T1","Fase Precedente","CANCELLA"}
    
    if input = 0
        G91
        G1 Z{-var.zUltraFineStep} F25
        G90
        M400
        ;M291 P{"T1 GIÙ 0.01mm. Z: " ^ move.axes[2].machinePosition ^ "mm"} R"Micro" S0 T1
    elif input = 1
        G91
        G1 Z{var.zUltraFineStep} F25
        G90
        M400
        ;M291 P{"T1 SU 0.01mm. Z: " ^ move.axes[2].machinePosition ^ "mm"} R"Micro" S0 T1
    elif input = 2
        M291 P"Salvataggio offset Z per T1..." R"Salvataggio T1" S0 T3
        G10 L1 P1 Z{-(move.axes[2].machinePosition)}
        M500 P10
        break
    elif input = 3
        M291 P"Ritorno fase fine T1..." R"Ritorno" S0 T2
        continue
    elif input = 4
        abort "Calibrazione T1 annullata"

M291 P"OFFSET T1 SALVATO!" R"T1 Completato" S0 T5

; ========================================
; FASE 6: FINALIZZAZIONE E RIATTIVAZIONE COMPENSAZIONE
; ========================================
M291 P"FINALIZZAZIONE: Ripristino configurazione probe e riattivazione compensazione bed..." R"Finalizzazione" S0 T5

M501

; Riattiva la compensazione bed se disponibile
M291 P"Riattivare la compensazione automatica del bed per le stampe future?" R"Riattivazione Compensazione" S4 K{"Si", "No"}
if input = 0  ; Yes
    G29 S1                                      ; Riattiva la heightmap esistente
    M291 P"Compensazione bed riattivata per le stampe." R"Compensazione Attiva" S0 T3
else
    M291 P"Compensazione bed rimane disattivata. Ricordare di attivarla prima delle stampe con G29 S1." R"Compensazione Disattiva" S0 T5

G1 Z100 F1000

T-1

; Test di verifica rapido opzionale
M291 P"Eseguire un test di verifica rapido per entrambi i tool?" R"Test Verifica Finale" S4 K{"Si", "No"}

if input = 0  ; Yes
    M291 P"TEST DI VERIFICA RAPIDO in corso..." R"Test Finale" S0 T5
    
    ; Test T0
    T0
    G1 Z15 F250
    G1 X550 Y300 F2000
    G1 Z0.2 F100
    M291 P"TEST T0: Verificare distanza nozzle-bed. OK?" R"Verifica T0" S4 K{"Si", "No"}
    var t0TestResult = input
    
    ; Test T1
    T1
    G1 Z15 F250
    G1 X550 Y300 F2000
    G1 Z0.2 F100
    M291 P"TEST T1: Verificare distanza nozzle-bed. OK?" R"Verifica T1" S4 K{"Si", "No"}
    var t1TestResult = input
    
    G1 Z50 F1000
    T-1
    
    ; Risultati test
    if var.t0TestResult = 0 && var.t1TestResult = 0
        M291 P"TEST SUPERATO! Entrambi i tool sono perfettamente calibrati!" R"Test Perfetto" S0
    elif var.t0TestResult = 1 && var.t1TestResult = 0
        M291 P"T0 necessita ricalibrare, T1 OK" R"Attenzione T0" S0
    elif var.t0TestResult = 0 && var.t1TestResult = 1
        M291 P"T1 necessita ricalibrare, T0 OK" R"Attenzione T1" S0
    else
        M291 P"Entrambi i tool potrebbero necessitare ricalibrare" R"Attenzione Entrambi" S0

; Messaggio finale
M291 P"CALIBRAZIONE T0 E T1 COMPLETATA!" R"Calibrazione Offest" S0