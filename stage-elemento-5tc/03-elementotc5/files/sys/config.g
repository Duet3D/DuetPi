; Configuration file for RepRapFirmware on Duet 3 Main Board 6HC
; 5 TOOLS CONFIGURATION - Dynamic tool discovery via CAN bus
;
; Startup sequence:
;   1. tool-profiles.g  → global vars per hardware ugello (steps/mm, MFM L, corrente...)
;   2. G4 S2            → attesa board CAN
;   3. tools-detect.g   → scansione CAN, imposta global.toolNPresent
;   4. tools-configure.g→ M563/M591/heater/fan solo per tool presenti

; General
M550 P"ElementoTC-5Tools"

; Load tool hardware profiles (defines global vars used in M92/M906 below)
M98 P"tool-profiles.g"

; Override nozzle diameters and pressure advance with persisted values
M98 P"nozzle-sizes.g"

; Wait for CAN expansion boards
G4 S2

; Detect which tool boards are present on CAN bus
M98 P"tools-detect.g"

; ========================================
; AXIS DRIVER CONFIGURATION (main board / axis boards — always present)
; ========================================
M569.1 P70.0 T3 E8:16 R100 I0 D0
M569.1 P71.0 T3 E8:16 R100 I0 D0
M569.1 P72.0 T3 E8:16 R100 I0 D0
M569.1 P73.0 T3 E4:8 R100 I0 D0
M569.1 P74.0 T3 E4:8 R100 I0 D0
M569.1 P75.0 T3 E4:8 R100 I0 D0

M569 P70.0 S0 D4
M569 P71.0 S1 D4
M569 P72.0 S1 D4
M569 P73.0 S0 D4
M569 P74.0 S0 D2
M569 P75.0 S0 D4

; Tool Change Coupler (main board)
M569 P0.0 S0 D2 V0

; ========================================
; AXIS C — TOOL CHANGE COUPLER
; ========================================
M584 C0.0
M350 C16
M906 C800
M92 C200
M208 C0:70
M566 C2000
M203 C20000
M201 C4000

; ========================================
; KINEMATICS — X, Y, Z
; ========================================
M584 X70.0 Y71.0:72.0 Z73.0:74.0:75.0
M350 X16 Y16 Z16 I1
M906 X2200 Y2200 Z2000
M92 X100 Y100 Z640
M208 X-30:1100 Y-10:605 Z0:620
M566 X600 Y600 Z20 P1
M203 X18000 Y18000 Z1500
M201 X10000 Y10000 Z40
M204 P10000 T14000

; ========================================
; EXTRUDER MAPPING (driver assignment + parametri da tool-profiles.g)
; Nota: M584 mappa i driver per tutti e 5 gli slot; M569 per slot viene in tools-configure.g
; ========================================
M584 E121.0:122.0:123.0:124.0:125.0
M350 E{global.t0Microstep}:{global.t1Microstep}:{global.t2Microstep}:{global.t3Microstep}:{global.t4Microstep} I1
M906 E{global.t0Current}:{global.t1Current}:{global.t2Current}:{global.t3Current}:{global.t4Current}
M92  E{global.t0StepsMM}:{global.t1StepsMM}:{global.t2StepsMM}:{global.t3StepsMM}:{global.t4StepsMM}
M566 E120:120:120:120:120
M203 E10000:10000:10000:10000:10000
M201 E5000:5000:5000:5000:5000

; Motor thermal protection
M917 X70 Y70 Z80 C70 E70:70:70:70:70

; ========================================
; KINEMATICS / INPUT SHAPING
; ========================================
M669 K0
M593 P"MZV" F27.4

; ========================================
; ENDSTOPS
; ========================================
M574 Z1 S2 K0
M574 Z2 P"!io3.in+!io2.in+!io5.in" S1
M574 C1 S3

; Bed leveling screws
M671 X-16:550:1116 Y73:765:73 S20

