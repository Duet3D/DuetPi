# Duet3D - GCode Dictionary

## Introduzione

I GCodes sono un linguaggio di controllo macchina ampiamente utilizzato. Sono leggibili e modificabili dall'uomo. Questa pagina descrive i GCodes supportati da RepRapFirmware.

RepRapFirmware segue la filosofia del "GCode ovunque", in sostanza l'interazione dell'utente o del programma esterno con il firmware dovrebbe avvenire attraverso i GCodes. Ci sono GCodes per tutti gli input di controllo e configurazione supportati insieme alle informazioni di stato e debug.

## GCode e RepRapFirmware

Un tipico pezzo di GCode inviato a una macchina che esegue RepRapFirmware potrebbe essere così:

```gcode
G10 P0 S195 R175
T0
G1 X100 Y100 Z0.3 F3000
G1 X100.4 Y99.3 E0.23 F600
```

### Origini del GCode

Il GCode può provenire da diverse fonti:
- Inserito dall'utente una riga alla volta (durante la configurazione o il test)
- Inviato dall'interfaccia utente in risposta alla pressione di pulsanti
- Proveniente da Macro attivate all'avvio, in determinate condizioni o chiamate dall'utente
- Da un file GCode normalmente memorizzato sulla scheda SD

### Commenti

I commenti GCode iniziano con un punto e virgola e terminano alla fine della riga:

```gcode
T0 ; Questo è un commento
G92 E0
;Anche questo
G28
```

In modalità CNC (M453), i commenti possono essere racchiusi tra parentesi singole: `(commento)`

### Struttura dei comandi

Una GCode RepRap è un elenco di campi separati da spazi o interruzioni di riga. Un campo può essere interpretato come comando, parametro o per qualsiasi altro scopo speciale.

#### Lettere dei comandi

| Lettera | Significato |
|---------|-------------|
| Gnnn | Comando GCode standard, come spostarsi in un punto |
| Mnnn | Comando definito da RepRap, come accendere una ventola di raffreddamento |
| Tnnn | Seleziona strumento nnn |
| Snnn | Parametro del comando (tempo in secondi, temperature) |
| Pnnn | Parametro del comando (tempo in millisecondi, proporzionale Kp nel PID) |
| Xnnn | Coordinata X |
| Ynnn | Coordinata Y |
| Znnn | Coordinata Z |
| U,V,W | Coordinate assi aggiuntivi |
| A,B,C | Coordinate assi aggiuntivi |
| Dnnn | Parametro - diametro, derivata (Kd) nel PID, numero drive |
| Innn | Parametro - offset X nel movimento ad arco, integrale (Ki) nel PID |
| Jnnn | Parametro - offset Y nel movimento ad arco |
| Kn | Tipicamente usato per il numero della sonda Z |
| Hnnn | Parametro - solitamente per un numero riscaldatore |
| Fnnn | Feedrate in mm al minuto (velocità di movimento della testina) |
| Rnnn | Parametro - usato per le temperature |
| Qnnn | Parametro - solitamente una frequenza |
| Ennn | Lunghezza del filamento da spostare attraverso l'estrusore |
| Nnnn | Numero di riga (opzionale) |
| *nnn | Checksum (opzionale) |

---

## Comandi G

### G0 e G1: Movimento lineare controllato

**Sintassi:**
- `G0 Xnnn Ynnn Znnn Ennn Fnnn Snnn Hnnn`
- `G1 Xnnn Ynnn Znnn Ennn Fnnn Snnn Hnnn`

**Parametri:**
- `Xnnn` - Posizione da raggiungere sull'asse X
- `Ynnn` - Posizione da raggiungere sull'asse Y
- `Znnn` - Posizione da raggiungere sull'asse Z
- `Ennn` - Quantità da estrudere tra punto di partenza e punto finale
- `Fnnn` - Velocità di avanzamento per minuto del movimento
- `Hnnn` - Tipo di movimento (RRF 2.02 e successivi)
- `Snnn` - Potenza laser (in modalità Laser M452)
- `Rn` - Ritorno alle coordinate memorizzate nel punto di ripristino #n

**Esempi:**
```gcode
G0 X12 ; sposta a 12mm sull'asse X
G0 F1500 ; imposta il feedrate a 1500mm/minuto
G1 X90.6 Y13.8 E22.4 ; sposta a X=90.6 Y=13.8 estrudendo 22.4mm di materiale
```

**Note importanti:**
- RepRapFirmware tratta G0 e G1 allo stesso modo tranne in modalità Laser/CNC
- In modalità Laser e CNC, G0 viene eseguito alla massima velocità disponibile
- Il feedrate è mantenuto come flag per ogni canale di input

### G2 e G3: Movimento ad arco

**G2:** Movimento ad arco in senso orario
**G3:** Movimento ad arco in senso antiorario

**Sintassi:**
- `G2 Xnnn Ynnn Znnn Innn Jnnn Ennn Fnnn`
- `G3 Xnnn Ynnn Znnn Innn Jnnn Ennn Fnnn`

**Parametri:**
- `Xnnn` - Posizione X finale
- `Ynnn` - Posizione Y finale
- `Znnn` - Posizione Z finale
- `Innn` - Coordinata X del centro dell'arco relativa alla posizione X corrente
- `Jnnn` - Coordinata Y del centro dell'arco relativa alla posizione Y corrente
- `Knnn` - Coordinata Z del centro dell'arco (RRF v3.3+)
- `Ennn` - Quantità da estrudere
- `Fnnn` - Velocità di avanzamento
- `Rnnn` - Raggio dell'arco (opzionale, RRF 2.03+)

**Esempi:**
```gcode
G2 X90.6 Y13.8 I5 J10 E22.4 ; arco orario
G3 X90.6 Y13.8 I5 J10 E22.4 ; arco antiorario
G2 X100 Y50 R200 ; arco orario con raggio 200
```

### G4: Pausa

Mette in pausa la macchina per un periodo di tempo.

**Parametri:**
- `Pnnn` - Tempo di attesa in millisecondi
- `Snnn` - Tempo di attesa in secondi

**Esempio:**
```gcode
G4 P200 ; attende 200 millisecondi
```

### G10: Imposta offset strumento / temperatura / retrazione

Questo comando ha diverse funzioni a seconda dei parametri utilizzati.

#### Impostazione temperatura strumento

**Parametri:**
- `Pnnn` - Numero dello strumento
- `Rnnn` - Temperatura standby
- `Snnn` - Temperatura attiva

**Esempio:**
```gcode
G10 P1 R140 S205 ; imposta temperature standby e attive per lo strumento 1
```

#### Impostazione offset strumento

**Parametri:**
- `Lnnn` - Modalità (L1=offset strumento, L2=offset coordinate)
- `Pnnn` - Numero strumento (L1) o sistema coordinate (L2)
- `Xnnn, Ynnn, Znnn` - Offset

**Esempio:**
```gcode
G10 P2 X17.8 Y-19.3 Z0.0 ; imposta offset per lo strumento 2
```

#### Retrazione filamento

**Sintassi:** `G10` (senza parametri)

Ritrae il filamento ed esegue qualsiasi sollevamento Z secondo le impostazioni di M207.

### G11: Unretraction

Recupera il filamento dopo aver annullato qualsiasi sollevamento Z secondo le impostazioni di M207.

### G17, G18, G19: Selezione piano per archi

- **G17** - Seleziona piano XY (default)
- **G18** - Seleziona piano XZ
- **G19** - Seleziona piano YZ

### G20 e G21: Unità di misura

- **G20** - Imposta unità in pollici
- **G21** - Imposta unità in millimetri (default)

### G28: Homing

Esegue l'homing degli assi specificati.

**Parametri:**
- `X, Y, Z, U, V, W, A, B, C, D` - Flag per gli assi da azzerare

**Esempi:**
```gcode
G28 ; azzera tutti gli assi
G28 XZ ; azzera solo X e Z
```

**Note:**
- Le stampanti Delta non possono azzerare assi individuali
- Il comportamento dell'homing è configurabile tramite file macro
- I file macro sono: homeall.g, homex.g, homey.g, homez.g, homedelta.g

### G29: Compensazione piano di stampa (Mesh Bed)

**Sintassi:**
- `G29` o `G29 S0` - Sonda il piano e salva la mappa altezze
- `G29 S1 [P"filename"]` - Carica mappa altezze da file
- `G29 S2` - Disabilita compensazione mesh
- `G29 S3 P"filename"` - Salva mappa altezze su file

