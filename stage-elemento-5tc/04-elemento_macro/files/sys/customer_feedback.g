;===========================================
; customer_feedback.g
; Feedback 1–5 stelle + log CSV avanzato
; Supporto multi-materiale / toolchanger
;===========================================

;-------------------------------
; Controllo parametro S
;-------------------------------
if !exists(param.S)
  M291 R"Feedback stampa" P"Errore: parametro S mancante (S=1 completata, S=0 abortita)." S2 T0
  abort "Parametro S mancante in customer_feedback.g"

;-------------------------------
; Variabili comuni
;-------------------------------
var q1 = 0
var q2 = 0
var q3 = 0

var scenario  = param.S = 1 ? "COMPLETATA" : "ABORTITA"
var completed = param.S = 1 ? 1 : 0

;-------------------------------------------
; STAMPA COMPLETATA (S = 1)
;-------------------------------------------
if param.S = 1

  M291 S4 R"Stampa completata" \
       P"Come valuteresti il RISULTATO finale della stampa?" \
       K{"★1 - Molto negativa","★2 - Negativa","★3 - Neutra","★4 - Positiva","★5 - Eccellente"}
  set var.q1 = input + 1

  M291 S4 R"Stampa completata" \
       P"Come valuteresti la FACILITÀ d’uso della stampante?" \
       K{"★1 - Molto difficile","★2 - Poco intuitiva","★3 - Accettabile","★4 - Semplice","★5 - Molto semplice"}
  set var.q2 = input + 1

  M291 S4 R"Stampa completata" \
       P"Consiglieresti questa stampante ad un collega?" \
       K{"★1 - Per niente","★2 - Poco","★3 - Neutro","★4 - Probabile","★5 - Sicuramente"}
  set var.q3 = input + 1

;-------------------------------------------
; STAMPA ABORTITA (S = 0)
;-------------------------------------------
else

  M291 S4 R"Stampa interrotta" \
       P"Come valuteresti la tua ESPERIENZA complessiva?" \
       K{"★1 - Molto negativa","★2 - Negativa","★3 - Neutra","★4 - Positiva","★5 - Eccellente"}
  set var.q1 = input + 1

  M291 S4 R"Stampa interrotta" \
       P"Quanto era chiaro il problema riscontrato?" \
       K{"★1 - Impossibile capirlo","★2 - Poco chiaro","★3 - Abbastanza chiaro","★4 - Chiaro","★5 - Chiarissimo"}
  set var.q2 = input + 1

  M291 S4 R"Stampa interrotta" \
       P"Quanto ti senti fiducioso a RIPROVARE la stampa?" \
       K{"★1 - Per niente","★2 - Poco","★3 - Neutro","★4 - Fiducioso","★5 - Molto fiducioso"}
  set var.q3 = input + 1


;===================================================
; RACCOLTA DATI JOB (altezza, filamento, tempo, file)
;===================================================
var layerHeight   = exists(job.file.layerHeight)  ? job.file.layerHeight  : -1
var objectHeight  = exists(job.file.objectHeight) ? job.file.objectHeight : -1

; somma totale filamento (tutti gli estrusori)
var filamentUsed = -1
if exists(job.file.filament)
  set var.filamentUsed = 0
  for var i = 0 to #job.file.filament - 1
    set var.filamentUsed = var.filamentUsed + job.file.filament[var.i]

var jobDuration   = exists(job.duration) ? job.duration : -1
var fileName      = exists(job.file.fileName) ? job.file.fileName : "<no-file>"

;===================================================
; MATERIALI (nomi per tool)
;===================================================
; Esempio: "T0:PLA-Black;T1:PETG-Red"
var materials = ""

if #tools > 0
  for var t = 0 to #tools - 1
    if exists(tools[var.t].filament)
      if var.materials = ""
        set var.materials = "T" ^ var.t ^ ":" ^ tools[var.t].filament
      else
        set var.materials = var.materials ^ ";" ^ "T" ^ var.t ^ ":" ^ tools[var.t].filament

if var.materials = ""
  set var.materials = "UNKNOWN"


;===================================================
; USO PER OGNI TOOL (materiale + filamento)
;===================================================
; Esempio: "T0:PLA-Black:1234.5;T1:PETG-Red:567.8"
var toolsUsage = "UNKNOWN"

if #tools > 0 && exists(job.file.filament)
  set var.toolsUsage = ""
  for var t = 0 to #tools - 1

    var toolFilament = 0

    if #tools[var.t].extruders > 0
      for var e = 0 to #tools[var.t].extruders - 1
        var driveIndex = tools[var.t].extruders[var.e]
        if var.driveIndex < #job.file.filament
          set var.toolFilament = var.toolFilament + job.file.filament[var.driveIndex]

    var matName = exists(tools[var.t].filament) ? tools[var.t].filament : "UNKNOWN"

    if var.toolsUsage = ""
      set var.toolsUsage = "T" ^ var.t ^ ":" ^ matName ^ ":" ^ var.toolFilament
    else
      set var.toolsUsage = var.toolsUsage ^ ";" ^ "T" ^ var.t ^ ":" ^ matName ^ ":" ^ var.toolFilament


;===================================================
; LOG COMPLETO SU CSV (SENZA machineId)
;===================================================
; File: /sys/feedback_log.csv
;
; Colonne:
; time_s,
; scenario,
; completed,
; fileName,
; layerHeight,
; objectHeight,
; filament_total,
; materials,
; tools_usage,
; jobDuration_s,
; q1,
; q2,
; q3
;===================================================

; Intestazione (ripetuta, ma innocua in CSV)
echo >>"feedback_log.csv" "time_s,scenario,completed,fileName,layerHeight,objectHeight,filament_total,materials,tools_usage,jobDuration_s,q1,q2,q3"

; Riga dati
echo >>"feedback_log.csv" \
      state.time ^ "," ^ \
      var.scenario ^ "," ^ \
      var.completed ^ "," ^ \
      var.fileName ^ "," ^ \
      var.layerHeight ^ "," ^ \
      var.objectHeight ^ "," ^ \
      var.filamentUsed ^ "," ^ \
      var.materials ^ "," ^ \
      var.toolsUsage ^ "," ^ \
      var.jobDuration ^ "," ^ \
      var.q1 ^ "," ^ \
      var.q2 ^ "," ^ \
      var.q3

;===================================================
; SALVA ULTIMO FEEDBACK IN VARIABILE GLOBALE
; (usato dalla macro diagnostics_feedback.g)
;===================================================
if !exists(global.lastFeedback)
  global lastFeedback = ""

set global.lastFeedback = \
   "scenario=" ^ var.scenario ^ ";" ^ \
   "completed=" ^ var.completed ^ ";" ^ \
   "file=" ^ var.fileName ^ ";" ^ \
   "materials=" ^ var.materials ^ ";" ^ \
   "tools=" ^ var.toolsUsage ^ ";" ^ \
   "q1=" ^ var.q1 ^ ";q2=" ^ var.q2 ^ ";q3=" ^ var.q3

;-------------------------------------------
; Ringraziamento finale
;-------------------------------------------
M291 R"Grazie!" P"Il tuo feedback è prezioso!" S1 T4