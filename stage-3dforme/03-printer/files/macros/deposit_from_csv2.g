; ============================================================
; TOOL: Deposizione da file CSV (RRF 3.5.0+ con fileread)
; ============================================================
; Parametri:
;   N = nome file CSV (senza estensione)
;   F = feedrate XY (mm/min, opzionale, default 600)
; ============================================================

if {!exists(param.N)}
  abort "Parametro richiesto: N=<file>"

var feed = exists(param.F) ? param.F : 600
var file = "/sys/points/" ^ param.N ^ ".csv"

if {!fileexists(var.file)}
  abort "File CSV non trovato: " ^ var.file

G28
G1 Z30 F300

echo ">>> Inizio lettura punti da: " ^ var.file

var skip = 0

while true
  ; Legge 4 elementi (X,Y,Z,V) dalla riga corrente
  var parts = fileread(var.file, var.skip, 4, ',')

  ; Fine file → array con un solo null
  if {#var.parts == 1 && var.parts[0] == null}
    echo ">>> Fine file raggiunta"
    break

  ; Riga incompleta → ignora
  if {#var.parts < 4}
    echo ">>> Riga incompleta o vuota, ignorata (skip=" ^ var.skip ^ ", elementi=" ^ #var.parts ^ ")"
    set var.skip = var.skip + #var.parts
    continue

  ; Parsing valori
  var X = var.parts[0]
  var Y = var.parts[1]
  var Z = var.parts[2]
  var V = var.parts[3]

  ; Conversione volume → mm pistone
  var mmPistone = var.V / 572.56

  ; Debug: stampa valori letti e calcolati
  echo ">>> Punto: X=" ^ var.X ^ " Y=" ^ var.Y ^ " Z=" ^ var.Z ^ " V=" ^ var.V ^ " → mmPistone=" ^ var.mmPistone

  ; Movimento al punto
  G90
  G1 X{var.X} Y{var.Y} Z{var.Z} F{var.feed}

  ; Assicurati estrusione relativa e abilitata
  M83
  M302 P1 S1

  ; Estrusione
  G91
  G1 E{var.mmPistone} F60
  G90

  ; Avanza al prossimo record
  set var.skip = var.skip + 4

echo ">>> Deposizione completata dal file: " ^ var.file
