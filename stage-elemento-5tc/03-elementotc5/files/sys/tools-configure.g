; Configurazione condizionale tool in base ai board CAN rilevati da tools-detect.g
; Per ogni tool presente configura: driver, sensore temp, heater, ventole,
; definizione tool (M563), temperature default (M568), filament monitor (M591).
; I valori di steps/mm, corrente e MFM vengono dai profili in tool-profiles.g.

; === TOOL T0 — CAN board 121 ===
if global.tool0Present
    M569 P121.0 S0 D2
    M308 S1 P"121.temp0" Y"pt1000" A"T0"
    M950 H1 C"121.out0" T1
    M143 H1 P0 T1 C0 S310 A0
    M307 H1 R1.774 K0.315:0.076 D6.54 E1.35 S1.00 B0 V23.4
    M950 F0 C"121.out1"
    M106 P0 C"FT0" S0 L0 X1 B0.1
    M950 F5 C"121.out2"
    M106 P5 C"FNT0" S0 B0.1 H1 T45
    M563 P0 S"T0" D0 H1 F0
    M568 P0 R0 S0
    M591 D0 P3 C"121.io1.in" S0 L{global.t0MfmL} A0 E{global.t0MfmE}
    M955 P121.0 I54 S800

; === TOOL T1 — CAN board 122 ===
if global.tool1Present
    M569 P122.0 S0 D2
    M308 S2 P"122.temp0" Y"pt1000" A"T1"
    M950 H2 C"122.out0" T2
    M143 H2 P0 T2 C0 S310 A0
    M307 H2 R2.43 D5.5 E1.35 K0.56 B0
    M950 F1 C"122.out1"
    M106 P1 C"FT1" S0 L0 X1 B0.1
    M950 F6 C"122.out2"
    M106 P6 C"FNT1" S0 B0.1 H2 T45
    M563 P1 S"T1" D1 H2 F1
    M568 P1 R0 S0
    M591 D1 P3 C"122.io1.in" S0 L{global.t1MfmL} A0 E{global.t1MfmE}

; === TOOL T2 — CAN board 123 ===
if global.tool2Present
    M569 P123.0 S0 D2
    M308 S3 P"123.temp0" Y"pt1000" A"T2"
    M950 H3 C"123.out0" T3
    M143 H3 P0 T3 C0 S310 A0
    M307 H3 R2.43 D5.5 E1.35 K0.56 B0
    M950 F2 C"123.out1"
    M106 P2 C"FT2" S0 L0 X1 B0.1
    M950 F7 C"123.out2"
    M106 P7 C"FNT2" S0 B0.1 H3 T45
    M563 P2 S"T2" D2 H3 F2
    M568 P2 R0 S0
    M591 D2 P3 C"123.io1.in" S0 L{global.t2MfmL} A0 E{global.t2MfmE}

; === TOOL T3 — CAN board 124 ===
if global.tool3Present
    M569 P124.0 S0 D2
    M308 S4 P"124.temp0" Y"pt1000" A"T3"
    M950 H4 C"124.out0" T4
    M143 H4 P0 T4 C0 S310 A0
    M307 H4 R2.43 D5.5 E1.35 K0.56 B0
    M950 F3 C"124.out1"
    M106 P3 C"FT3" S0 L0 X1 B0.1
    M950 F8 C"124.out2"
    M106 P8 C"FNT3" S0 B0.1 H4 T45
    M563 P3 S"T3" D3 H4 F3
    M568 P3 R0 S0
    M591 D3 P3 C"124.io1.in" S0 L{global.t3MfmL} A0 E{global.t3MfmE}

; === TOOL T4 — CAN board 125 ===
if global.tool4Present
    M569 P125.0 S0 D2
    M308 S5 P"125.temp0" Y"pt1000" A"T4"
    M950 H5 C"125.out0" T5
    M143 H5 P0 T5 C0 S310 A0
    M307 H5 R2.43 D5.5 E1.35 K0.56 B0
    M950 F4 C"125.out1"
    M106 P4 C"FT4" S0 L0 X1 B0.1
    M950 F9 C"125.out2"
    M106 P9 C"FNT4" S0 B0.1 H5 T45
    M563 P4 S"T4" D4 H5 F4
    M568 P4 R0 S0
    M591 D4 P3 C"125.io1.in" S0 L{global.t4MfmL} A0 E{global.t4MfmE}
