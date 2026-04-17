; Macro RepRap Firmware - Posizionamento e Controllo Temperatura per T0 e T1
; Nome file: posiziona_e_riscalda.g
; Versione finale con gestione ventole, sicurezza termica e raffreddamento rapido

; === FASE 1: POSIZIONAMENTO ===
T-1                    ; Deseleziona tutti i tool

; Verifica se gli assi sono già azzerati tramite Object Model
if !move.axes[0].homed || !move.axes[1].homed || !move.axes[2].homed
    M291 P"Assi non azzerati rilevati. Esecuzione homing..." R"Homing" S1 T3
    G28                ; Home di tutti gli assi
    M291 P"Homing completato!" R"Completato" S1 T2
else
    M291 P"Tutti gli assi già azzerati. Salto homing." R"Homing" S1 T2
endif

; === FASE 2: SCELTA DELL'ESTRUSORE ===
M291 P"Scegli l'estrusore da utilizzare:" R"Selezione Estrusore" S4 K{"Estrusore T0","Estrusore T1"}

; === FASE 3: GESTIONE IN BASE ALL'ESTRUSORE SELEZIONATO ===
if input == 0
    ; Estrusore T0 selezionato
    T0                     ; Seleziona tool 0
    G1 Z250 F1000          ; Muovi Z a 250mm
    G1 Y50 F3000           ; Muovi Y a 50mm
    G1 X210 F3000          ; Muovi X a 210mm

    ; === FASE 4: RICHIESTA SCELTA TEMPERATURA (T0) ===
    M291 P"Scegli l'operazione desiderata:" R"Controllo Temperatura" S4 K{"Riscalda a 150°C","Raffredda a 60°C"}

    if input == 0
        ; Opzione 0: Riscalda a 150°C (T0)
        M107 P0              ; Spegni ventola T0 prima di riscaldare
        M291 P"Riscaldamento a 150°C in corso..." R"Riscaldamento" S1 T5
        M104 S150                ; Imposta temperatura a 150°C

        ; Controlla se c'è filamento caricato (T0)
        if move.extruders[0].filament != ""
            M291 P"Filamento rilevato. Vuoi scaricarlo?" R"Filamento" S4 K{"SI","NO"}
            if input == 0
                M291 P"Scaricamento filamento..." R"Scaricamento" S1 T3
                M104 S200        ; Riscalda a 200°C per scaricare
                G1 X550 Y0 F3000  ; Muovi in posizione di scarico
                M702             ; Scarica filamento
                M291 P"Filamento scaricato!" R"Completato" S1 T3
                G1 Y50 F3000      ; Torna in posizione Y=50
                G1 X210 F3000     ; Torna in posizione X=210
            endif
        endif

        ; Chiedi se sostituire il nozzle (T0)
        M291 P"Vuoi sostituire il nozzle?" R"Sostituzione Nozzle" S4 K{"SI","NO"}
        if input == 0
            M107 P0              ; Spegni ventola T0 prima di riscaldare a 300°C
            M291 P"ATTENZIONE: Usa guanti termici!" R"Sicurezza" S2 T00
            M291 P"Riscaldamento a 300°C per sostituzione nozzle..." R"Riscaldamento" S1 T5
            M109 S300                ; Attendi 300°C

            M291 P"Raggiunti 300°C. Svitare il nozzle e cliccare OK." R"Sostituzione" S2 T0
            M291 P"Avvitare il nuovo nozzle e cliccare OK." R"Sostituzione" S2 T0

            M291 P"Vuoi raffreddare l'hotend e avviare la ventola?" R"Raffreddamento" S4 K{"SI","NO"}
            if input == 0
                M291 P"Raffreddamento a 60°C e attivazione ventola..." R"Raffreddamento" S1 T5
                M106 P0 S255              ; Attiva ventola T0 al 100%
                M104 S0                  ; Imposta temperatura a 0°C per raffreddamento rapido
                M291 P"Attenzione!! Superficie Calda. Inserisci la calza siliconica protettiva" R"Ripristino Calza Siliconica" S2 T0
                M291 P"Hotend raffreddato e ventola attiva!" R"Completato" S1 T3
            endif
        endif

    else
        ; Opzione 1: Raffredda a 60°C (T0)
        M291 P"Raffreddamento a 60°C in corso..." R"Raffreddamento" S1 T5
        M106 P0 S255             ; Attiva ventola T0 al 100%
        M104 S0                  ; Imposta temperatura a 0°C per raffreddamento rapido
        M291 P"Temperatura 60°C raggiunta e ventola attiva!" R"Completato" S1 T3
    endif

