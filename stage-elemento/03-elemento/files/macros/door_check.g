; ===== Macro controllo e blocco porta =====
M291 P"Controllo stato porta..." S0 T2

; Leggi stato porta chiusa/aperta (GPIO 9)
if sensors.gpIn[9].value == 0
    ; Porta aperta - richiedi chiusura
    M291 P"Chiudere la porta per continuare." R"ATTENZIONE: PORTA APERTA!" S3
    
    ; Loop attesa chiusura (max 5 minuti)
    var timeout = 300
    var counter = 0
    
    while sensors.gpIn[9].value == 0 && var.counter < var.timeout
        G4 S1
        set var.counter = {var.counter + 1}
        
        ; Avviso ogni 10 secondi
        if mod(var.counter, 10) == 0
            M291 P{"Attendere chiusura porta... (" ^ var.counter ^ "s)"} S0 T1
    
    ; Verifica timeout
    if sensors.gpIn[9].value == 0
        M291 P"ERRORE: Porta non chiusa! Stampa annullata." R"Timeout Porta" S1
        M292              ; Annulla stampa
        M99               ; Esci dalla macro
else
    M291 P"Porta chiusa ✓" S0 T1

; Verifica blocco porta (GPIO 10)
if sensors.gpIn[10].value == 0
    ; Porta sbloccata - richiedi blocco
    M291 P"Porta NON bloccata!^Bloccare la porta e premere OK." R"Blocco Richiesto" S3
    
    ; Opzionale: attiva blocco automatico
    ; M42 P0 S255        ; Attiva servo/solenoide blocco
    ; G4 S2              ; Attendi 2 secondi
    M1202
    
    ; Loop attesa blocco (max 60 secondi)
    var timeout_lock = 60
    var counter_lock = 0
    
    while sensors.gpIn[10].value == 0 && var.counter_lock < var.timeout_lock
        G4 S1
        set var.counter_lock = {var.counter_lock + 1}
        
        if mod(var.counter_lock, 5) == 0
            M291 P{"Attendere blocco porta... (" ^ var.counter_lock ^ "s)"} S0 T1
    
    ; Verifica finale
    if sensors.gpIn[10].value == 0
        M291 P"AVVISO: Porta ancora sbloccata! Continuare comunque?" R"Conferma" S4
        ; Se premi "No", la stampa viene annullata
else
    M291 P"Porta bloccata ✓" S0 T1

; Conferma finale
M291 P"✓ Porta chiusa e bloccata! Avvio stampa..." S0 T2
M117 Stampa in corso