**Parametri:**
- `Sn` - Modalità (0=sonda, 1=carica, 2=disabilita, 3=salva, 4=carica punti sonda)
- `P"file.csv"` - Nome file opzionale
- `Kn` - Numero sonda Z (default 0)

**Esempi:**
```gcode
G29 S0 ; sonda il piano e salva su "heightmap.csv"
G29 S1 P"usual.csv" ; carica mappa "usual.csv"
G29 S2 ; disabilita compensazione mesh
```

### G30: Sonda Z singola

Sonda il piano nella posizione corrente o specificata.

**Parametri:**
- `Pnnn` - Numero punto sonda
- `Xnnn, Ynnn` - Coordinate
- `Znnn` - Coordinata Z
- `Hnnn` - Correzione altezza
- `Snnn` - Imposta parametro
- `Kn` - Numero sonda Z

**Esempi:**
```gcode
G30 ; sonda nella posizione corrente
G30 S-1 ; sonda e riporta l'altezza
G30 S-2 ; sonda e regola l'offset Z dello strumento
G30 S-3 ; sonda e imposta l'altezza di trigger della sonda
```

**Per calibrazione multi-punto (bed.g):**
```gcode
G28 ; azzera
G30 P0 X20 Y190 Z-99999 ; punto sonda 0
G30 P1 X180 Y190 Z-99999 ; punto sonda 1
G30 P2 X100 Y10 Z-99999 S3 ; punto sonda 2 e calibra 3 motori
```

### G31: Imposta offset sonda Z

**Parametri (RRF 3.3+):**
- `Kn` - Numero sonda Z
- `Pnnn` - Valore di trigger
- `Znnn` - Altezza di trigger in mm
- `X,Y,U,V,W,A,B,C...nnn` - Offset sonda per tutti gli assi eccetto Z
- `Snnn` - Temperatura di calibrazione
- `Tnnn o Tnnn:nnn` - Coefficiente temperatura
- `Hnnn` - Numero sensore per compensazione temperatura

**Esempi:**
```gcode
G31 P500 Z2.6 ; imposta valore trigger e altezza
G31 X16.0 Y1.5 ; imposta offset XY
G31 Z1.2 T0.02 S20 H2 ; con compensazione temperatura
```

### G32: Calibrazione automatica

Esegue il file macro bed.g per la calibrazione automatica o il livellamento del piano.

**Esempio:**
```gcode
G32 ; esegue bed.g
```

### G38.2-G38.5: Sonda dritta

Movimenti di sondaggio in linea retta.

- **G38.2** - Sonda verso pezzo, ferma al contatto, segnala errore se fallisce
- **G38.3** - Sonda verso pezzo, ferma al contatto
- **G38.4** - Sonda via da pezzo, ferma alla perdita di contatto, segnala errore
- **G38.5** - Sonda via da pezzo, ferma alla perdita di contatto

**Parametri:**
- `X,Y,Z,U,V,W,A,B,Cnnn` - Posizione target
- `Knn` - Numero sonda
- `Fnnn` - Velocità di sondaggio (RRF 3.6.0+)

### G53: Coordinate macchina

Interpreta le coordinate come coordinate macchina per quella riga.

**Esempio:**
```gcode
G53 G1 X50 Y50 Z20 ; movimento in coordinate macchina
```

### G54-G59.3: Sistemi di coordinate

Seleziona il sistema di coordinate di lavoro (1-9).

- `G54` - Sistema coordinate 1
- `G55` - Sistema coordinate 2
- `G56` - Sistema coordinate 3
- `G57` - Sistema coordinate 4
- `G58` - Sistema coordinate 5
- `G59` - Sistema coordinate 6
- `G59.1` - Sistema coordinate 7
- `G59.2` - Sistema coordinate 8
- `G59.3` - Sistema coordinate 9

### G60: Salva posizione corrente

Salva la posizione corrente in uno slot di memoria.

**Parametri:**
- `Snn` - Numero slot di memoria (0-5, default 0)

**Esempio:**
```gcode
G60 S0 ; salva posizione nello slot 0
```

### G68: Rotazione coordinate

Ruota il sistema di coordinate nel piano corrente.

**Parametri:**
- `Xnnn, Ynnn` - Coordinate centro rotazione
- `Annn, Bnnn` - Alternativa per centro rotazione
- `Rnnn` - Angolo di rotazione in gradi

**Esempio:**
```gcode
G68 X0 Y0 R45 ; ruota di 45 gradi attorno all'origine
```

### G69: Cancella rotazione coordinate

Annulla qualsiasi rotazione impostata da G68.

### G90: Posizionamento assoluto

Tutte le coordinate sono assolute rispetto all'origine della macchina.

### G91: Posizionamento relativo

Tutte le coordinate sono relative all'ultima posizione.

### G92: Imposta posizione

Imposta la posizione corrente ai valori specificati.

**Parametri:**
- `Xnnn` - Nuova posizione asse X
- `Ynnn` - Nuova posizione asse Y
- `Znnn` - Nuova posizione asse Z
- `Ennn` - Nuova posizione estrusore

**Esempio:**
```gcode
G92 X10 E90 ; imposta posizione X a 10 e estrusore a 90
```

### G93: Modalità feedrate tempo inverso

In questa modalità, F significa che il movimento deve essere completato in (uno diviso F) minuti.

### G94: Modalità feedrate unità per minuto

F viene interpretato come unità al minuto (default).

---

## Comandi M

### M0: Stop

Arresta la stampa e esegue stop.g o cancel.g.

### M1: Sleep

Arresta la stampa ed esegue sleep.g, spegne motori e riscaldatori.

### M2: Termina job

Termina il job corrente (si comporta come M0).

### M3: Spindle/Laser ON (senso orario)

**Parametri:**
- `Snnn` - RPM spindle (modalità CNC/FFF) o potenza laser 0-255 (modalità laser)
- `Pnnn` - Slot spindle

**Esempi:**
```gcode
M3 S4000 ; modalità CNC, spindle a 4000 RPM
M3 S255 ; modalità laser, potenza massima
```

### M4: Spindle ON (senso antiorario)

**Parametri:**
- `Snnn` - RPM spindle
- `Pnnn` - Slot spindle

**Esempio:**
```gcode
M4 S4000 ; spindle a 4000 RPM antiorario
```

### M5: Spindle/Laser OFF

Spegne lo spindle o il laser.

### M17: Abilita motori

Abilita i motori specificati.

**Parametri:**
- `X, Y, Z, U, V, W...` - Assi da abilitare
- `E[n]` - Drive estrusore

**Esempi:**
```gcode
M17 ; abilita tutti i motori
M17 X E0 ; abilita solo X ed estrusore 0
```

### M18 / M84: Disabilita motori

Disabilita i motori specificati.

**Parametri:**
- `X, Y, Z, U, V, W...` - Assi da disabilitare
- `E[n]` - Drive estrusore

**Esempi:**
```gcode
M18 ; disabilita tutti i motori
M18 X E0:2 ; disabilita X ed estrusori 0 e 2
```

### M20: Lista file SD

Lista i file sulla scheda SD.

**Parametri:**
- `Snnn` - Stile output (0=testo, 2=JSON, 3=JSON verboso)
- `P"path"` - Cartella da listare
- `Rnnn` - Numero di file da saltare
- `Cnnn` - Numero massimo di elementi da ritornare (RRF 3.6.0+)

**Esempi:**
```gcode
M20 ; lista file nella cartella default
M20 S2 P"/gcodes/subdir" ; lista in formato JSON
M20 P"1:/" ; lista file sulla SD secondaria
```

### M21: Inizializza SD

Inizializza la scheda SD specificata.

**Parametri:**
- `Pnnn` - Numero scheda SD (default 0)

### M22: Rilascia SD

Rilascia la scheda SD specificata.

**Parametri:**
- `Pnnn` - Numero scheda SD (default 0)

### M23: Seleziona file SD

Seleziona un file per la stampa.

**Esempio:**
```gcode
M23 filename.gco
```

### M24: Avvia/Riprendi stampa SD

Avvia o riprende la stampa dal file selezionato con M23.

### M25: Pausa stampa SD

Mette in pausa la stampa corrente.

### M26: Imposta posizione file SD

Imposta la posizione in byte dall'inizio del file.

**Parametri:**
- `Snnn` - Posizione file in byte
- `Pnnn` - Proporzione della prima mossa da saltare (opzionale)
- `Xnnn, Ynnn, Znnn` - Coordinate centro arco (per G2/G3)

### M27: Report stato stampa SD

Riporta i byte processati e totali.