else
    ; Estrusore T1 selezionato
    T1                     ; Seleziona tool 1
    G1 Z250 F1000          ; Muovi Z a 250mm
    G1 Y50 F3000           ; Muovi Y a 50mm
    G1 X210 F3000          ; Muovi X a 210mm

    ; === FASE 4: RICHIESTA SCELTA TEMPERATURA (T1) ===
    M291 P"Scegli l'operazione desiderata:" R"Controllo Temperatura" S4 K{"Riscalda a 150°C","Raffredda a 60°C"}

    if input == 0
        ; Opzione 0: Riscalda a 150°C (T1)
        M107 P1              ; Spegni ventola T1 prima di riscaldare
        M291 P"Riscaldamento a 150°C in corso..." R"Riscaldamento" S1 T5
        M104 T1 S150             ; Imposta temperatura a 150°C

        ; Controlla se c'è filamento caricato (T1)
        if move.extruders[1].filament != ""
            M291 P"Filamento rilevato. Vuoi scaricarlo?" R"Filamento" S4 K{"SI","NO"}
            if input == 0
                M291 P"Scaricamento filamento..." R"Scaricamento" S1 T3
                M104 T1 S200     ; Riscalda a 200°C per scaricare
                G1 X550 Y0 F3000  ; Muovi in posizione di scarico
                M702 T1           ; Scarica filamento
                M291 P"Filamento scaricato!" R"Completato" S1 T3
                G1 Y50 F3000      ; Torna in posizione Y=50
                G1 X210 F3000     ; Torna in posizione X=210
            endif
        endif

        ; Chiedi se sostituire il nozzle (T1)
        M291 P"Vuoi sostituire il nozzle?" R"Sostituzione Nozzle" S4 K{"SI","NO"}
        if input == 0
            M107 P1              ; Spegni ventola T1 prima di riscaldare a 300°C
            M291 P"ATTENZIONE: Usa guanti termici!" R"Sicurezza" S2 T00
            M291 P"Riscaldamento a 300°C per sostituzione nozzle..." R"Riscaldamento" S1 T5
            M109 T1 S300          ; Attendi 300°C

            M291 P"Raggiunti 300°C. Svitare il nozzle e cliccare OK." R"Sostituzione" S2 T0
            M291 P"Avvitare il nuovo nozzle e cliccare OK." R"Sostituzione" S2 T0

            M291 P"Vuoi raffreddare l'hotend e avviare la ventola?" R"Raffreddamento" S4 K{"SI","NO"}
            if input == 0
                M291 P"Raffreddamento a 60°C e attivazione ventola..." R"Raffreddamento" S1 T5
                M106 P1 S255      ; Attiva ventola T1 al 100%
                M104 T1 S0        ; Imposta temperatura a 0°C per raffreddamento rapido
                M291 P"Attenzione!! Superficie Calda. Inserisci la calza siliconica protettiva" R"Ripristino Calza Siliconica" S2 T0
                M291 P"Hotend raffreddato e ventola attiva!" R"Completato" S1 T3
            endif
        endif

    else
        ; Opzione 1: Raffredda a 60°C (T1)
        M291 P"Raffreddamento a 60°C in corso..." R"Raffreddamento" S1 T5
        M106 P1 S255            ; Attiva ventola T1 al 100%
        M104 T1 S0              ; Imposta temperatura a 0°C per raffreddamento rapido
        M291 P"Temperatura 60°C raggiunta e ventola attiva!" R"Completato" S1 T3
    endif
endif

; === FASE 5: FINE MACRO ===
T-1                     ; Rilascia il tool
M291 P"Macro completata. Tool rilasciato. Stampante pronta." R"Terminato" S1 T2
