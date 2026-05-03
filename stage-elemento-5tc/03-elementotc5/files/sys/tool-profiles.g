; Tool hardware profiles - one section per physical slot (T0-T4)
; Edit these values when changing nozzle diameter or extruder hardware.
; Chiamato da config.g prima di G4 S2, poi nozzle-sizes.g sovrascrive NozzleDia e PressAdv.
;
; StepsMM : steps/mm estrusore - dipende dal gear ratio, non dal diametro ugello
; Microstep: microstepping (tutti useranno interpolazione I1)
; Current  : corrente motore (mA)
; NozzleDia: diametro ugello installato (mm) — sovrascritto da nozzle-sizes.g al boot
; PressAdv : pressure advance — calcolato da NozzleDia via set-nozzle.g, sovrascritto da nozzle-sizes.g
; MfmL     : calibrazione MFM (mm filamento per giro ruota) - misurare con M591 T D{n}
; MfmE     : tolleranza errore MFM (mm) prima del trigger filament-error

; === SLOT T0 — CAN board 121 ===
global t0StepsMM  = 260
global t0Microstep= 4
global t0Current  = 1000
global t0NozzleDia= 0.4
global t0PressAdv = 0.060
global t0MfmL     = 28
global t0MfmE     = 10

; === SLOT T1 — CAN board 122 ===
global t1StepsMM  = 224
global t1Microstep= 4
global t1Current  = 1000
global t1NozzleDia= 0.4
global t1PressAdv = 0.060
global t1MfmL     = 34
global t1MfmE     = 3

; === SLOT T2 — CAN board 123 ===
global t2StepsMM  = 260
global t2Microstep= 4
global t2Current  = 1000
global t2NozzleDia= 0.4
global t2PressAdv = 0.060
global t2MfmL     = 28
global t2MfmE     = 10

; === SLOT T3 — CAN board 124 ===
global t3StepsMM  = 260
global t3Microstep= 4
global t3Current  = 1000
global t3NozzleDia= 0.4
global t3PressAdv = 0.060
global t3MfmL     = 28
global t3MfmE     = 10

; === SLOT T4 — CAN board 125 ===
global t4StepsMM  = 260
global t4Microstep= 4
global t4Current  = 1000
global t4NozzleDia= 0.4
global t4PressAdv = 0.060
global t4MfmL     = 28
global t4MfmE     = 10

; ========================================
; PRESSURE ADVANCE LOOKUP TABLE per diametro ugello
; Calibrare con test PA per il proprio hotend/filamento
; ========================================
global paNozzle025 = 0.080
global paNozzle04  = 0.060
global paNozzle06  = 0.040
global paNozzle08  = 0.020
global paNozzle10  = 0.010
