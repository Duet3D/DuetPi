; Macro per la gestione degli errori del MFM
; Parametri P:
; 2 = noDataReceived
; 3 = noFilament
; 4 = tooLittleMovement
; 5 = tooMuchMovement
; 6 = SensorError
; 7 = Magnet too weak
; 8 = Magnet too strong

; Inizializza il contatore se non esiste
if !exists(global.tooLittleMovementCount)
    global tooLittleMovementCount = 0

; Gestione degli errori
if param.P == 2 || param.P == 6
    echo "Filament Sensor Error: " ^ param.P ^ " sensor: " ^ param.D ^ " - continue printing"
    M99 ; esci senza fare nulla

if param.P == 3
    echo "Filament Sensor " ^ param.D ^ ": No filament detected - Possible Reasons: Filament empty or not loaded."
    M291 P{"Filament Sensor " ^ param.D ^ ": No filament detected - Possible Reasons: Filament empty or not loaded."} S1 T0
    M25 ; pausa la stampa
    M99

if param.P == 4 ; tooLittleMovement
    if !exists(global.mfmcalibration) || global.mfmcalibration == false
        set global.tooLittleMovementCount = global.tooLittleMovementCount + 1
        echo "Filament Sensor " ^ param.D ^ ": Too little filament movement detected. Count: " ^ global.tooLittleMovementCount ^ "/5"
        if global.tooLittleMovementCount >= 5
            echo "Filament Sensor " ^ param.D ^ ": Too little filament movement detected 5 times - Possible Reasons: Filament empty, grinding, or clogged nozzle."
            M291 P{"Filament Sensor " ^ param.D ^ ": Too little filament movement detected 5 times - Possible Reasons: Filament empty, grinding, or clogged nozzle."} S1 T0
            M25 ; pausa la stampa
            set global.tooLittleMovementCount = 0 ; resetta il contatore
    M99

if param.P == 5 ; tooMuchMovement
    if !exists(global.mfmcalibration) || global.mfmcalibration == false
        echo "Filament Sensor " ^ param.D ^ ": Too much filament movement - Possible Reasons: Spool skipped or filament pushed into PTFE tube."
        M291 P{"Filament Sensor " ^ param.D ^ ": Too much filament movement - Possible Reasons: Spool skipped or filament pushed into PTFE tube."} S1 T0
        M25 ; pausa la stampa

if param.P == 7 || param.P == 8
    echo "Filament Sensor " ^ param.D ^ ": Magnet issue detected - Check magnet strength."
    M291 P{"Filament Sensor " ^ param.D ^ ": Magnet issue detected - Check magnet strength."} S1 T0
    M25 ; pausa la stampa
    M99

; Messaggio di errore generico
echo "Filament error: " ^ param.P ^ " on sensor " ^ param.D ^ " - action taken"
M99 ; esci dalla macro
