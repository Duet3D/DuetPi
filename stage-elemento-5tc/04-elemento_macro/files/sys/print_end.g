;===========================================
; print_end.g
; Eseguito a fine job COMPLETATO
;===========================================

; --- Chiusura standard (puoi personalizzare) ---
; G91
; G1 Z5 F600
; G90
; G1 X0 Y0 F9000
; M104 S0
; M140 S0
; M106 S0

; Feedback + log
M98 P"customer_feedback.g" S1


;Aggiungi ad endgcode nello slicing
;M98 P"print_end.g"