### M28: Inizia scrittura file SD

Crea un file sulla SD e scrive tutti i comandi successivi in quel file.

**Esempio:**
```gcode
M28 filename.gco
```

### M29: Termina scrittura file SD

Chiude il file aperto con M28.

### M30: Elimina file SD

Elimina il file specificato.

**Esempio:**
```gcode
M30 filename.g
M30 "filename.g"
```

### M32: Seleziona file e avvia stampa

Combina M23 e M24.

**Esempio:**
```gcode
M32 filename.g
```

### M36: Informazioni file

Ritorna informazioni in formato JSON per il file specificato.

**Esempio:**
```gcode
M36 "filename.g"
```

Risposta esempio:
```json
{
  "err":0,
  "size":436831,
  "fileName":"file.gcode",
  "lastModified":"2017-09-21T16:58:07",
  "height":5.20,
  "layerHeight":0.20,
  "printTime":660,
  "simulatedTime":1586,
  "filament":[1280.7],
  "generatedBy":"Simplify3D"
}
```

### M36.1: Recupera dati thumbnail

Recupera i dati delle immagini thumbnail incorporate nel file GCode.

**Parametri:**
- `P"filename"` - Nome file GCode
- `Snnnn` - Offset byte nel file

### M37: Modalità simulazione

Passa tra modalità stampa e simulazione per calcolare il tempo di stampa.

**Parametri:**
- `P"filename"` - Simula stampa file (opzionale)
- `Fn` - Aggiorna tempo simulato nel file (opzionale)
- `Snn` - Imposta modalità simulazione (se P non presente)

**Esempi:**
```gcode
M37 P"MyModel.g" ; simula file MyModel.g
M37 S2 ; imposta modalità simulazione debug
M37 S0 ; esci da modalità simulazione
```

### M38: Calcola hash file (RRF 3.6+)

Calcola l'hash CRC32 di un file sulla SD.

**Esempio:**
```gcode
M38 gcodes/myfile.g
```

### M39: Informazioni SD

Ritorna informazioni sulla scheda SD.

**Parametri:**
- `Pn` - Numero slot SD (default 0)
- `Sn` - Formato risposta (0=testo, 2=JSON)

**Esempi:**
```gcode
M39 ; info SD 0 in testo
M39 P1 S2 ; info SD 1 in JSON
```

### M42: Switch pin I/O

Commuta un pin I/O generico.

**Parametri (RRF 3.x):**
- `Pnnn` - Numero porta GPIO (definita da M950)
- `Snnn` - Valore pin (0.0-1.0 o 1-255)

**Esempio:**
```gcode
M950 P0 C"exp.heater3" Q500 ; alloca porta GPIO 0
M42 P0 S0.5 ; imposta 50% PWM sulla porta GPIO 0
```

### M73: Imposta tempo rimanente stampa

Informa il firmware sul tempo rimanente di stampa.

**Parametri:**
- `Pnn` - Percentuale completata (non usato da RRF)
- `Rnn` - Tempo rimanente in minuti
- `Cnn` - Tempo fino a interazione utente richiesta (RRF 3.6.0+)

### M80: Accendi alimentatore ATX

Accende l'alimentatore ATX dalla modalità standby.

**Parametri:**
- `C"port_name"` - Nome pin controllo alimentatore (RRF 3.4.0+)

**Esempi:**
```gcode
M80 ; accende alimentatore
M80 C"pson" ; alloca pin e accende
M80 C"!pson" ; inverte output per alimentatori Meanwell
```

### M81: Spegni alimentatore ATX

Spegne l'alimentatore ATX.

**Parametri:**
- `Sn` - Se S1, differisce lo spegnimento fino al completamento della stampa corrente
- `C"port_name"` - Nome pin controllo alimentatore (RRF 3.4.0+)

**Esempi:**
```gcode
M81 ; spegne immediatamente
M81 S1 ; spegne alla fine della stampa
```

**Note:**
- In RRF 3.4.0+, M81 non ha effetto a meno che un pin di controllo alimentazione non sia stato precedentemente assegnato usando M80 o M81 con il parametro C.

### M82: Estrusione assoluta

Fa sì che l'estrusore interpreti i valori di estrusione come posizioni assolute.

**Nota importante:** È fortemente raccomandato usare l'estrusione relativa, non assoluta. Questo è particolarmente vero per i sistemi multi-tool.

**Comportamento flag:**
- Ogni canale di input ha il proprio flag per lo stato assoluto/relativo dell'estrusore
- Alla fine dell'esecuzione di config.g, lo stato del flag viene copiato a tutti i canali
- Se non specificato in config.g, il default è M82 (assoluto)
- Lo stato del flag viene salvato all'inizio di una macro e ripristinato alla fine

### M83: Estrusione relativa

Fa sì che l'estrusore interpreti i valori di estrusione come posizioni relative.

**Raccomandato:** Questo è il metodo di estrusione raccomandato.

### M84: Stop idle hold

Ferma il mantenimento a riposo su tutti gli assi ed estrusori, disabilitando effettivamente i motori specificati.

**Deprecato in RRF 3.6.0+:** Usare M18 per disabilitare i motori e M906 T# per impostare il timeout idle.

**Parametri:**
- `Snnn` - Timeout idle in secondi
- `X, Y, Z, E...` - Motori specifici da disabilitare

**Esempi:**
```gcode
M84 ; disabilita tutti i motori
M84 S10 ; idle dopo 10 secondi di inattività
M84 X E0:2 ; disabilita X ed estrusori 0 e 2
```

**Note:**
- S0 non è valido. Per avere motori "sempre accesi", usare `M906 I100`

### M92: Imposta passi per unità

Imposta il numero di passi per unità per i driver motore.

**Parametri:**
- `Xnnn, Ynnn, Znnn` - Passi per mm per gli assi
- `Ennn` - Passi per mm per l'estrusore
- `Snnn` - Microstepping in cui sono dati i passi (RRF 2.03+)

**Esempi:**
```gcode
M92 X80 Y80 Z400 E420 ; imposta passi/mm
M92 X80 Y80 Z400 E420 S16 ; con microstepping 16
```

**Note:**
- RepRapFirmware usa matematica a virgola mobile, quindi sono possibili valori decimali
- Per assi con motori multipli, il primo parametro viene applicato a tutti i motori
- Se riferito ad assi oltre XYZ, deve essere dopo M584 in config.g

### M98: Chiama Macro/Subprogramma

Esegue un file macro.

**Parametri:**
- `P"nnn"` - Nome file macro (percorso default: /sys)
- `Rn` - Indica se la macro può essere messa in pausa (RRF 3.4+)

**Esempi:**
```gcode
M98 P"mymacro.g" ; esegue /sys/mymacro.g
M98 P"/macros/test.g" ; esegue dalla cartella macros
```

**Parametri aggiuntivi (RRF 3.3+):**
- I parametri aggiuntivi possono essere passati alla macro
- All'interno della macro, si accede con `param.X` dove X è una lettera maiuscola
- Esempio: `M98 P"test.g" S10` → nella macro: `{param.S}` restituisce 10

### M99: Ritorna da Macro

Ritorna da una chiamata M98. Non è richiesto alla fine di una macro, che ritorna naturalmente alla fine del file.

### M104: Imposta temperatura estrusore

Imposta la temperatura target dell'estrusore senza attendere.

**Deprecato:** Questo comando è deprecato per macchine multi-tool. Usare G10/M568.

**Parametri:**
- `Snnn` - Temperatura target in gradi Celsius
- `Tnnn` - Numero tool (opzionale)

**Esempi:**
```gcode
M104 S190 ; imposta a 190°C
M104 S190 T0 ; imposta tool 0 a 190°C
```

### M105: Richiedi temperatura

Richiede le temperature di estrusore e piano.

**Parametri:**
- `Sn` - Formato risposta (S2=JSON come M408 S0, S3=JSON come M408 S2) - deprecato

**Esempio:**
```gcode
M105 ; riporta temperature correnti e target
```

**Risposta tipica:**
```
ok T:19.4 /0.0 B:19.1 /0.0
```

### M106: Ventola ON

Controlla le ventole di stampa.

**Parametri (RRF 3.x):**
- `Pnnn` - Numero ventola (correlato al numero creato da M950)
- `Snnn` - Velocità ventola (0-1.0 o 0-255)
- `Hnnn` - Selezione sensore per controllo termostatico
- `Tnnn` - Temperatura trigger per modalità termostatica
- `Bnnn` - Valore soffiatura (blip value)
- `Lnnn` - Velocità minima ventola
- `Xnnn` - Velocità massima ventola
- `Cnnn` - Parametri PWM (C"nome_pin" per invertire)
- `Qnnn` - Frequenza PWM

