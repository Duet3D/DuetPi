; ============================================================
; TOOL: Deposizione da file CSV (X,Y da CSV, Z e V da input)
; ============================================================
; Parametri:
;   N = nome file CSV (senza estensione)
;   F = feedrate XY (mm/min, opzionale, default 600)
;   Z = quota Z (obbligatoria, input utente)
;   V = volume da estrudere (obbligatorio, input utente)
;   E = feedrate estrusione (mm/min, opzionale, default 60)
;   C = temperatura T0 (°C, opzionale)
;   J = temperatura T1 (°C, opzionale)
; ============================================================



if {!exists(param.N)}
  abort "Parametro richiesto: N<file>"
if {!exists(param.Z)}
  abort "Parametro richiesto: Z<quota>"
if {!exists(param.V)}
  abort "Parametro richiesto: V<volume>"
if {!exists(param.C)}
  abort "Parametro richiesto: C<TEMP0>"
if {!exists(param.J)}
  abort "Parametro richiesto: J<TEMP1>"
  
var feed = exists(param.F) ? param.F : 1000
var eFeed = exists(param.E) ? param.E : 100
var file = "/sys/points/" ^ param.N ^ ".csv"

; Gestione temperature T0 e T1
if {exists(param.C) && exists(param.J)}
  echo ">>> Impostazione temperatura T0: " ^ param.C ^ "°C"  ^ param.J ^ "°C"
  M568 P0 S{param.C}:{param.J}; Imposta temperatura attiva T0
  M116 P0                       ; Attendi che T0 raggiunga la temperatura
else
  abort "Temperatura non settata"
      ; Attendi che T1 raggiunga la temperatura

if {!fileexists(var.file)}
  abort "File CSV non trovato: " ^ var.file

G28

echo ">>> Inizio lettura punti da: " ^ var.file
echo ">>> Z impostato: " ^ param.Z ^ " mm"
echo ">>> Volume per punto: " ^ param.V ^ " mm³"
echo ">>> Feedrate XY: " ^ var.feed ^ " mm/min"
echo ">>> Feedrate estrusione: " ^ var.eFeed ^ " mm/min"

; Conversione volume → mm pistone
; Nota: 572.56 = π * (1.75/2)² per filamento 1.75mm
; Modifica questo valore se usi un diametro diverso
var mmPistone = param.V / 572.56

echo ">>> Estrusione per punto: " ^ var.mmPistone ^ " mm"

; Configurazione estrusione
M83                    ; Estrusione relativa
M302 P1 S1            ; Abilita estrusione a freddo (se necessario)

var skip = 0
var pointCount = 0

; Movimento alla quota Z prima di iniziare
G90
G1 Z{param.Z} F{var.feed}

while true
  ; Legge 2 elementi (X,Y) dalla riga corrente
  var parts = fileread(var.file, var.skip, 2, ',')

  ; Fine file → array con un solo null
  if {#var.parts == 1 && var.parts[0] == null}
    echo ">>> Fine file raggiunta - Processati " ^ var.pointCount ^ " punti"
    break

  ; Riga incompleta → ignora
  if {#var.parts < 2}
    echo ">>> WARN: Riga incompleta ignorata (skip=" ^ var.skip ^ ")"
    set var.skip = var.skip + #var.parts
    continue

  ; Parsing valori: X e Y dal CSV
  var X = var.parts[0]
  var Y = var.parts[1]

  ; Incrementa contatore punti
  set var.pointCount = var.pointCount + 1

  ; Debug: stampa valori letti e calcolati
  echo ">>> Punto #" ^ var.pointCount ^ ": X=" ^ var.X ^ " Y=" ^ var.Y ^ " Z=" ^ param.Z ^ " | Estrudo " ^ var.mmPistone ^ " mm"

  ; Movimento al punto (solo XY, Z già impostato)
  G90
  G1 X{var.X} Y{var.Y} F{var.feed}

  ; Estrusione (già in modalità relativa M83)
  G1 E{var.mmPistone} F{var.eFeed}

  ; Pausa opzionale per stabilizzazione (commentare se non serve)
  ; G4 P100  ; Pausa 100ms

  ; Avanza al prossimo record
  set var.skip = var.skip + 2

echo ">>> Deposizione completata: " ^ var.pointCount ^ " punti depositati"
echo ">>> Volume totale: " ^ {var.pointCount * param.V} ^ " mm³"

M568 P0 S0:0

; Ritrazione finale opzionale
; G1 E-2 F300