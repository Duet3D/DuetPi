;===========================================
; diagnostics_feedback.g
; Mostra un riepilogo dell'ultimo feedback
;===========================================

if !exists(global.lastFeedback)
  M291 R"Diagnostica feedback" P"Nessun feedback registrato." S2 T5
  abort

M291 S1 R"Ultimo feedback" \
      P{ "Dati registrati:\n" ^ global.lastFeedback } T10