**Esempi:**
```gcode
M106 P0 S255 ; ventola 0 al 100%
M106 P0 S0.5 ; ventola 0 al 50%
M106 P1 H1 T45 ; ventola termostatica, attiva a 45°C su heater 1
```

**Note:**
- In RRF 3.x, le ventole devono essere create prima con M950
- La ventola di stampa associata allo strumento corrente viene controllata
- Vedi documentazione M563 per associare ventole agli strumenti

### M107: Ventola OFF

Spegne la ventola di stampa corrente.

**Deprecato in RRF:** Usare `M106 S0` invece.

**Esempio:**
```gcode
M107 ; equivalente a M106 S0
```

### M108: Cancella attesa riscaldamento

Interrompe un loop di attesa temperatura M109 o M190, continuando il job di stampa.

**Attenzione:** Usare con cautela! Può causare estrusione a freddo o inceppamento estrusore.

### M109: Imposta temperatura e attendi

Imposta la temperatura target dell'estrusore e attende il raggiungimento.

**Deprecato in RRF:** Usare G10/M568 seguito da M116.

**Parametri:**
- `Snnn` - Temperatura target (attende solo quando riscalda)
- `Rnnn` - Temperatura target (attende sia riscaldando che raffreddando)
- `Tnnn` - Numero tool (opzionale)

**Esempi:**
```gcode
M109 S190 ; imposta a 190°C e attendi
M109 R50 ; attendi fino a raggiungere 50°C (riscaldando o raffreddando)
```

**Note:**
- M109 non attende temperature sotto 40°C (per evitare attese infinite per temperatura ambiente)
- Se nessuno strumento è selezionato, RRF selezionerà lo strumento con il numero più basso

### M110: Imposta numero riga corrente

Imposta il numero di riga corrente per i comandi GCode.

**Parametri:**
- `Nnnn` - Numero riga

**Esempio:**
```gcode
M110 N123 ; la prossima riga sarà 124
```

### M111: Imposta livello debug

Abilita o disabilita le funzionalità di debug per il modulo specificato.

**Parametri:**
- `Pnn` - Numero modulo
- `Snnn` - Flag di debug

**Esempio:**
```gcode
M111 ; elenca tutti i moduli
M111 P1 S1 ; abilita debug per modulo 1
```

**Nota:** La qualità di stampa può essere influenzata quando l'output di debug è abilitato a causa del volume di dati inviati via USB.

### M112: Arresto di emergenza

Arresta immediatamente tutti i motori e riscaldatori.

**Esempio:**
```gcode
M112 ; EMERGENZA STOP
```

**Nota:** Questo comando termina immediatamente l'esecuzione. Richiede reset per riprendere.

### M114: Posizione corrente

Riporta la posizione corrente degli assi.

**Esempio:**
```gcode
M114
```

**Risposta tipica:**
```
X:0.00 Y:0.00 Z:0.00 E:0.00 Count 0 0 0
```

### M115: Informazioni firmware

Riporta versione firmware e capacità.

**Esempio:**
```gcode
M115
```

**Risposta tipica:**
```
FIRMWARE_NAME: RepRapFirmware FIRMWARE_VERSION: 3.4.0 ELECTRONICS: Duet 3 MB6HC FIRMWARE_DATE: 2021-11-09
```

### M116: Attendi

Attende che tutti i riscaldatori e altre temperature raggiungano i loro valori target.

**Parametri:**
- `Pnnn` - Numero tool (attende solo i riscaldatori di quel tool)
- `Hnnn` - Numero riscaldatore specifico
- `Snnn` - Tolleranza in gradi Celsius (default 1°C)
- `Tnnn` - Timeout in secondi (opzionale, RRF 3.5+)

**Esempi:**
```gcode
M116 ; attendi tutti i riscaldatori
M116 P0 ; attendi solo i riscaldatori del tool 0
M116 H1 ; attendi solo riscaldatore 1
M116 S2 ; attendi con tolleranza di 2°C
```

### M117: Mostra messaggio

Mostra un messaggio sul display LCD o nell'interfaccia web.

**Esempio:**
```gcode
M117 "Stampa in corso..."
```

### M118: Invia messaggio

Invia un messaggio a uno specifico target (USB, Telnet, HTTP, ecc.).

**Parametri:**
- `Sn` - Tipo messaggio (0=generico, 1=USB, 2=HTTP/Telnet, 3=tutti, 4=log file)
- `Pn` - Opzioni messaggio

**Esempi:**
```gcode
M118 S1 P0 "Messaggio USB"
M118 "Messaggio generico"
```

### M119: Stato endstop

Riporta lo stato corrente di tutti gli endstop.

**Esempio:**
```gcode
M119
```

**Risposta tipica:**
```
Endstops - X: not stopped, Y: not stopped, Z: not stopped, Z probe: not stopped
```

### M120: Push stato

Salva lo stato corrente (posizione, modalità, ecc.) su uno stack.

### M121: Pop stato

Ripristina lo stato dallo stack.

### M122: Diagnostica

Riporta informazioni diagnostiche dettagliate su driver, temperatura, rete, ecc.

**Parametri:**
- `Pnnn` - Tipo di diagnostica
- `Bn` - Numero scheda (solo Duet 3)
- `Dn` - Diagnostica per driver specifico

**Esempi:**
```gcode
M122 ; diagnostica generale
M122 P0 ; diagnostica driver
```

### M140: Imposta temperatura piano (veloce)

Imposta la temperatura target del piano riscaldato senza attendere.

**Parametri (RRF 3.x):**
- `Hnnn` - Numero riscaldatore (default 0)
- `Snnn` - Temperatura target in °C
- `Rnnn` - Temperatura standby in °C (opzionale)

**Esempi:**
```gcode
M140 S60 ; imposta piano a 60°C
M140 H0 S60 R40 ; imposta piano a 60°C attivo, 40°C standby
```

**Note:**
- In RRF 3.x, il riscaldatore deve essere creato prima con M950
- Comando deprecato per impostare la temperatura, usare preferibilmente M568

### M141: Imposta temperatura camera

Imposta la temperatura target della camera/involucro senza attendere.

**Parametri (RRF 3.x):**
- `Hnnn` - Numero riscaldatore camera
- `Snnn` - Temperatura target in °C
- `Rnnn` - Temperatura standby in °C (opzionale)

**Esempi:**
```gcode
M141 S40 ; imposta camera a 40°C
M141 H2 S40 ; imposta riscaldatore 2 (camera) a 40°C
```

### M143: Temperatura massima riscaldatore

Imposta la temperatura massima per un riscaldatore prima che venga spento per sicurezza.

**Parametri:**
- `Hnnn` - Numero riscaldatore
- `Snnn` - Temperatura massima in °C
- `Pnnn` - Tipo di monitor (0=disabilitato, 1=troppo alto, 2=troppo basso, 3=entrambi)

**Esempi:**
```gcode
M143 H1 S280 ; temperatura max 280°C per heater 1
M143 H0 S120 ; temperatura max 120°C per il piano
```

### M144: Standby piano

Imposta il piano in modalità standby.

**Deprecato:** Usare M568 invece.

### M190: Attendi temperatura piano

Imposta la temperatura del piano e attende il raggiungimento.

**Parametri:**
- `Snnn` - Temperatura target (attende solo quando riscalda)
- `Rnnn` - Temperatura target (attende sia riscaldando che raffreddando)
- `Hnnn` - Numero riscaldatore (opzionale)

**Esempi:**
```gcode
M190 S60 ; imposta piano a 60°C e attendi
M190 R50 ; attendi fino a raggiungere 50°C
```

**Note:**
- Simile a M109 ma per il piano riscaldato
- Comando deprecato, usare M568 seguito da M116

### M191: Attendi temperatura camera

Imposta la temperatura della camera e attende il raggiungimento.

**Parametri:**
- `Snnn` - Temperatura target (attende solo quando riscalda)
- `Rnnn` - Temperatura target (attende sia riscaldando che raffreddando)

**Esempio:**
```gcode
M191 S40 ; imposta camera a 40°C e attendi
```

### M200: Imposta diametro filamento

Imposta il diametro del filamento per l'estrusione volumetrica.

**Deprecato in RRF 3.x:** L'estrusione volumetrica non è più supportata.

**Parametri:**
- `Dnnn` - Diametro filamento in mm (D0 disabilita estrusione volumetrica)

