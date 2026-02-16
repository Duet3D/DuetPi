; ==============================================================================
; Main Calibration Macro - Tool Parking Calibration (T0 to T4)
; ==============================================================================

M291 R"Calibrazione Parcheggio Utensili" P"Procedura di calibrazione dei parcheggi per utensili T0-T4" S2

; Call individual tool calibration submacros
M98 P"calibration-t0.g"
M98 P"calibration-t1.g"
M98 P"calibration-t2.g"
M98 P"calibration-t3.g"
M98 P"calibration-t4.g"

M291 R"Calibrazione Parcheggio - COMPLETATA" P"Tutte le calibrazioni sono state completate con successo." S2