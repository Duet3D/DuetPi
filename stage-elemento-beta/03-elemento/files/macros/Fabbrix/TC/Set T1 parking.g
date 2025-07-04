T-1
M291 R"Calibrazione Parcheggio T1 - Attenzione" P"Con questa procedura perderai gli offset precedenti e rischi di recare danni alla stampante. Effettuala solo se strettamente necessario e se consigliato dall'assistenza" S2
M30 sys/yPT1-offset.g
G28        ;da valutare quando e come far lasciare il tool o cosa farne del tool se serve che sia agganciato
G0 C0 F18000     ;Azzeramento Tool
M291 R"Calibrazione Parcheggio T1 - Homing" P"..."
G0 Z200 F1500
M564 H0 S0 ;disabilita i limiti software e permette di muovere assi non azzerati
G0 X{global.xPT1Position} Y200 F10000
M291 R"Calibrazione Parcheggio T1 - Inserisci tool" P"Posiziona T1 sul ToolChange e premi ok" S2
G0 C60 F18000
M291 R"Calibrazione Parcheggio T1 - Inserisci tool" P"Il tool si autosostiene? Assicurati di aver RIMOSSO le MANI dall'area di stampa e premi ok" S2
G0 Y{move.axes[1].min} F3000
M564 H0 S0
G91
M291 R"Calibrazione Parcheggio T1" P"Muovi Y fino ad arrivare a sentire pressione sullo spessimetro e serra il parcheggio" Y1 S3
M400
echo >>"yPT1-offset.g" "set global.yPT1Position = " ^ move.axes[1].min - move.axes[1].machinePosition
G0 C0 F18000
M400
M291 R"Calibrazione Parcheggio T1 Effettuata" P"Testing tool free"
M291 R"Calibrazione Parcheggio T1 test" P"Homing Y"
M98 P"yPT1-offset.g"
G90
G0 Y{move.axes[1].min} F4000
G28 Y
T1 P0
M400
G0 Y0
M291 R"Calibrazione Parcheggio T - Tool Test" P"Il tool è correttamente ingaggiato?" S2
T-1
M291 R"Calibrazione Parcheggio T - Tool Test" P"Il tool è correttamente parcheggiato?" S2
M291 R"Calibrazione Parcheggio T1 terminata" S2 P" "