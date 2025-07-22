; Macro RepRap Firmware - Posizionamento e Controllo Temperatura
; Nome file: posiziona_e_riscalda.g

; === FASE 1: POSIZIONAMENTO ===
; Esegui il posizionamento secondo il G-code fornito
T-1                    ; Deseleziona tutti i tool

; Verifica se gli assi sono già azzerati tramite Object Model
if !move.axes[0].homed || !move.axes[1].homed || !move.axes[2].homed
    ; Almeno un asse non è azzerato - esegui homing
    M291 P"Assi non azzerati rilevati. Esecuzione homing..." R"Homing" S1 T3
    G28                ; Home di tutti gli assi
    M291 P"Homing completato!" R"Completato" S1 T2
else
    ; Tutti gli assi sono già azzerati
    M291 P"Tutti gli assi già azzerati. Salto homing." R"Homing" S1 T2

T0                     ; Seleziona tool 1
G1 Z250 F1000         ; Muovi Z a 250mm con velocità 1000mm/min
G1 X210 Y50 F3000      ; Muovi X a 210mm, Y a 50mm con velocità 3000mm/min

; === FASE 2: RICHIESTA SCELTA TEMPERATURA ===
; Mostra dialog con le opzioni di temperatura
M291 P"Scegli l'operazione desiderata:" R"Controllo Temperatura" S4 K{"Cambia Nozzle","Raffredda"}

; === FASE 3: GESTIONE DELLE SCELTE ===
; Controlla quale opzione è stata selezionata
if input == 0
    ; Opzione 1: Riscalda a 150°C
    M291 P"Riscaldamento a 150°C in corso..." R"Riscaldamento" S1 T5
    M104 S150                ; Imposta temperatura hotend a 150°C
    M109 S150                ; Attendi che raggiunga 150°C
    M291 P"Temperatura 150°C raggiunta!" R"Completato" S1 T3
    
    ; Controlla se c'è filamento caricato in T0 tramite Object Model
    if move.extruders[0].filament != null
        ; Filamento presente - chiedi se scaricare e procedere
        M291 P"ATTENZIONE: Rilevato filamento caricato in T0. Vuoi scaricare il filamento e procedere con la sostituzione del nozzle?" R"Filamento Rilevato" S4 K{"SI","NO"}
        
        if input == 0
            ; Sì, scaricare il filamento e procedere
            M291 P"Scaricamento filamento in corso..." R"Scaricamento" S1 T3
            
            ; Riscalda a temperatura di scaricamento se necessario
            M104 S200                ; Temperatura per lo scaricamento
            M109 S200                ; Attendi temperatura
            
            G1 X550 Y0 F3000
            ; Scarica il filamento
            M291 P"Temperatura raggiunta. Scaricamento automatico filamento..." R"Scaricamento" S1 T5
            M702                     ; Comando scaricamento filamento (unload)
            
            ; Attendi completamento scaricamento senza usare input
            M291 P"Filamento scaricato! Ora puoi procedere con la sostituzione del nozzle." R"Pronto per sostituzione" S1 T3
            G1 X500 Y0 F3000
            ; Abbassa temperatura per sostituzione nozzle
            M104 S150                ; Ritorna a 150°C per sostituzione
            M109 S150                ; Attendi temperatura
            
            G1 X210 Y50 F3000      ; Muovi X a 210mm, Y a 50mm con velocità 3000mm/min

            ; Procedi con sostituzione nozzle
            M291 P"Temperatura impostata a 150°C. Procedi con la sostituzione del nozzle." R"Sostituzione in corso" S1 T0
            M291 P"ATTENZIONE: Usa sempre gli strumenti appropriati e fai attenzione alle superfici calde!" R"Sicurezza" S2 T00
            M291 P"Una volta sostituito il nozzle, premi OK per continuare." R"Attesa" S2
            M291 P"Sostituzione completata!" R"Completato" S1 T3
            
        else
            ; No, non scaricare il filamento
            M291 P"Operazione annullata. Filamento non scaricato." R"Annullato" S1 T3
            
    else
        ; Nessun filamento - permetti sostituzione nozzle
        M291 P"Vuoi sostituire il nozzle?" R"Sostituzione Nozzle" S3
        
        ; Gestione risposta sostituzione nozzle
        if input == 0
            ; Sì, sostituire il nozzle
            M291 P"Procedi con la sostituzione del nozzle. La temperatura è mantenuta a 150°C per facilitare l'operazione." R"Sostituzione in corso" S1 T0
            M291 P"ATTENZIONE: Usa sempre gli strumenti appropriati e fai attenzione alle superfici calde!" R"Sicurezza" S2 T00
            M291 P"Una volta sostituito il nozzle, premi OK per continuare." R"Attesa" S2
            M291 P"Sostituzione completata!" R"Completato" S1 T3
        else
            ; No, non sostituire il nozzle
            M291 P"Sostituzione nozzle annullata." R"Annullato" S1 T2
    
    
elif input == 1
    ; Opzione 4: Raffredda a 90°C
    M291 P"Raffreddamento a 60°C in corso..." R"Raffreddamento" S1 T5
    M104 T0 S60                 ; Imposta temperatura hotend a 90°C
    M109 T0 S60
    M104 T0 S0                 
    M291 P"Temperatura 60°C raggiunta!" R"Completato" S1 T3
    
else
    ; Nessuna selezione o errore
    M291 P"Nessuna opzione selezionata. Macro terminata." R"Annullato" S1 T3

; === FINE MACRO ===
M291 P"Macro completata. Stampante pronta." R"Terminato" S1 T2