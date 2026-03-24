;===========================================
; cancel.g
; Eseguito quando una stampa viene ANNULLATA/ABORTITA
;===========================================

; --- Chiusura sicura ---
; G91
; G1 Z5 F600
; G90
; G1 X0 Y0 F9000
; M104 S0
; M140 S0
; M106 S0

; Feedback + log
M98 P"customer_feedback.g" S0