### M201: Imposta accelerazione massima

Imposta l'accelerazione massima per gli assi.

**Parametri:**
- `Xnnn, Ynnn, Znnn` - Accelerazione assi in mm/s²
- `Ennn` - Accelerazione estrusore in mm/s²
- `Unnn, Vnnn, Wnnn...` - Assi aggiuntivi

**Esempi:**
```gcode
M201 X1000 Y1000 Z100 E5000 ; imposta accelerazioni
M201 X500 Y500 ; modifica solo X e Y
```

**Note:**
- Se riferito ad assi oltre XYZ, deve essere dopo M584 in config.g
- Questo comando attende il completamento di tutti i movimenti prima dell'esecuzione

### M201.1: Accelerazione ridotta per movimenti speciali

Imposta accelerazioni ridotte per tipi di movimento speciali (RRF 3.5+).

**Parametri:**
- `Xnnn, Ynnn, Znnn, Ennn` - Accelerazione ridotta per tipo movimento
- `Tnnn` - Tipo movimento (T0=homing, T1=probing)

### M203: Imposta velocità massima

Imposta la velocità massima (feedrate) per gli assi.

**Parametri:**
- `Xnnn, Ynnn, Znnn` - Velocità massima assi in mm/min
- `Ennn` - Velocità massima estrusore in mm/min
- `Innn` - Velocità minima movimento in mm/s (default 0.5)

**Esempi:**
```gcode
M203 X6000 Y6000 Z600 E1200 ; velocità in mm/min
M203 X100 Y100 Z10 E20 ; equivalente in mm/s dopo conversione
M203 I0.5 ; imposta velocità minima a 0.5 mm/s
```

**Note:**
- I valori sono in mm/min, non mm/s
- La velocità minima (parametro I) è importante per utenti CNC
- Se riferito ad assi oltre XYZ, deve essere dopo M584 in config.g

### M204: Imposta accelerazioni stampa e spostamento

Imposta l'accelerazione per movimenti di stampa e spostamento.

**Parametri:**
- `Pnnn` - Accelerazione per movimenti di stampa (con estrusione) in mm/s²
- `Tnnn` - Accelerazione per movimenti di spostamento (senza estrusione) in mm/s²

**Esempio:**
```gcode
M204 P1000 T1500 ; stampa 1000, spostamento 1500 mm/s²
```

**Note:**
- Se entrambi i parametri vengono omessi, il comando non ha effetto
- In Marlin questi valori sovrascrivono M201, in RRF lavorano insieme

### M205: Impostazioni avanzate

Imposta le impostazioni avanzate di velocità.

**Deprecato in RRF:** Usare M566 per impostare il jerk.

**Parametri (solo per compatibilità):**
- `Xnnn, Ynnn, Znnn, Ennn` - Jerk massimo in mm/s

### M206: Offset assi

Applica un offset agli assi.

**Deprecato in RRF:** Gli offset sono gestiti tramite G10 e i sistemi di coordinate di lavoro (G54-G59).

### M207: Imposta lunghezza retrazione

Imposta i parametri per la retrazione firmware (G10/G11).

**Parametri:**
- `Snnn` - Lunghezza retrazione in mm (positivo = retrazione)
- `Rnnn` - Lunghezza unretract extra in mm
- `Fnnn` - Velocità retrazione in mm/min
- `Tnnn` - Velocità unretract in mm/min (opzionale, default = velocità retrazione)
- `Znnn` - Z-hop/lift durante retrazione in mm

**Esempi:**
```gcode
M207 S4.0 F3000 Z0.2 ; retrai 4mm a 50mm/s con hop 0.2mm
M207 S5.0 R0.5 F2400 T2400 Z0.0 ; retrai 5mm, extra 0.5mm
```

**Note:**
- Questi valori vengono usati dai comandi G10 (retract) e G11 (unretract)
- Il Z-hop solleva il nozzle durante la retrazione per evitare stringing

### M208: Imposta limiti massimi assi

Imposta i limiti minimi e massimi di spostamento per gli assi.

**Parametri:**
- `Xnnn, Ynnn, Znnn` - Limiti assi in mm
- `Snnn` - S0 = massimi (default), S1 = minimi
- `Unnn, Vnnn, Wnnn...` - Assi aggiuntivi

**Esempi:**
```gcode
M208 X200 Y200 Z200 ; imposta massimi
M208 X0 Y0 Z0 S1 ; imposta minimi
M208 X-5 Y-5 Z-2 S1 ; minimi con valori negativi
```

**Note:**
- Chiamato due volte: prima per minimi (S1), poi per massimi (S0)
- Su stampanti Delta, il parametro Z imposta il raggio massimo ammesso dalla torre
- Se riferito ad assi oltre XYZ, deve essere dopo M584 in config.g

### M220: Override velocità percentuale

Imposta un fattore di override per la velocità di stampa.

**Parametri:**
- `Snnn` - Percentuale velocità (default 100)

**Esempi:**
```gcode
M220 S100 ; velocità normale (100%)
M220 S50 ; metà velocità (50%)
M220 S150 ; 1.5x velocità (150%)
```

**Note:**
- Influenza tutti i movimenti eccetto homing e probing
- Può essere modificato durante la stampa per tuning in tempo reale

### M221: Override estrusione percentuale

Imposta un fattore di override per l'estrusione.

**Parametri:**
- `Snnn` - Percentuale estrusione (default 100)
- `Dnnn` - Numero estrusore (opzionale)

**Esempi:**
```gcode
M221 S100 ; estrusione normale
M221 S95 ; riduce estrusione al 95%
M221 D0 S105 ; aumenta estrusione estrusore 0 al 105%
```

**Note:**
- Utile per compensare variazioni nel diametro del filamento
- Modificabile durante la stampa

### M226: Pausa sincrona

Mette in pausa la stampa nel file GCode corrente. Attende il completamento di tutti i movimenti in coda prima di pausare.

**Esempio:**
```gcode
M226 ; pausa sincrona
```

**Nota:** Da usare all'interno dei file GCode. Per pausare da interfaccia utente, usare M25.

### M280: Posizione servo

Imposta la posizione di un servo.

**Parametri:**
- `Pnnn` - Numero servo/GPIO
- `Snnn` - Posizione (larghezza impulso in microsec o angolo 0-180°)

**Esempi:**
```gcode
M280 P0 S90 ; servo 0 a 90 gradi
M280 P1 S1500 ; servo 1 con impulso 1500µs
```

**Note:**
- In RRF 3.x, i servo devono essere creati prima con M950
- Usato spesso per controllare probe retrattili (BLTouch, ecc.)

### M290: Baby stepping

Applica un offset Z senza modificare le coordinate visualizzate.

**Parametri:**
- `Snnn` - Offset Z in mm (cumulativo o assoluto a seconda di R)
- `Rn` - R0 = relativo (default), R1 = assoluto (reset prima)
- `Znnn` - Alternativa a S per specificare offset Z

**Esempi:**
```gcode
M290 S0.05 ; aumenta Z di 0.05mm
M290 Z-0.1 R0 ; diminuisce Z di 0.1mm relativamente
M290 R1 S0.2 ; imposta offset assoluto a 0.2mm
```

**Note:**
- Utile per compensare piccole variazioni dell'altezza del primo layer
- Non modifica la posizione Z visualizzata
- L'offset viene perso al riavvio o al nuovo homing

### M291: Mostra messaggio e attendi risposta

Mostra un messaggio e opzionalmente attende una risposta dall'utente.

**Parametri:**
- `P"message"` - Messaggio da visualizzare
- `Rn` - Tipo messaggio (R"title" = titolo)
- `Sn` - Modalità (S0=nessun pulsante, S1=Chiudi, S2=OK/Annulla, S3=OK)
- `Tnnn` - Timeout in secondi (opzionale)
- `Zn` - Flag (Z1=axe controls disabilitati durante il dialogo)

**Esempi:**
```gcode
M291 P"Stampa completata!" S1 ; messaggio con pulsante Chiudi
M291 P"Continuare?" R"Conferma" S2 ; dialogo OK/Annulla
M291 P"Inserire filamento" S3 T30 ; attende OK o timeout 30s
```

**Note:**
- S2 e S3 attendono risposta utente (confermare con M292)
- Molto utile per interazioni utente in macro

### M292: Conferma messaggio

Riconosce un messaggio bloccante mostrato da M291.

**Parametri:**
- `Pn` - Risposta (P0=Annulla, P1=OK)

**Esempio:**
```gcode
M292 P1 ; conferma OK
```

