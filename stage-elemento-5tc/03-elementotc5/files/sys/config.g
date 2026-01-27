; Configuration file for RepRapFirmware on Duet 3 Main Board 6HC
; 5 TOOLS CONFIGURATION
; Generated for 5-tool setup expansion

; General
M550 P"ElementoTC-5Tools"

; Wait for CAN expansion boards
G4 S2

; ========================================
; DRIVER CONFIGURATION - 5 EXTRUDERS
; ========================================
M569.1 P70.0 T3 E8:16 R100 I0 D0
M569.1 P71.0 T3 E8:16 R100 I0 D0
M569.1 P72.0 T3 E8:16 R100 I0 D0
M569.1 P73.0 T3 E4:8 R100 I0 D0
M569.1 P74.0 T3 E4:8 R100 I0 D0
M569.1 P75.0 T3 E4:8 R100 I0 D0

; Smart Drivers - X, Y, Z
M569 P70.0 S0 D4
M569 P71.0 S1 D4
M569 P72.0 S1 D4
M569 P73.0 S0 D4
M569 P74.0 S0 D2
M569 P75.0 S0 D4

; Extruder Drivers (5 tools)
M569 P121.0 S0 D2    ; T0
M569 P122.0 S0 D2    ; T1
M569 P123.0 S0 D2    ; T2
M569 P124.0 S0 D2    ; T3
M569 P125.0 S0 D2    ; T4

; Tool Change Coupler
M569 P0.0 S0 D2 V0

; ========================================
; AXIS C - TOOL CHANGE COUPLER
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
; KINEMATICS - X, Y, Z
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
; EXTRUDERS - 5 TOOLS
; ========================================
M584 E121.0:122.0:123.0:124.0:125.0
M350 E4:4:4:4:4 I1
M906 E1000:1000:1000:1000:1000
M92 E260:224:260:224:260
M566 E120:120:120:120:120
M203 E10000:10000:10000:10000:10000
M201 E5000:5000:5000:5000:5000

; Motor thermal protection
M917 X70 Y70 Z80 C70 E70:70:70:70:70

; Kinematics
M669 K0

; Accelerometers
M955 P121.0 I54 S800
; M955 P122.0 I54
; M955 P123.0 I54
; M955 P124.0 I54
; M955 P125.0 I54

; Input Shaping
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
; TEMPERATURE SENSORS
; ========================================
M308 S0 P"temp0" Y"thermistor" T50000 A"Heated Bed"
M308 S1 P"121.temp0" Y"pt1000" A"T0"
M308 S2 P"122.temp0" Y"pt1000" A"T1"
M308 S3 P"123.temp0" Y"pt1000" A"T2"
M308 S4 P"124.temp0" Y"pt1000" A"T3"
M308 S5 P"125.temp0" Y"pt1000" A"T4"
M308 S6 Y"thermistor" P"120.temp0" A"CH"

; Motor temperature sensors
M308 S10 P"70.temp0" Y"thermistor" A"X"
M308 S11 P"71.temp0" Y"thermistor" A"YL"
M308 S12 P"72.temp0" Y"thermistor" A"YR"
M308 S13 P"73.temp0" Y"thermistor" A"ZL"
M308 S14 P"74.temp0" Y"thermistor" A"ZC"
M308 S15 P"75.temp0" Y"thermistor" A"ZR"

; ========================================
; HEATERS - 5 HOTENDS + BED + CHAMBER
; ========================================
; Bed
M950 H0 C"out0" T0
M143 H0 P0 T0 C0 S125 A0
M307 H0 R0.027 K0.040:0.000 D43.51 E1.35 S1.00 B1
M140 P0 H0

; Hotends
M950 H1 C"121.out0" T1
M143 H1 P0 T1 C0 S310 A0
M307 H1 R1.774 K0.315:0.076 D6.54 E1.35 S1.00 B0 V23.4

