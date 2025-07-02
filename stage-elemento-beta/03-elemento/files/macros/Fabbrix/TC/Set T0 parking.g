T-1
M291 R"Calibrazione Parcheggio T0 - Attenzione" P"Con questa procedura perderai gli offset precedenti e rischi di recare danni alla stampante. Effettuala solo se strettamente necessario e se consigliato dall'assistenza" S2
M30 sys/yPT0-offset.g
G28        ;da valutare quando e come far lasciare il tool o cosa farne del tool se serve che sia agganciato
G0 C0 F18000     ;Azzeramento Tool
M291 R"Calibrazione Parcheggio T0 - Homing" P"..."
G0 Z500 F1500
M564 H0 S0 ;disabilita i limiti software e permette di muovere assi non azzerati
G0 X{global.xPT0Position} Y200 F10000
M291 R"Calibrazione Parcheggio T0 - Inserisci tool" P"Posizione T0 sul ToolChange e premi ok" S2
G0 C60 F18000
M291 R"Calibrazione Parcheggio T0 - Inserisci tool" P"Il tool si autosostiene? Assicurati di aver RIMOSSO le MANI dall'area di stampa e premi ok" S2
G0 Y{move.axes[1].min} F500
M564 H0 S0
G91
M291 R"Calibrazione Parcheggio T0" P"Muovi Y fino ad arrivare a toccare il parcheggio" Y1 S3
M400
echo >>"yPT0-offset.g" "set global.yPT0Position = " ^ move.axes[1].min - move.axes[1].machinePosition
G0 C0 F18000
M400
M291 R"Calibrazione Parcheggio T0 Effettuata" P"Testing tool free"
M291 R"Calibrazione Parcheggio T0 test" P"Homing Y"
M98 P"yPT0-offset.g"
G90
G0 Y{move.axes[1].min} F4000
G28 Y
T0 P0
M400
G0 Y0
M291 R"Calibrazione Parcheggio T0 - Tool Test" P"Il tool è correttamente ingaggiato?" S2
T-1