### M300: Suona beep

Riproduce un suono beep.

**Parametri:**
- `Snnn` - Frequenza in Hz
- `Pnnn` - Durata in millisecondi

**Esempi:**
```gcode
M300 S1000 P500 ; beep 1000Hz per 500ms
M300 S2000 P200 ; beep 2000Hz per 200ms
```

**Note:**
- Se è presente un display LCD, il suono viene riprodotto tramite esso
- Altrimenti l'interfaccia web riproduce il suono
- Per suonare note multiple, inserire G4 (pausa) tra di esse

### M301: Imposta parametri PID

Imposta i parametri PID per un hotend.

**Deprecato:** Il tuning PID viene fatto automaticamente con M303.

**Parametri:**
- `Hn` - Numero riscaldatore
- `Pnnn` - Proporzionale (P) * 255
- `Innn` - Integrale (I) * 255
- `Dnnn` - Derivativo (D) * 255

**Note:**
- I valori devono essere moltiplicati per 255 per compatibilità
- I parametri PID vengono calcolati automaticamente da M303

### M302: Permetti estrusione a freddo

Permette o impedisce l'estrusione quando la temperatura è sotto il minimo.

**Parametri:**
- `Pn` - P0 = non permettere (default), P1 = permettere
- `Snnn` - Temperatura minima per estrusione (default 160°C)
- `Rnnn` - Temperatura minima per retrazione (opzionale)

**Esempi:**
```gcode
M302 ; disabilita estrusione a freddo
M302 P1 ; permetti estrusione a freddo
M302 S180 ; imposta minimo a 180°C
```

**Attenzione:** Abilitare l'estrusione a freddo può causare inceppamenti!

### M303: Tuning PID riscaldatore

Esegue il tuning PID automatico per un riscaldatore.

**Parametri:**
- `Hnnn` - Numero riscaldatore
- `Snnn` - Temperatura target per tuning
- `Pnnn` - PWM da usare (0.0-1.0, opzionale)
- `Cn` - Numero di cicli (RRF 3.5+, default basato su modello heater)

**Esempi:**
```gcode
M303 H1 S200 ; tuning hotend 1 a 200°C
M303 H0 S60 ; tuning piano a 60°C
M303 H1 S240 P0.5 ; tuning con PWM 50%
```

**Note:**
- Il tuning è asincrono - continua in background
- Inviare M303 senza parametri durante tuning per vedere lo stato
- L'algoritmo sovrapassa la temperatura target
- Vedi la documentazione wiki per maggiori dettagli

### M304: Imposta parametri PID piano

Identico a M301 ma per il piano riscaldato (H default = 0).

**Deprecato:** Usare M301 specificando il numero riscaldatore.

### M307: Parametri processo riscaldamento

Imposta o riporta i parametri del processo di riscaldamento per un riscaldatore.

**Parametri:**
- `Hnnn` - Numero riscaldatore
- `Ann` - Guadagno (A)
- `Cnn` - Costante tempo riscaldamento (C)
- `Dnn` - Costante tempo raffreddamento (D)
- `Vnn` - Tensione alimentazione (V)
- `Bnn` - Bang-bang mode (B0=PID, B1=bang-bang)

**Esempi:**
```gcode
M307 H1 ; riporta parametri heater 1
M307 H1 A340.0 C140.0 D5.5 V24.0 ; imposta parametri
M307 H3 A-1 C-1 D-1 ; disabilita heater 3 per usare come GPIO
```

**Note:**
- Questi parametri vengono calcolati automaticamente da M303
- Impostare A=-1 C=-1 D=-1 disabilita il riscaldatore per altri usi

### M308: Parametri sensore temperatura

Configura un sensore di temperatura.

**Parametri (RRF 3.x):**
- `Snn` - Numero sensore
- `P"pin"` - Pin sensore
- `Y"type"` - Tipo sensore (thermistor, pt1000, rtd-max31865, thermocouple-max31855, ecc.)
- `A"name"` - Nome sensore (opzionale)
- `Tnnn` - Parametro T (per termistori: resistenza a 25°C)
- `Bnnn` - Parametro B (per termistori: coefficiente beta)
- `Cnnn` - Parametro C (per termistori: coefficiente C)
- `Rnnn` - Resistenza serie (per termistori e RTD)

**Esempi:**
```gcode
; Termistore NTC 100K
M308 S0 P"temp0" Y"thermistor" T100000 B4092

; PT1000 su Duet 3
M308 S1 P"temp1" Y"pt1000"

; Termocoppia con MAX31855
M308 S2 P"spi.cs2" Y"thermocouple-max31855"

; Sensore DHT22 (temperatura e umidità)
M308 S3 P"io3.in" Y"dht22" A"Camera"
```

**Note:**
- In RRF 3.x, i sensori devono essere creati prima di essere usati da riscaldatori
- Questo comando sostituisce M305 di RRF 2.x

### M309: Heater feedforward

Imposta o riporta i parametri di feedforward per un riscaldatore (RRF 3.5+).

**Parametri:**
- `Hnnn` - Numero riscaldatore
- `Annn` - Feedforward guadagno estrusione
- `Bnnn` - Feedforward guadagno ventola
- `Cnnn` - Feedforward guadagno velocità

### M350: Modalità microstepping

Imposta la modalità di microstepping per i driver dei motori.

**Parametri:**
- `Xnnn, Ynnn, Znnn, Ennn` - Microstepping per ciascun asse/estrusore
- `In` - Interpolazione (I1=abilita, I0=disabilita)

**Esempi:**
```gcode
M350 X16 Y16 Z16 E16 I1 ; 16x microstepping con interpolazione
M350 X32 Y32 Z16 E16 I0 ; 32x per XY, 16x per Z e E
```

**Note:**
- Valori comuni: 1, 2, 4, 8, 16, 32, 64, 128, 256
- L'interpolazione (a 256x) è supportata dai driver TMC
- Deve essere prima di M92 (passi per mm) in config.g

### M374: Salva height map

Salva la mappa delle altezze corrente (mesh bed compensation) su file.

**Deprecato:** Usare G29 S3 invece.

### M375: Carica height map

Carica una mappa delle altezze da file.

**Deprecato:** Usare G29 S1 invece.

### M376: Taper compensazione piano

Imposta l'altezza a cui la compensazione del piano viene gradualmente ridotta a zero.

**Parametri:**
- `Hnnn` - Altezza taper in mm (H0 = nessun taper)

**Esempi:**
```gcode
M376 H5 ; taper su 5mm
M376 H0 ; nessun taper (compensazione sempre attiva)
```

**Nota:** Usato per evitare che la compensazione influenzi le parti superiori della stampa.

### M400: Attendi completamento movimenti

Attende che tutti i movimenti in coda siano completati prima di procedere.

**Esempio:**
```gcode
M400 ; attendi completamento movimenti
```

**Note:**
- Utile prima di eseguire operazioni che richiedono la macchina ferma
- Es: prima di cambiare parametri motori, prima di sondare, ecc.

### M401: Estendi sonda Z

Estende una sonda Z retrattile (come BLTouch).

**Esempio:**
```gcode
M401 ; estendi sonda
```

**Nota:** Esegue il file macro deployprobe.g se presente.

### M402: Ritrai sonda Z

Ritrae una sonda Z retrattile.

**Esempio:**
```gcode
M402 ; ritrai sonda
```

**Nota:** Esegue il file macro retractprobe.g se presente.

### M450: Modalità FFF/FDM (Default)

Seleziona la modalità stampante FFF/FDM (Fused Filament Fabrication).

**Esempio:**
```gcode
M450 ; modalità FFF
```

### M451: Seleziona modalità FFF/FDM

Alternativa a M450 (RRF 3.5+).

### M452: Seleziona modalità Laser

Passa alla modalità controllo laser.

**Parametri:**
- `Pnnn` - Numero porta logica per controllo laser
- `Rnnn` - Potenza laser massima (0-255 o 0-1.0)
- `Snnn` - Modalità sticky (S0=non-sticky default, S1=sticky)

**Esempi:**
```gcode
M452 P2 R255 ; modalità laser, GPIO 2, potenza max 255
M452 C"exp.heater3" R255 S1 ; usando nome pin, sticky mode
```

### M453: Seleziona modalità CNC

Passa alla modalità controllo CNC/fresatura.

**Esempio:**
```gcode
M453 ; modalità CNC
```

**Note:**
- In modalità CNC, i commenti possono essere racchiusi tra parentesi `(comment)`
- G0 viene eseguito alla massima velocità (M203)