; ========================================
; PROBES
; ========================================
M558 A2 Z1 K0 B1 P8 C"io4.in" H35:5 F300:150 T9000 S0.2 R0.5
G31 K0 P500 X0 Y36 Z0.6
M558 K1 B1 H10 P11 C"120.i2c.ldc1612" F3000 T3000
G31 K1 X0 Y53 Z0.6
M558.2 K1 S16 R135728

; Mesh Bed Compensation
M557 X0:1080 Y26:520 P20:10
M376 H0

; ========================================
; TEMPERATURE SENSORS — main board e assi (sempre presenti)
; Sensori hotend S1-S5 sono in tools-configure.g
; ========================================
M308 S0 P"temp0" Y"thermistor" T50000 A"Heated Bed"
M308 S6 Y"thermistor" P"120.temp0" A"CH"
M308 S10 P"70.temp0" Y"thermistor" A"X"
M308 S11 P"71.temp0" Y"thermistor" A"YL"
M308 S12 P"72.temp0" Y"thermistor" A"YR"
M308 S13 P"73.temp0" Y"thermistor" A"ZL"
M308 S14 P"74.temp0" Y"thermistor" A"ZC"
M308 S15 P"75.temp0" Y"thermistor" A"ZR"

; ========================================
; BED HEATER
; ========================================
M950 H0 C"out0" T0
M143 H0 P0 T0 C0 S125 A0
M307 H0 R0.027 K0.040:0.000 D43.51 E1.35 S1.00 B1
M140 P0 H0

; ========================================
; CHAMBER HEATER
; ========================================
M950 H6 C"!out4" T6
M143 H6 P0 T6 C-1 S285 A0
M307 H6 R2.43 D5.5 E1.35 K0.56 B0
M141 P0 H6

; ========================================
; LED STRIP + QC FAN (main board — sempre presenti)
; ========================================
M950 F10 C"out8"
M106 P10 B300 C"LED" S1
M950 F11 C"out9"
M106 P11 B300 C"QC" S1

; ========================================
; GPIO TRIGGERS
; ========================================
M950 J6 C"io6.in"
M950 J7 C"!io7.in"
M950 J8 C"!io8.in"
M950 J9 C"^io6.out"
M950 J10 C"^io7.out"
M950 J11 C"^io8.out"
M950 J12 C"^io0.in"
M950 J13 C"io1.in"
M950 J14 C"^io0.out"
M581 T2 P6 S-1
M581 T3 P7 S1
M581 T4 P8 S1
M581 T5 P9 S1
M581 T6 P10 S1
M581 T7 P11 S1
M581 T8 P12 S0
M581 T9 P13 S1
M581 T10 P14 S1

; ========================================
; CONFIGURE DETECTED TOOLS
; Heater, fan, sensori, M563, M591 solo per board CAN presenti
; ========================================
M98 P"tools-configure.g"

; Apply pressure advance per tool based on installed nozzle diameters
M98 P"apply-nozzle-pa.g"

; ========================================
; GLOBAL VARIABLES — parking positions
; ========================================
global bedTemperatureT0 = 0
global bedTemperatureT1 = 0
global bedTemperatureT2 = 0
global bedTemperatureT3 = 0
global bedTemperatureT4 = 0

global xPT0Position = 220
global xPT1Position = 400
global xPT2Position = 540
global xPT3Position = 680
global xPT4Position = 860

global yPT0Position = 0
global yPT1Position = 0
global yPT2Position = 0
global yPT3Position = 0
global yPT4Position = 0

; ========================================
; LED STRIP (Neopixel)
; ========================================
M950 E0 C"led" T1 U78 Q3000000
M150 E0 R255 U85 B0 S78 P255

; ========================================
; LOAD PARKING OFFSETS
; ========================================
M98 P"yPT0-offset.g"
M98 P"yPT1-offset.g"
M98 P"yPT2-offset.g"
M98 P"yPT3-offset.g"
M98 P"yPT4-offset.g"

; Load TC configuration
M98 P"5TC.conf"

; Load saved config (M500 data: heater models, Z offsets, tool offsets)
M501

; Unlock door
M1201

; Start logging (level 1 = info; use M929 S3 solo per debug temporaneo)
M929 S1
