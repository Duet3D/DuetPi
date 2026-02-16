; ==============================================================================
; Tool T0 Parking Calibration Submacro
; ==============================================================================

M291 R"Calibrazione Parcheggio T0 - AVVERTENZA IMPORTANTE" P"ATTENZIONE: Questa procedura cancellerà tutti gli offset! Procedere esclusivamente se strettamente necessario e sotto supervisione dell'assistenza tecnica." S2
M30 sys/yPT0-offset.g
G28
G0 C0 F6000
M291 R"Calibrazione Parcheggio T0 - Fase di Homing" P"Esecuzione dell'azzeramento degli assi in corso. Attendere il completamento dell'operazione."
G0 Z200 F1500
M564 H0 S0
G0 X{global.xPT0Position} Y200 F10000
M291 R"Calibrazione Parcheggio T0 - Posizionamento Utensile" P"Posizionare manualmente l'utensile T0 sul sistema di cambio utensile. Verificare il corretto allineamento prima di premere OK." S2
G0 C60 F6000
M291 R"Calibrazione Parcheggio T0 - Verifica Stabilità" P"Verificare che l'utensile sia correttamente sostenuto e stabile. RIMUOVERE IMMEDIATAMENTE le mani dall'area di stampa prima di procedere." S2
G0 Y{move.axes[1].min} F3000
M564 H0 S0
G91

while true
    M291 R"Calibrazione T0" P"Avvicinati a 5mm dalle spine di parcheggio" S4 K{"-5mm","+5mm","Prossima Fase","CANCELLA"}
    if input = 0
        G1 Y-5 F600
        G90
        M400
    elif input = 1
        G1 Y5 F600
        G90
        M400
    elif input = 2
        break
    elif input = 3
        abort "Calibrazione TC su T0 annullata"

while true
    M291 R"Calibrazione T0 Media" P"ATTENZIONE! Centra le spine fino a inserirne metà nel tool! ATTENZIONE!" S4 K{"-1mm","+1mm","Prossima Fase","CANCELLA"}
    if input = 0
        G1 Y-1 F400
        G90
        M400
    elif input = 1
        G1 Y1 F400
        G90
        M400
    elif input = 2
        break
    elif input = 3
        abort "Calibrazione TC su T0 annullata"

while true
    M291 R"Calibrazione T0 Fine" P"Inserisci spessimetro tra parcheggio e profilo e muovi il tool fino a sentire resistenza, serra il parcheggio prima di proseguire" S4 K{"-0.1mm","+0.1mm","Salva Parcheggio T0","CANCELLA"}
    if input = 0
        G1 Y-0.1 F200
        G90
        M400
    elif input = 1
        G1 Y0.1 F200
        G90
        M400
    elif input = 2
        break
    elif input = 3
        abort "Calibrazione TC su T0 annullata"

M400
echo >>"yPT0-offset.g" "set global.yPT0Position = " ^ move.axes[1].min - move.axes[1].machinePosition
G0 C0 F6000
M400
M291 R"Calibrazione Parcheggio T0 - Calibrazione Completata" P"Avvio della procedura di test per verificare il corretto rilascio dell'utensile."
M98 P"yPT0-offset.g"
G90
G0 Y{move.axes[1].min} F4000
G28 Y
T0
M400
G0 Y0
M291 R"Calibrazione Parcheggio T0 - Verifica Aggancio" P"Verificare visivamente che l'utensile sia correttamente agganciato e posizionato." S2
T-1
M291 R"Calibrazione Parcheggio T0 - Verifica Parcheggio" P"Verificare che l'utensile sia correttamente parcheggiato nella posizione di riposo." S2
M291 R"Calibrazione Parcheggio T0 - Procedura Terminata" S2 P"La calibrazione del parcheggio per l'utensile T0 è stata completata con successo."