### M500: Salva parametri

Salva i parametri correnti nella memoria non volatile (EEPROM/SD).

**Parametri:**
- `Pnn` - Cartella di salvataggio (P10=/sys, P31=/sys/filaments)

**Esempio:**
```gcode
M500 P10 ; salva in /sys/config-override.g
```

### M501: Carica parametri salvati

Carica i parametri dalla memoria non volatile.

**Parametri:**
- `Pnn` - Cartella di caricamento

**Esempio:**
```gcode
M501 ; carica config-override.g
```

**Nota:** Tipicamente chiamato alla fine di config.g

### M502: Ripristina valori di fabbrica

Ripristina tutti i parametri ai valori predefiniti (senza salvarli).

### M503: Riporta impostazioni

Riporta le impostazioni correnti del firmware.

### M550: Imposta nome macchina

Imposta il nome della stampante/macchina.

**Parametri:**
- `P"nome"` - Nome macchina

**Esempio:**
```gcode
M550 P"My Printer" ; imposta nome
```

### M551: Imposta password

Imposta una password per l'accesso web (deprecato per sicurezza).

### M552: Imposta/abilita rete

Configura e abilita/disabilita l'interfaccia di rete.

**Parametri:**
- `Snn` - S0=disabilita, S1=abilita
- `P"ip"` - Indirizzo IP (opzionale)

**Esempi:**
```gcode
M552 S1 ; abilita rete (DHCP)
M552 P192.168.1.100 S1 ; IP statico
M552 S0 ; disabilita rete
```

### M553: Imposta netmask

Imposta la maschera di rete (deprecato, usare configurazione sistema operativo in modalità SBC).

### M554: Imposta gateway

Imposta il gateway di rete (deprecato).

### M555: Compatibilità firmware

Imposta la modalità di compatibilità con altri firmware.

**Parametri:**
- `Pn` - P0=RepRap, P1=Marlin, P2=Teacup, P3=Sprinter, P4=Repetier, P6=nanoDLP

**Esempio:**
```gcode
M555 P1 ; emula Marlin
```

### M556: Compensazione assi non ortogonali

Compensa assi non perfettamente ortogonali (skew compensation).

**Parametri:**
- `Snnn` - Fattore di scala deviazione
- `Xnnn, Ynnn, Znnn` - Correzioni angolari

**Esempio:**
```gcode
M556 S100 X0.7 Y-0.2 Z0
```

### M557: Definisci griglia sonda Z

Definisce la griglia di punti per il mesh bed compensation (G29).

**Parametri:**
- `Xnnn:nnn` - Range X (min:max)
- `Ynnn:nnn` - Range Y (min:max)
- `Snnn:nnn` - Spaziatura griglia (X:Y) o numero punti
- `Pnnn:nnn` - Numero punti sonda (X:Y)

**Esempi:**
```gcode
M557 X20:180 Y20:180 S40 ; griglia 20-180mm, step 40mm
M557 X20:180 Y20:180 P5:5 ; griglia 5x5 punti
```

### M558: Configura tipo sonda Z

Configura il tipo e i parametri della sonda Z.

**Parametri (RRF 3.x):**
- `Kn` - Numero sonda Z
- `Pn` - Tipo sonda (vedi documentazione)
- `C"pin"` - Pin input sonda
- `Hnnn` - Altezza dive (mm)
- `Fnnn:nnn` - Velocità sondaggio (veloce:lento mm/min)
- `Tnnn` - Velocità spostamento tra punti (mm/min)
- `Annn` - Tentativi max per punto
- `Snnn` - Tolleranza (mm)
- `Rn` - Recupero (R0=off, R1=on)
- `B0/B1` - B1=usa filtro mediano

**Esempi:**
```gcode
; BLTouch
M558 K0 P9 C"^zprobe.in" H5 F120 T6000

; Induttivo semplice
M558 K0 P5 C"^zprobe.in" H5 F400 T6000

; Switch meccanico
M558 K0 P8 C"^zprobe.in" H5 F300 T3000
```

### M563: Definisci tool

Definisce uno strumento (tool/hotend) con drive estrusori e riscaldatori.

**Parametri:**
- `Pn` - Numero tool
- `Dnnn` - Numero drive estrusore (può essere lista)
- `Hnnn` - Numero riscaldatore (può essere lista)
- `Fnnn` - Numero ventola (può essere lista)
- `Xnnn` - Mapping asse X (per tool multipli IDEX)
- `S"nome"` - Nome tool
- `Lnnn` - Spindle mapping (RRF 3.3+)

**Esempi:**
```gcode
; Tool singolo standard
M563 P0 D0 H1 F0 ; tool 0, drive 0, heater 1, fan 0

; Tool Dual extruder
M563 P1 D0:1 H1:2 F0:1 S"Dual" ; 2 drive, 2 heater, 2 fan

; Tool IDEX
M563 P0 D0 H1 X0 F0 ; tool 0 su carriage X
M563 P1 D1 H2 X1 F1 ; tool 1 su carriage separato
```

**Note:**
- I tool devono essere creati dopo aver definito drive (M584), heater (M950), fan (M950)
- Usare G10 o M568 per impostare le temperature del tool

### M564: Limiti assi

Abilita/disabilita i limiti di movimento degli assi.

**Parametri:**
- `Sn` - S0=ignora limiti, S1=rispetta limiti (default)
- `Hn` - H0=richiedi homing prima movimento, H1=permetti movimento senza homing

**Esempi:**
```gcode
M564 S1 H1 ; limiti attivi, movimento senza homing permesso
M564 S0 ; ignora limiti assi
```

### M566: Jerk (cambio velocità istantaneo)

Imposta il massimo cambio di velocità istantaneo permesso (jerk).

**Parametri:**
- `Xnnn, Ynnn, Znnn, Ennn` - Jerk per asse in mm/min
- `Pn` - P1=usa jerk junction invece di jerk istantaneo (RRF 3.3+)

**Esempi:**
```gcode
M566 X900 Y900 Z12 E120 ; jerk in mm/min
M566 X15 Y15 Z0.2 E2 P1 ; jerk junction in mm/s
```

### M569: Configura driver motore

Configura direzione, polarità e timing dei driver motori.

**Parametri:**
- `Pnn` - Numero driver (es: P0, P1.0 per CAN)
- `Sn` - S0=indietro, S1=avanti
- `Rn` - Polarità enable (R0=active low, R1=active high)
- `Tnnn:nnn:nnn:nnn` - Timing step/dir in microsecondi
- `Dn` - Modalità driver (D2=stealthChop, D3=spreadCycle per TMC)
- `Vnn` - Tensione alimentazione VMot (RRF 3.5+)

**Esempi:**
```gcode
M569 P0 S1 ; driver 0 va avanti
M569 P1 S0 D2 ; driver 1 indietro, stealthChop
M569 P0.0 S1 V24 ; driver CAN addr 0.0, 24V
```

### M584: Mapping drive

Mappa gli assi ai driver motore.

**Parametri:**
- `Xnnn` - Driver per asse X
- `Ynnn, Znnn, Unnn, Vnnn, Wnnn...` - Altri assi
- `Ennn:nnn` - Drive estrusori (può essere lista)
- `Pn` - Numero assi visibili (RRF 3.x)

**Esempi:**
```gcode
; Mapping standard
M584 X0 Y1 Z2 E3

; CoreXY con doppio Z
M584 X0 Y1 Z2:4 E3

; Con driver CAN
M584 X0.0 Y0.1 Z0.2 E1.0 ; board 0 e 1 (CAN ID 121)
```

**Note:**
- Deve essere uno dei primi comandi in config.g
- Gli assi di default sono XYZ, altri devono essere creati con M584

### M593: Input Shaping

Configura l'input shaping per ridurre le vibrazioni (ringing).

**Parametri:**
- `Fn` - Frequenza risonanza (Hz)
- `Snnn` - Damping ratio
- `Pn` - Tipo shaper (es: EI, MZV, ZVD, ZVDD, DAP)

**Esempio:**
```gcode
M593 P"zvd" F40 ; ZVD shaper a 40Hz
```

### M906: Imposta correnti motore

Imposta le correnti dei driver motore.

**Parametri:**
- `Xnnn, Ynnn, Znnn, Ennn` - Corrente in mA
- `Inn` - Percentuale corrente idle (quando fermi)
- `Tnnn` - Timeout idle in secondi (RRF 3.6+)

**Esempi:**
```gcode
M906 X800 Y800 Z800 E900 I30 ; correnti + 30% idle
M906 X1000 Y1000 I50 T5 ; 1000mA, 50% idle dopo 5s
```

