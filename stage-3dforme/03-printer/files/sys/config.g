;Variabili globali
;global zOffset=0
; General preferences 3.4.5 ma firmware 3.5.0
G90                                                        ; send absolute coordinates....
M83                                                        ; ...but relative extruder moves
; Wait a moment for the CAN expansion boards to start
G4 S2
;Drive X
M569 P0.0 S1 D2                                            ; physical drive 0.0 goes forwards
;Drive Y
M569 P0.1 S1 D2                                            ; physical drive 0.1 goes forwards
;Drive ZL
M569 P0.2 S0 D2
;Drive ZR
M569 P0.3 S0 D2                                            ; physical drive 0.2 goes forwards
;Drive E
M569 P0.4 S1 D3                                            ; physical drive 0.3 goes forwards

M584 X0.0 Y0.1 Z0.2:0.3 E0.4                               ; set drive mapping
; set microstepping
M350 X16 Y16 I1 
M350 E4 I1
M350 Z16 I1                                                ; configure microstepping with interpolation

; set step mm
M92 X80 Y80.00 Z2133.33 E250                            ; set steps per mm
; set maximum instantaneous speed changes (mm/min)
M566 X200.00 Y200.00 Z10.00 E30.00        
; set maximum speeds (mm/min)
M203 X12000.00 Y12000.00 Z180.00 E8000.00   
; set accelerations (mm/s^2)
M201 X500.00 Y500.00 Z5.00 E1000.00  
; set motor currents (mA) and motor idle factor in per cent    
M906 X1200 Y1200 Z1200 E1800 I30             
; Set idle timeout
M84 S30                                             

; Axis Limits
M208 X-30 Y-30 Z0 S1                                       ; set axis minima
M208 X270 Y270 Z30 S0                                   ; set axis maxima

; Endstops
M574 X1 S3                                                 ; configure active-high endstop for low end on X via pin io0.in
M574 Y1 S3                                                 ; configure active-high endstop for low end on Y via pin io1.in  
M574 Z1 S2
M574 Z2 S4                                                 ; configure active-high endstop for high end on X via pin io2.in

M558 A2 B0 P8 X0 Y0 Z1 C"io4.in" H5 F200:100 T5000 ; set Z probe type to bltouch and the dive height + speeds
G31 P500 X0 Y-30                                            ; set Z probe trigger value, offset and trigger height
M557 X0:200 Y0:185 P5:5  
M376 H5

; Heaters
M308 S0 P"temp0" Y"thermistor" T100000 B5044   A"BED"      ; configure sensor 0 as thermistor on pin temp0
M950 H0 C"out0" T0                                         ; create bed heater output on out0 and map it to sensor 0
M307 H0 R0.713 K0.318:0.000 D30.68 E1.35 S0.70 B0          ; disable bang-bang mode for the bed heater and set PWM limit
M140 H0                                                    ; map heated bed to heater 0
M143 H0 S120                                               ; set temperature limit for heater 0 to 120C                                      ; set temperature limit for heater 1 to 280C
M308 S3 P"temp3" Y"thermistor" T100000 B5044               ; configure sensor 1 as thermistor on pin temp1
M950 H3 C"out3" T3                                         ; create nozzle heater output on out1 and map it to sensor 1
M307 H3 B0 R2.160 C70.5:66.3 D3.84 S1.00 V24.5             ; disable bang-bang mode for heater  and set PWM limit
M143 H3 S350
M308 S11 Y"bme280" P"spi.cs3" A"Ambient temp"
M308 S13 Y"bmehumidity" P"S11.2" A"Humidity[%]"

; Fans Nozzle T0
M950 F0 C"out4" Q500                                       ; create fan 0 on pin out4 and set its frequency
M106 P0 S0 H-1 C"Nozzle"
                                                           ; set fan 0 value. Thermostatic control is turned off
;Fan Dissipator + Motor
M950 F1 C"out5" Q500                                       ; create fan 1 on pin out5 and set its frequency
M106 P1 S1 H1:2 T40 C"Dissipator"                          ; set fan 1 value. Thermostatic control is turned on

;Elettronics 
M950 F2 C"out8" Q500                                       ; create fan 1 on pin out5 and set its frequency
M106 P2 S1 H1:2 T50  C"Electronics"                        ; set fan 1 value. Thermostatic control is turned on

; Led
M950 F3 C"out7"
M106 P3 B300 C"LED" S1
M106 P3 S1

; Buzzer
M950 P5 C"io4.out" Q500

;Tools
M563 P0 D0 H1:2 F0  S"Extruder"                            ; define tool 0
G10 P0 X0 Y0 Z0                                            ; set tool 0 axis offsets
G10 P0 R0 S0                                               ; set initial tool 0 active and standby temperatures to 0C
                                                           ; set initial tool 0 active and standby temperatures to 0C
;NEOPIXEL
M950 E0 C"led" T1 Q3000000 
M150 E0 S1 U255 P80 F1
M150 E0 S1 R255 U255 B255 P120 F1
M150 E0 S1 R255 P255

;Door Control Front
M950 J3 C"!^io5.in"
M581 T3 P3 S1 R0
; Custom settings

M586 P1 S1 C"*"
; Miscellaneous
M911 S10 R11 P"M913 X0 Y0 G91 M83 G1 Z3 E-5 F1000"         ; set voltage thresholds and actions to run on power loss
M555 P2                                                    ; Set marlin compatibility

global x_cleaning_pos_min = 0
global x_cleaning_pos_max = 0
global y_cleaning_pos_min = 0
global y_cleaning_pos_max = 0 

M98 P"0:/macros/PID/pid_wlock"
M98 P"0:/sys/leveling.status"
M98 P"0:/sys/cleaning_xy.g"
M929 S2
T0                                                         ; select first tool
M501