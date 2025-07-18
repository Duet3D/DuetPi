;save_babystep.g
; Add babystep to Z offset and make "persistant"
; from https://forum.duet3d.com/topic/16328/baby-stepping-can-it-or-can-it-not-be-permanent/10
; Versione con feedback utente e selezione manuale tool

; Controlla se c'è un babystep attivo
if move.axes[2].babystep != 0
    ; Babystep rilevato - chiedi a quale tool applicarlo
    M291 P"Babystep Z rilevato: {move.axes[2].babystep}mm. A quale tool applicare l'offset?" R"Selezione Tool" S4 K{"Solo T0","Solo T1","Entrambi T0+T1","Annulla"}
    
    ; Gestione della scelta utente
    if input == 0
        ; Solo T0
        M291 P"Applicazione offset solo a T0..." R"Tool T0" S1 T2
        
        ; Disabilita controlli homing temporaneamente
        M564 H0
        G10 P0 Z{tools[0].offsets[2] - move.axes[2].babystep}
        M564 H1
        
        ; Salva configurazione
        M291 P"Scrittura configurazione..." R"Salvataggio" S1 T2
        M500 P10
        M290 R0 S0
        M501
        
        M291 P"Babystep salvato per T0! Nuovo offset Z: {tools[0].offsets[2]}mm" R"Completato T0" S1 T4
        
    elif input == 1
        ; Solo T1
        M291 P"Applicazione offset solo a T1..." R"Tool T1" S1 T2
        
        ; Disabilita controlli homing temporaneamente
        M564 H0
        G10 P1 Z{tools[1].offsets[2] - move.axes[2].babystep}
        M564 H1
        
        ; Salva configurazione
        M291 P"Scrittura configurazione..." R"Salvataggio" S1 T2
        M500 P10
        M290 R0 S0
        M501
        
        M291 P"Babystep salvato per T1! Nuovo offset Z: {tools[1].offsets[2]}mm" R"Completato T1" S1 T4
        
    elif input == 2
        ; Entrambi T0 e T1
        M291 P"Applicazione offset a entrambi i tool T0 e T1..." R"Entrambi Tool" S1 T3
        
        ; Disabilita controlli homing temporaneamente
        M564 H0
        G10 P0 Z{tools[0].offsets[2] - move.axes[2].babystep}
        G10 P1 Z{tools[1].offsets[2] - move.axes[2].babystep}
        M564 H1
        
        ; Salva configurazione
        M291 P"Scrittura configurazione..." R"Salvataggio" S1 T2
        M500 P10
        M290 R0 S0
        M501
        
        M291 P"Babystep salvato per entrambi! T0: {tools[0].offsets[2]}mm | T1: {tools[1].offsets[2]}mm" R"Completato Entrambi" S1 T5
        
    else
        ; Annulla operazione
        M291 P"Operazione annullata dall'utente." R"Annullato" S1 T3
        echo "Babystep save cancelled by user"
    
else
    ; Nessun babystep attivo
    M291 P"Nessun babystep attivo rilevato. Niente da salvare." R"Nessuna Modifica" S1 T3
    echo "No babystep offset. Nothing to save"