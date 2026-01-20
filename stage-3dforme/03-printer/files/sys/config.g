; General preferences
G90                                                ; send absolute coordinates....
M83                                                ; ...but relative extruder moves
M550 P"3DforMe"                                 ; set printer name
; Wait a moment for the CAN expansion boards to start
G4 S2
;Drive X
M569 P0.0 S1 D3                                      ; physical drive 0.0 goes forwards
;Drive Y
M569 P0.1 S0 D3                                      ; physical drive 0.1 goes forwards
;Drive ZL
M569 P0.2 S0 D2                                      ; physical drive 0.2 goes forwards
;Drive ZR
M569 P0.3 S0 D2                                      ; physical drive 0.3 goes forwards
;Drive E
M569 P0.4 S0 D3
;STALL DETECTION
M915 P0.2:0.3 S3 F0 H317 R0			        ; Coupler

M584 X0.0 Y0.1 Z0.2:0.3 E0.4	                     ; set drive mapping
; set microstepping
M350 X16 Y32 Z16 E16 I1

; set step mm
M92 X80 Y160 Z2133.33 E57600         ; set steps per mm
; set maximum instantaneous speed changes (mm/min)
M566 X3000.00 Y3000.00 Z10.00 E1.00        
; set maximum speeds (mm/min)
M203 X12000.00 Y12000.00 Z180.00 E10.00 I1
; set accelerations (mm/s^2)
M201 X500.00 Y500.00 Z5.00 E1.00  
; set motor currents (mA) and motor idle factor in per cent    
M906 X1300 Y1300 Z1300 E400 I30             
; Set idle timeout
M84 S30                                            

; Axis Limits
M208 X-20 Y-60 Z0  S1                              ; set axis minima
M208 X270 Y230 Z95 S0                            ; set axis maxima

; Endstops
M574 X1 S1 P"io0.in"                               ; configure active-high endstop for low end on X via pin io0.in
M574 Y1 S1 P"io1.in"                               ; configure active-high endstop for low end on Y via pin io1.in  7
M574 Z1 S2
M574 Z2 S4

;M558 A2 B1 P8 X0 Y0 Z1 C"io4.in" H5 F400:100 T1000 S0.3            ; set Z probe type to bltouch and the dive height + speeds
M558 A2 B0 P8 Z1 C"io4.in" H5 F400:200 T1000
G31 P500 X-30 Y0 Z0                  		; set Z probe trigger value, offset and trigger height
M557 X5:215 Y5:215 P5:5  
M376 H5

; Heaters
M308 S0 P"temp0" Y"thermistor" T100000 B5044       ; configure sensor 0 as thermistor on pin temp0
M950 H0 C"out0" T0                                 ; create bed heater output on out0 and map it to sensor 0
M307 H0 R0.1 D69 B1 S1                                   ; disable bang-bang mode for the bed heater and set PWM limit
M140 H0              							; map heated bed to heater 0
M143 H0 S120                                       ; set temperature limit for heater 0 to 120C
M308 S1 P"temp1" Y"thermistor" T100000       ; configure sensor 1 as thermistor on pin temp1
M950 H1 C"out1" T1                                 ; create nozzle heater output on out1 and map it to sensor 1
M143 H1 S350                                       ; set temperature limit for heater 1 to 280C
M308 S2 P"temp2" Y"thermistor" T100000      ; configure sensor 1 as thermistor on pin temp1
M950 H2 C"out2" T2                                 ; create nozzle heater output on out1 and map it to sensor 1
M143 H2 S350                                       ; set temperature limit for heater 1 to 280C

; Fans Nozzle T0
M950 F0 C"out4" Q500                               ; create fan 0 on pin out4 and set its frequency
M106 P0 S0 H-1                                           ; set fan 0 value. Thermostatic control is turned off
;Fan Dissipator + Motor
M950 F1 C"out5" Q500                               ; create fan 1 on pin out5 and set its frequency
M106 P1 S1 H1:2 T60                             ; set fan 1 value. Thermostatic control is turned on

; Led
M950 F3 C"out7"
M106 P3 B300 C"LED" S1
M106 P3 S1

; Buzzer
;M950 P0 C"^io4.out"

;Tools
M563 P0 D0 H1:2 F0                                   ; define tool 0
G10 P0 X0 Y0 Z0                                    ; set tool 0 axis offsets
G10 P0 R0 S0                                       ; set initial tool 0 active and standby temperatures to 0C
                                    ; set initial tool 0 active and standby temperatures to 0C
;NEOPIXEL
M950 E0 C"led" T1 Q3000000  
M150 E0 S1 U255 P80 F1
M150 E0 S1 R255 U255 B255 P120 F1
M150 E0 S1 R255 P255

M950 J0 C"^io6.in"
M581 T0 P0 R0

; Custom settings
T0                                                 ; select first tool
M200 D27 S1
; Miscellaneous
M911 S10 R11 P"M913 X0 Y0 G91 M83 G1 Z3 E-5 F1000" ; set voltage thresholds and actions to run on power loss
M501