**Note:**
- Deve essere dopo M584 (mapping) in config.g
- La corrente idle riduce il riscaldamento quando i motori sono fermi

### M950: Crea heater/fan/GPIO/spindle

Crea e configura heater, ventole, pin GPIO o spindle.

**Sintassi varia per tipo:**

**Heater:**
```gcode
M950 H1 C"out1" T1 ; heater 1, pin out1, sensore temp 1
```

**Fan:**
```gcode
M950 F0 C"fan0" Q500 ; fan 0, pin fan0, 500Hz PWM
M950 F1 C"!fan1" ; fan 1, output invertito
```

**GPIO/Servo:**
```gcode
M950 P0 C"exp.heater3" Q50 ; GPIO 0, 50Hz (servo)
M950 S0 C"io0.out" ; servo 0
```

**Spindle (RRF 3.3+):**
```gcode
M950 R0 C"out4" Q25000 ; spindle 0, 25kHz PWM
```

**Note critiche:**
- I sensori temperatura (M308) devono essere creati PRIMA degli heater
- Gli heater devono essere creati PRIMA di essere usati in M140, M141, M563
- Le ventole devono essere create PRIMA di M106
- GPIO deve essere creato PRIMA di M42

### M997: Reset firmware / Aggiornamento

Resetta il firmware o avvia l'aggiornamento.

**Parametri:**
- `Sn` - Modulo da aggiornare (S0=main, S1=WiFi)
- `Bn` - Board number (solo Duet 3)

**Esempi:**
```gcode
M997 ; reset firmware
M997 S1 ; aggiorna WiFi module
```

### M998: Richiedi re-invio linea

Richiede il re-invio di una linea specifica (gestione errori comunicazione).

### M999: Reset dopo stop di emergenza

Reset dopo un M112 (emergency stop) per riprendere le operazioni.

**Esempio:**
```gcode
M999 ; reset dopo emergenza
```

---

## Comandi T - Selezione Tool

### Tn: Seleziona tool

Seleziona lo strumento (tool) specificato.

**Sintassi:**
- `T0` - Seleziona tool 0
- `T1` - Seleziona tool 1
- `T-1` - Deseleziona tutti i tool

**Esempi:**
```gcode
T0 ; seleziona tool 0
T1 ; seleziona tool 1
T-1 ; nessun tool attivo
```

**Note:**
- Il cambio tool esegue automaticamente le macro tfreeN.g, tpreN.g, tpostN.g
- Gli offset del tool vengono applicati automaticamente
- Le temperature attive/standby vengono gestite automaticamente

---

## Note finali

Questo documento copre i principali comandi G e M supportati da RepRapFirmware per schede Duet3D. 

### Ordine comandi in config.g

L'ordine corretto dei comandi in config.g è critico:

1. **M550** - Nome macchina
2. **M552, M553, M554** - Configurazione rete
3. **M569** - Configurazione direzione driver
4. **M584** - Mapping assi/drive
5. **M350** - Microstepping  
6. **M92** - Passi per mm
7. **M566** - Jerk
8. **M203** - Velocità massime
9. **M201** - Accelerazioni
10. **M204** - Accelerazioni stampa/travel (opzionale)
11. **M906** - Correnti motori
12. **M84** - Timeout idle
13. **M208** - Limiti assi (prima S1 minimi, poi S0 massimi)
14. **M574** - Configurazione endstop
15. **M308** - Sensori temperatura
16. **M950** - Creazione heater/fan/GPIO
17. **M307** - Parametri processo heater
18. **M143** - Temperature massime heater
19. **M558** - Configurazione probe Z
20. **G31** - Offset probe
21. **M557** - Griglia probe
22. **M563** - Definizione tool
23. **G10** - Offset tool / temperature
24. **M501** - Carica parametri salvati (alla fine)

### File macro di sistema

Posizione: `/sys/` sulla SD card

**File homing:**
- `homeall.g` - Home tutti gli assi (o `homedelta.g` per Delta)
- `homex.g`, `homey.g`, `homez.g` - Home assi individuali

**File probe:**
- `deployprobe.g` - Estende probe retrattile
- `retractprobe.g` - Ritrae probe retrattile

**File gestione stampa:**
- `start.g` - Eseguito all'inizio stampa (M24)
- `pause.g` - Eseguito quando si mette in pausa (M25)
- `resume.g` - Eseguito quando si riprende (M24 dopo pausa)
- `stop.g` - Eseguito a fine stampa normale (M0)
- `cancel.g` - Eseguito quando si cancella la stampa
- `sleep.g` - Eseguito con M1

**File tool change:**
- `tfreeN.g` - Eseguito quando tool N viene deselezionato
- `tpreN.g` - Eseguito prima di selezionare tool N
- `tpostN.g` - Eseguito dopo aver selezionato tool N

**Altri file:**
- `config.g` - Configurazione principale (eseguito all'avvio)
- `config-override.g` - Parametri salvati con M500
- `bed.g` - Calibrazione bed (chiamato da G32)
- `mesh.g` - Mesh bed probing personalizzato (chiamato da G29)
- `daemon.g` - Eseguito periodicamente in background

### Risorse online

- **Documentazione ufficiale**: https://docs.duet3d.com
- **GCode Dictionary**: https://docs.duet3d.com/User_manual/Reference/Gcodes
- **GCode per funzione**: https://docs.duet3d.com/User_manual/Reference/Gcodes_by_function
- **Meta Commands**: https://docs.duet3d.com/User_manual/Reference/Gcode_meta_commands
- **Forum**: https://forum.duet3d.com
- **Wiki RepRap**: https://reprap.org/wiki/G-code

### Differenze principali con altri firmware

**vs Marlin:**
- M82/M83 per estrusione assoluta/relativa (non G90/G91)
- G10/G11 per retrazione firmware (non M207/M208)
- M563 per definire tool (non implicit tool 0)
- M950 per creare heater/fan/GPIO prima dell'uso
- Meta comandi (if, while, var, echo, ecc.)
- Object Model per accesso dati sistema

**vs Klipper:**
- Configurazione tramite GCode invece di file config
- Nessun server esterno richiesto (standalone mode)
- Supporto nativo CAN bus
- Input shaping integrato (M593)

### Convenzioni

- I parametri tra parentesi quadre `[parametro]` sono opzionali
- `nnn` rappresenta un numero (intero o decimale)
- Le stringhe possono essere racchiuse tra virgolette doppie `"stringa"`
- I commenti iniziano con `;` o sono racchiusi tra `()` in modalità CNC
- Case-insensitive (RRF 1.19+) tranne nelle stringhe

### Espressioni e Meta Commands (RRF 3.01+)

RepRapFirmware supporta espressioni matematiche e comandi condizionali:

```gcode
; Variabili
var temp = 200
var speed = {sensors.analog[0].lastReading * 100}

; Condizionali
if heat.heaters[0].current < 50
    M140 S60

; Loop
while iterations < 10
    G1 X{iterations * 10} F3000

; Echo
echo "Temperatura: ", heat.heaters[0].current
```

### Abbreviazioni comuni

- **RRF** - RepRapFirmware
- **FFF** - Fused Filament Fabrication
- **FDM** - Fused Deposition Modeling
- **CNC** - Computer Numerical Control
- **PWM** - Pulse Width Modulation
- **PID** - Proportional-Integral-Derivative
- **GPIO** - General Purpose Input/Output
- **IDEX** - Independent Dual Extruder
- **TMC** - Trinamic (driver motori)
- **CAN** - Controller Area Network

### Tips e Best Practices

1. **Sempre** testare i movimenti manualmente prima di eseguire homing automatico
2. **Usare** estrusione relativa (M83) per facilità e compatibilità multi-tool
3. **Verificare** la direzione motori (M569) prima di configurare endstop
4. **Impostare** limiti sicuri (M208) prima di muovere gli assi
5. **Calibrare** PID (M303) dopo ogni cambio hardware heater
6. **Salvare** spesso la configurazione (M500) dopo modifiche importanti
7. **Leggere** sempre la documentazione ufficiale per comandi nuovi o complessi
8. **Testare** le macro in modalità simulazione (M37) quando possibile

---

**Versione documento**: 1.0  
**Data**: 2025  
**Basato su**: RepRapFirmware 3.4-3.6  
**Hardware**: Duet 2 e Duet 3 series

Per informazioni più dettagliate su ciascun comando, consultare sempre la documentazione ufficiale aggiornata.