M950 H2 C"122.out0" T2
M143 H2 P0 T2 C0 S310 A0
M307 H2 R2.43 D5.5 E1.35 K0.56 B0

M950 H3 C"123.out0" T3
M143 H3 P0 T3 C0 S310 A0
M307 H3 R2.43 D5.5 E1.35 K0.56 B0

M950 H4 C"124.out0" T4
M143 H4 P0 T4 C0 S310 A0
M307 H4 R2.43 D5.5 E1.35 K0.56 B0

M950 H5 C"125.out0" T5
M143 H5 P0 T5 C0 S310 A0
M307 H5 R2.43 D5.5 E1.35 K0.56 B0

; Chamber heater
M950 H6 C"!out4" T6
M143 H6 P0 T6 C-1 S285 A0
M307 H6 R2.43 D5.5 E1.35 K0.56 B0
M141 P0 H6

; ========================================
; FANS - 5 TOOLS
; ========================================
; Part cooling fans
M950 F0 C"121.out1"
M106 P0 C"FT0" S0 L0 X1 B0.1

M950 F1 C"122.out1"
M106 P1 C"FT1" S0 L0 X1 B0.1

M950 F2 C"123.out1"
M106 P2 C"FT2" S0 L0 X1 B0.1

M950 F3 C"124.out1"
M106 P3 C"FT3" S0 L0 X1 B0.1

M950 F4 C"125.out1"
M106 P4 C"FT4" S0 L0 X1 B0.1

; Hotend cooling fans
M950 F5 C"121.out2"
M106 P5 C"FNT0" S0 B0.1 H1 T45

M950 F6 C"122.out2"
M106 P6 C"FNT1" S0 B0.1 H2 T45

M950 F7 C"123.out2"
M106 P7 C"FNT2" S0 B0.1 H3 T45

M950 F8 C"124.out2"
M106 P8 C"FNT3" S0 B0.1 H4 T45

M950 F9 C"125.out2"
M106 P9 C"FNT4" S0 B0.1 H5 T45

; LED
M950 F10 C"out8"
M106 P10 B300 C"LED" S1

; QC Fan
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
; TOOLS DEFINITION - 5 TOOLS
; ========================================
M563 P0 S"T0" D0 H1 F0
M568 P0 R0 S0

M563 P1 S"T1" D1 H2 F1
M568 P1 R0 S0

M563 P2 S"T2" D2 H3 F2
M568 P2 R0 S0

M563 P3 S"T3" D3 H4 F3
M568 P3 R0 S0

M563 P4 S"T4" D4 H5 F4
M568 P4 R0 S0

; ========================================
; FILAMENT MONITORS - 5 TOOLS
; ========================================
M591 D0 P3 C"121.io1.in" S0 L28 A0 E10
M591 D1 P3 C"122.io1.in" S0 L34 A0 E3
M591 D2 P3 C"123.io1.in" S0 L28 A0 E10
M591 D3 P3 C"124.io1.in" S0 L28 A0 E10
M591 D4 P3 C"125.io1.in" S0 L28 A0 E10

; ========================================
; GLOBAL VARIABLES - PARKING POSITIONS
; ========================================
global bedTemperatureT0 = 0
global bedTemperatureT1 = 0
global bedTemperatureT2 = 0
global bedTemperatureT3 = 0
global bedTemperatureT4 = 0

; Parking X positions (distributed across bed)
global xPT0Position = 220    ; First position
global xPT1Position = 400    ; Second position
global xPT2Position = 540    ; Center position
global xPT3Position = 680    ; Fourth position
global xPT4Position = 860    ; Fifth position

; Parking Y positions (all aligned)
global yPT0Position = 0
global yPT1Position = 0
global yPT2Position = 0
global yPT3Position = 0
global yPT4Position = 0

; ========================================
; LED STRIP
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

; Load saved config
M501

; Unlock door
M1201

; Start logging level 3
M929 S3