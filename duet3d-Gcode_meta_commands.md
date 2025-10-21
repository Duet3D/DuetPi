# GCode Meta Commands - Duet3D

Documentazione sui comandi meta GCode per RepRapFirmware 3.x

Fonte: https://docs.duet3d.com/en/User_manual/Reference/Gcode_meta_commands

---

## Introduzione

RepRapFirmware 3.01 ha introdotto il concetto di costrutti di programmazione di base (condizionali, loop e parametri) nel GCode. Questo, combinato con il ricco modello a oggetti in RRF3, fornisce un nuovo e potente livello di personalizzazione del controllo.

RepRapFirmware 3.01 e versioni successive forniscono costrutti di programmazione GCode per consentire l'esecuzione condizionale e l'iterazione, e permettono che i valori dei parametri nei comandi GCode siano espressioni invece di letterali.

---

## Comandi

### abort

```gcode
abort <opt-expression>
```

Causa la terminazione di tutte le macro annidate e del file di stampa corrente (se presente). L'espressione (se presente) viene convertita in una stringa, che viene inclusa nel messaggio presentato all'utente e scritto nel file di log.

### echo

```gcode
echo <expression>, <expression>, ...
```

Almeno un'espressione deve essere fornita. Le espressioni vengono convertite in stringhe e scritte sulla console, con un carattere di spazio tra ogni coppia.

**Esempio:**
```gcode
echo move.axes[0].homed, move.axes[1].homed, move.axes[2].homed
```

**Reindirizzamento su file (firmware 3.4+):**

Creare un nuovo file (eliminando qualsiasi file esistente con lo stesso nome):
```gcode
echo ><filename> <expression>, <expression>, ...
```

Aggiungere una riga a un file esistente:
```gcode
echo >><filename> <expression>, <expression>, ...
```

Aggiungere senza carattere di nuova riga (firmware 3.5beta2+):
```gcode
echo >>><filename> <expression>, <expression>, ...
```

**Note:**
- Non ci devono essere spazi tra i simboli >, >> o >>> e `<filename>`
- La cartella predefinita per il file è `/sys`
- `<filename>` può essere una stringa tra virgolette o un'espressione racchiusa in `{ }`

**Esempio di scrittura su file:**
```gcode
echo >"mymacro.g" "G1 F3000 X{move.axes[0].max-10}"
echo >>"mymacro.g" "G1 F3000 Y{move.axes[1].max-10}"
```

**Esempio di scrittura di una singola riga lunga:**
```gcode
echo >>>"data.csv" move.axes[0].machinePosition^","^move.axes[1].machinePosition^","^move.axes[2].machinePosition
echo >>>"data.csv" ","^heat.heaters[0].current^","^heat.heaters[2].current^","^heat.heaters[3].current
echo >>"data.csv" ","^sensors.filamentMonitors[0].position^","^sensors.filamentMonitors[1].position^","^sensors.filamentMonitors[2].position
```

**Nota:** `echo` ritorna solo all'input da cui è stato inviato, o a un file. Per ottenere informazioni su un input diverso, usa [M118].

---

## Costrutti di Programmazione

### if/elif/else

La forma generale del blocco condizionale è:

```gcode
if <boolean-expression>
    ...
elif <boolean-expression>
    ...
else
    ...
```

- La parte "elif" può essere omessa o ripetuta
- La parte "else" può essere omessa
- I corpi di if, elif ed else possono contenere comandi GCode ordinari e/o elementi di programma
- Ogni riga nel corpo deve essere indentata rispetto alla parola chiave corrispondente per indicare l'estensione del corpo
- Il corpo termina appena prima della prima riga che non è indentata

### while

```gcode
while <boolean-expression>
    ...
```

- Il corpo deve essere indentato rispetto alla parola chiave `while`
- Il corpo termina appena prima della prima riga che non è indentata
- All'interno del corpo, la costante `iterations` rappresenta il numero di iterazioni del loop già completate (zero durante la prima iterazione, 1 durante la seconda, ecc.)

**Loop con break:**
```gcode
while <boolean-expression>
    ...
    if <boolean-expression>
        break
    ...
```

L'istruzione `break` trasferisce il controllo alla riga successiva alla fine del corpo del loop.

**Loop con continue:**
```gcode
while <boolean-expression>
    ...
    if <boolean-expression>
        continue
    ...
```

L'istruzione `continue` incrementa il contatore di iterazione e trasferisce il controllo all'inizio del loop.

**⚠️ ATTENZIONE:** Se un loop itera all'infinito, non sarai in grado di interromperlo eccetto resettando la macchina. Quando scrivi un loop, assicurati sempre che:
- Il numero massimo di iterazioni sia limitato e non troppo grande, O
- Ci sia un'interazione manuale nel loop (es. comando M291) che fornisce un modo per uscire dal loop

**Nota sui loop annidati:**

I loop annidati hanno un contatore `iterations` per ogni livello di annidamento. Solo il contatore del loop in esecuzione è accessibile all'interno di quel loop. Per accedere al contatore di un loop esterno all'interno di un loop interno, usa una variabile:

```gcode
var loopCounterOuter = 0
while <boolean-expression>
    ; outer loop
    ...
    set var.loopCounterOuter = iterations
    while <boolean-expression>
        ; inner loop
        ...
        echo iterations ; iterations per il loop interno
        echo var.loopCounterOuter ; iterations per il loop esterno
```

---

## Variabili

### Variabili Locali

**Supportato da RRF 3.3**

```gcode
var <new-variable-name> = <expression>
```

Crea una nuova variabile chiamata `var.<new-variable-name>` e la inizializza a `<expression>`. Il nome non deve essere già in uso. Lo scope di un nome locale è il resto del blocco in cui è dichiarato.

**Riassegnazione:**
```gcode
set var.<existing-local-variable-name> = <expression>
```

### Variabili Globali

```gcode
global <new-variable-name> = <expression>
```

Crea una nuova variabile chiamata `global.<new-variable-name>` e la inizializza a `<expression>`. Il nome non deve essere già in uso.

**Esempio:**
```gcode
global T1heat=0
```

**Riassegnazione:**
```gcode
set global.<existing-global-variable-name> = <expression>
```

**Esempio:**
```gcode
set global.T1heat=heat.heaters[1].active
```

### Convenzioni per i Nomi delle Variabili

Le variabili devono conformarsi alla convenzione di denominazione specificata nella documentazione.

---

## Espressioni

### Sostituzione di Espressioni

La forma:
```gcode
{ <expression> }
```

può essere usata al posto di qualsiasi operando numerico o stringa tra virgolette all'interno di un comando GCode.

**Esempio:**
```gcode
G1 X{move.axes[0].max-10} Y{move.axes[1].min+10}
```

**Note:**
- Non è supportato l'uso di un'espressione per sostituire una lettera di parametro o il numero di comando dopo G o M iniziale
- Per parametri che richiedono valori multipli (RRF 3.5+), l'intero parametro deve essere un'espressione array:
  ```gcode
  M201 E{var.e0Accel, var.e1Accel}
  ```

### Formattazione

Tab e spazi possono essere usati liberamente tra nomi di variabili, parole chiave, letterali e altri elementi lessicali per migliorare la leggibilità.

Le sottoespressioni possono essere racchiuse in `{ }` o in `( )`. Tuttavia, il GCode CNC standard usa `( )` per racchiudere commenti. Quindi in modalità CNC, RepRapFirmware tratta `( )` come sottoespressioni quando appaiono all'interno di `{ }` e come commenti quando non lo fanno.

---

## Tipi di Dati

I tipi disponibili di espressioni e variabili sono:
- `bool`
- `int`
- `float`
- `string`
- `DateTime`
- `object`
- `array`

**Operazioni sui tipi:**
- Tipo `object`: solo confronto con null e accesso ai membri
- Tipo `array`: solo lunghezza (operatore unario prefisso `#`) e indicizzazione (operatore `[ ]`)

**Tipi interni aggiuntivi:**
- `driverId`
- `ipAddress`
- `macAddress`

### Conversioni Implicite di Tipo

Le seguenti conversioni implicite di tipo saranno eseguite quando necessario (vedi documentazione completa per i dettagli).

**Suggerimento:** Per forzare la conversione di un'espressione di qualsiasi tipo in stringa, concatenala con la stringa vuota usando l'operatore `^`.

---

## Costanti Predefinite

| Nome | Tipo | Significato |
|------|------|-------------|
| `false` | bool | Booleano falso |
| `input` | (variabile) | L'input più recente da una message box con modalità 4, 5, 6 o 7 (vedi comando M291) |
| `iterations` | int | Il numero di iterazioni completate del loop più interno |
| `line` | int | Il numero di riga corrente nel file in esecuzione |
| `null` | object | L'oggetto null |
| `pi` | float | Pi greco (3.14159265...) |
| `result` | int | 0 se l'ultimo comando G-, M- o T- su questo canale di input ha avuto successo, 1 se ha restituito un warning, 2 o superiore se ha restituito un errore, o -1 se era un comando di message box bloccante M291 con pulsante Cancel che è stato premuto o è scaduto. I meta comandi non cambiano 'result'. |
| `true` | bool | Booleano vero |

**Note su `result`:**
- In RRF 3.5.0-rc3 e precedenti, premere 'Cancel' o timeout di M291 cancellerà il job/macro corrente
- DSF 3.5 e 3.6 non aggiornano la costante `result` quando un G-code è interpretato da DSF o plugin di terze parti

---

## Letterali

### Interi

Gli interi possono essere espressi in formato:
- **Decimale:** `4321`
- **Esadecimale:** `0x3f`
- **Binario:** `0b1011`

### Float

I float possono essere espressi in:
- **Formato semplice:** `165.32`
- **Formato scientifico:** `6.2e6`

### Stringhe

Le stringhe sono circondate da doppi apici: `"Hello world"`

Per includere un doppio apice in una stringa, usa due doppi apici consecutivi:
```gcode
"Here is some ""quoted text"""
```

**Limite:** Le stringhe sono limitate a 100 caratteri.

### Caratteri

**Supportato da RRF 3.5.0+**

I caratteri sono circondati da apici singoli: `'a'`

### Altri Tipi

Non ci sono letterali di altri tipi, ma sono disponibili le costanti predefinite `true`, `false` e `null`.

---

## Object Model

Le espressioni possono usare i valori di qualsiasi proprietà nel RepRapFirmware Object Model (OM).

Vedi [Object Model di RepRapFirmware](https://github.com/Duet3D/RepRapFirmware/wiki/Object-Model-Documentation) per vedere cosa è disponibile.

### Variabili Globali e Locali

**Supportato da RRF 3.3 in modalità standalone e da 3.4 in modalità SBC**

**Variabili globali:**
```gcode
global defaultSpeed=6000
...
G1 X0 Y0 F{global.defaultSpeed}
```

**Variabili locali:**
```gcode
var mySpeed=5000
G1 X0 Y0 F{var.mySpeed}
```

**Verifica esistenza:**
```gcode
exists(global.defaultSpeed)
```

---

## Parametri Multipli

**Supportato da RRF 3.5**

I comandi Gcode che accettano parametri multipli separati da due punti (es. `M93 E350:400`) possono accettare espressioni.

**RRF 3.6+:**
L'intero parametro deve essere un'espressione array:
```gcode
M92 E{global.e0StepsPerMm, 400}
```

**RRF 3.5:**
Ogni valore individuale può essere un'espressione:
```gcode
M92 E{global.e0StepsPerMm}:400
```

---

## Parametri delle Macro

**Supportato da RRF 3.3**

È possibile aggiungere parametri quando si chiama una macro usando M98 o usando una macro come gcode personalizzato.

**Esempio di chiamata:**
```gcode
M98 P"macro.g" S100 Y"string"
```

**All'interno della macro:**
```gcode
;macro.g
G1 X{param.S}
echo {param.Y}
```

**Gestione parametri opzionali:**
```gcode
;macro.g
if exists(param.S)
    G1 X{param.S}
else
    echo "no move passed to macro.g"
```

**Restrizioni:**
- Non puoi usare P o R come parametri (P è usato per il file gcode, R per macro riavviabili)
- Nei custom 'G' gcode: non usare G, M, N, o T come parametri
- Nei custom 'M' gcode: non usare G, M, o N come parametri

---

## Array

**Supportato da RRF 3.5**

Una sequenza di espressioni racchiuse in `{ }` e separate da virgole è un'espressione array.

**Esempi:**
```gcode
{1,2,3}           ; array di tre elementi
{1,2,3,}          ; array di tre elementi (uguale al precedente)
{pi,}             ; array di un elemento
{pi}              ; NON è un array, è un valore semplice
{1,{2,3,4},5}     ; array di tre elementi, il secondo è a sua volta un array
```

**Operazioni sugli array:**
- Operatore `#` (prefisso): numero di elementi
- Operatore `[ ]`: estrazione di un singolo elemento

**Nota:** Una volta creati, gli array hanno lunghezza fissa. Una variabile array deve essere riassegnata a un nuovo array per cambiarne la lunghezza.

---

## Operatori

### Operatori Unari

| Operatore | Firma | Significato |
|-----------|-------|-------------|
| `!` | bool→bool | NOT booleano |
| `+` | int→int, float→float | Unario + |
| `+` | DateTime→int | Converte data e ora in numero di secondi dal datum (RRF 3.4+) |
| `-` | int→int, float→float | Unario - |
| `#` | X[]→int, string→int | Numero di elementi nell'array, o numero di caratteri nella stringa |

### Operatori Binari

**Precedenza degli operatori:** Quando un'espressione ha operatori binari multipli della stessa precedenza senza parentesi, gli operatori vengono valutati da sinistra a destra.

| Operatore | Prec. | Firma | Significato |
|-----------|-------|-------|-------------|
| `*` | 6 | (int,int)→int, (float,float)→float | Moltiplicazione |
| `/` | 6 | (float,float)→float | Divisione |
| `+` | 5 | (int,int)→int, (float,float)→float, (DateTime,int)→DateTime | Addizione |
| `-` | 5 | (int,int)→int, (float,float)→float, (DateTime,DateTime)→int, (DateTime,int)→DateTime | Sottrazione |
| `=` o `==` | 4 | (X,X)→bool | Uguaglianza |
| `!=` | 4 | (X,X)→bool | Disuguaglianza |
| `<` | 4 | (int,int)→bool, (float,float)→bool | Minore di |
| `<=` | 4 | (int,int)→bool, (float,float)→bool | Minore o uguale |
| `>` | 4 | (int,int)→bool, (float,float)→bool | Maggiore di |
| `>=` | 4 | (int,int)→bool, (float,float)→bool | Maggiore o uguale |
| `&` o `&&` | 3 | (bool,bool)→bool | AND booleano |
| `\|` o `\|\|` | 3 | (bool,bool)→bool | OR booleano |
| `^` | 2 | (string,string)→string | Concatenazione stringhe |

**⚠️ ATTENZIONE:** L'operatore di moltiplicazione `*` funziona quando è usato ovunque all'interno di un'espressione o sottoespressione racchiusa in `{ }`, ma non altrimenti. Questo perché il carattere `*` in una riga di GCode introduce normalmente un checksum di fine riga.

### Operatore Ternario

```gcode
expr1 ? expr2 : expr3
```

Valuta `expr2` se `expr1` è vero, altrimenti `expr3`. `expr1` deve essere booleano. L'operatore ternario ha precedenza 1.

---

## Funzioni

Le seguenti funzioni sono supportate con i loro significati convenzionali:

| Funzione | Firma | Note |
|----------|-------|------|
| `abs` | float→float o int→int | Valore assoluto |
| `acos` | float→float | Risultato in radianti |
| `asin` | float→float | Risultato in radianti |
| `atan` | float→float | Risultato in radianti |
| `atan2` | (float, float)→float | Risultato in radianti |
| `ceil` | float→int o float→float | Risultato è int se rientra in un intero a 32-bit, altrimenti float (RRF 3.5.0+) |
| `cos` | float→float | Argomento in radianti |
| `datetime` | int→DateTime o string→DateTime | Converte secondi dal datum a DateTime, o stringa formato "yyyy-mm-ddThh:mm:ss" a DateTime (RRF 3.4.0+) |
| `degrees` | float→float | Converte radianti in gradi |
| `drop` | (string, int)→string o (array, int)→array | Restituisce tutti tranne i primi N elementi (RRF 3.6.0+) |
| `exists` | name → bool | Restituisce true se il nome è valido e non è null (RRF 3.3.0+) |
| `exp` | float→float | Restituisce e elevato all'operando (RRF 3.5.0+) |
| `fileexists` | string→bool | Restituisce true se il file esiste (RRF 3.5.0+) |
| `fileread` | (string, int, int, char)→array | Legge elementi da file CSV (RRF 3.5.0+) |
| `find` | (string, char)→int o (string, string)→int | Indice della prima occorrenza, o -1 se non trovato (RRF 3.6.0+) |
| `floor` | float→int o float→float | Arrotondamento per difetto |
| `isnan` | float→bool | Restituisce true se l'operando è NaN |
| `log` | float→float | Logaritmo naturale (RRF 3.5.0+) |
| `max` | (float, ...)→float o (int, ...)→int | Massimo di 1 o più argomenti |
| `min` | (float, ...)→float o (int, ...)→int | Minimo di 1 o più argomenti |
| `mod` | (int, int)→int o (float, float)→float | Resto della divisione |
| `pow` | (float, float)→float o (int, int)→int | Potenza (RRF 3.5.0+) |
| `radians` | float→float | Converte gradi in radianti |
| `random` | int→int | Numero pseudo-casuale da 0 a operando-1 |
| `round` | float→int o float→float | Arrotondamento al più vicino intero (RRF 3.6.0+) |
| `sin` | float→float | Argomento in radianti |
| `sqrt` | float→float | Radice quadrata |
| `square` | float→float | Quadrato dell'operando (RRF 3.6.0+) |
| `take` | (string, int)→string o (array, int)→array | Restituisce i primi N elementi (RRF 3.6.0+) |
| `tan` | float→float | Argomento in radianti |
| `vector` | (int, X) → array | Array con n elementi, tutti copie del secondo operando (RRF 3.5.0+) |

**Nota sulla funzione `random`:**
La funzione random usa il generatore di numeri casuali hardware se il microcontrollore ne fornisce uno. Le schede Duet 3 6HC, 6XD e Mini 5+ usano tutte microcontrollori che forniscono un generatore di numeri casuali vero.

**Note sulla funzione `fileread`:**
Ogni elemento (inclusi quelli saltati) deve essere uno dei seguenti:
- Un numero intero o float
- Una stringa tra doppi apici
- La parola chiave `null`

Spazi e tab iniziali e finali attorno a ogni elemento sono ignorati. Se il file non può essere aperto e letto, o se qualsiasi elemento non è conforme, il comando contenente la chiamata fileread verrà interrotto.

---

## Note Importanti

### File di Macro in Windows

Se stai scrivendo macro in un sistema operativo Windows, imposta l'EOL su stile Linux (solo LF). Le macro scritte con il default Windows (CR LF) funzionano, ma in alcune versioni di RRF i messaggi di errore contano CR e LF come due righe, quindi tutti i numeri di riga vengono moltiplicati per 2.

### Cambiamento in RRF 3.6.0

Da RepRapFirmware 3.6.0, l'indentazione delle righe di commento nel meta GCode non è più significativa. Questo potrebbe causare il cambiamento del significato di una sequenza di comandi, se una riga di commento era indentata meno del comando precedente e la macro si basava su questo per significare la fine di un blocco.

---

## daemon.g

Il file macro `/sys/daemon.g` può essere usato per eseguire attività regolari. Il firmware cerca il file, se esiste lo esegue e una volta raggiunta la fine del file aspetta. Se il file non viene trovato, aspetta 10s e poi lo cerca di nuovo.

**Raccomandazione:** Usa un loop `while` all'interno del file daemon.g per evitare che il firmware debba aprirlo ogni 10 secondi. Ad esempio, per aggiornamenti più brevi:

```gcode
while true
    ; il tuo codice qui
    G4 S1  ; attendi 1 secondo
```

**⚠️ ATTENZIONE:** Fai attenzione a non avviare un loop che impiega molto tempo per completarsi senza avere un comando `G4 P500` o simile per restituire il controllo al processo principale ogni mezzo secondo circa.

**Nota per modalità SBC:** Solo in modalità SBC, DSF attende che i codici in sospeso vengano eseguiti prima che un meta codice venga valutato. `M576 S0` può aiutare a ridurre il ritardo tra i trasferimenti SPI. Questo sarà affrontato in RRF 3.7.

---

## Object Model Personalizzato

Da RRF 3.6.0, chiavi e valori personalizzati dell'Object Model definiti dall'utente possono essere incorporati nel file Gcode, che verranno creati nell'OM quando il file Gcode viene eseguito.

Vedi [documentazione Object Model](/User_manual/RepRapFirmware/Object_Model#job-information-and-custom-object-model-keys).

---

## Esempi

Alcuni esempi usando il meta Gcode sono elencati di seguito. Ci sono anche molti esempi e discussioni nella [sezione meta Gcode del forum](https://forum.duet3d.com/category/34/gcode-meta-commands).

### Esempio 1: Calibrazione Delta con Retry

File bed.g di esempio per calibrare una stampante delta usando GCode condizionale. All'inizio, fa l'homing della stampante solo se non è già stato fatto. Poi calibra la stampante sondando un numero di punti, ricominciando se il sondaggio fallisce. Se la calibrazione produce una deviazione standard superiore a un limite (impostato alla fine del loop, in questo caso >0.03mm), ripete il processo di calibrazione. Se la calibrazione fallisce 5 volte per qualsiasi motivo, si ferma.

```gcode
; Auto calibration routine for large delta printer
M561 ; clear any bed transform

; If the printer hasn't been homed, home it
if !move.axes[0].homed || !move.axes[1].homed || !move.axes[2].homed
    G28

; Probe the bed and do auto calibration
G1 X0 Y140 Z10 F10000 ; go to just above the first probe point

while true
    if iterations = 5
        abort "Too many auto calibration attempts"
    
    G30 P0 X0.00 Y140.00 Z-99999
    if result != 0
        continue
    
    G30 P1 X70.00 Y121.24 Z-99999
    if result != 0
        continue
    
    G30 P2 X121.24 Y70.00 Z-99999
    if result != 0
        continue
    
    G30 P3 X140.00 Y0.00 Z-99999
    if result != 0
        continue
    
    G30 P4 X121.24 Y-70.00 Z-99999
    if result != 0
        continue
    
    G30 P5 X70.00 Y-121.24 Z-99999
    if result != 0
        continue
    
    G30 P6 X0.00 Y-134.85 Z-99999
    if result != 0
        continue
    
    G30 P7 X-65.57 Y-113.57 Z-99999
    if result != 0
        continue
    
    G30 P8 X-112.29 Y-64.83 Z-99999
    if result != 0
        continue
    
    G30 P9 X-130.59 Y-0.00 Z-99999
    if result != 0
        continue
    
    G30 P10 X-115.90 Y66.91 Z-99999
    if result != 0
        continue
    
    G30 P11 X-69.45 Y120.29 Z-99999
    if result != 0
        continue
    
    G30 P12 X0.00 Y70.00 Z-99999
    if result != 0
        continue
    
    G30 P13 X60.62 Y-35.00 Z-99999
    if result != 0
        continue
    
    G30 P14 X-52.28 Y-30.19 Z-99999
    if result != 0
        continue
    
    G30 P15 X0 Y0 Z-99999 S8
    if result != 0
        continue
    
    if move.calibration.initial.deviation <= 0.03
        break
    
    echo "Repeating calibration because deviation is too high (" ^ move.calibration.initial.deviation ^ "mm)"

; end loop
echo "Auto calibration successful, deviation", move.calibration.final.deviation ^ "mm"
G1 X0 Y0 Z150 F10000 ; get the head out of the way
```

**NOTA:** Se usi questo metodo per iterare il livellamento di un bed/gantry montato su viti (es. Cartesiane, CoreXY ecc.), la massima deviazione corretta è ancora limitata dal parametro S di M671 (default 1mm).

### Esempio 2: Variabili Persistenti

RepRapFirmware ti permette di scrivere variabili su file usando il comando `echo`, che possono poi essere rilette all'avvio o in un momento successivo.

Questo è un set di macro che crea un file per ogni variabile globale persistente, salvata in una directory `/globals`. Possono poi essere salvate e ricaricate secondo necessità.

**persistentGlobal.g:**
```gcode
var id = param.V ; nome della variabile globale
var value = param.X ; valore da salvare
var filepath = "globals/"^{var.id} ; percorso del file interno

; Salva la variabile globale come file così è persistente
echo >{var.filepath} "if exists(global."^{var.id}^")"
echo >>{var.filepath} " set global."^{var.id}^" = "^{var.value}
echo >>{var.filepath} "else"
echo >>{var.filepath} " global "^{var.id}^" = "^{var.value}

M98 P{var.filepath} ; carica la variabile globale
```

**loadPersistentGlobal.g:**
```gcode
var id = param.V ; nome della variabile globale
var defaultValue = param.X ; valore da salvare se la variabile non esiste

; Crea il file se non esiste
if (!fileexists({"/sys/globals/"^var.id}))
    M98 P"scripts/persistentglobal.g" V{var.id} X{var.defaultValue}

; Carica la variabile globale persistente
M98 P{"globals/"^var.id}
```

**In config.g, carica le variabili persistenti:**
```gcode
; Load persistant global variables
M98 P"scripts/loadPersistentGlobal.g" V"lastTool" X-2
M98 P"scripts/loadPersistentGlobal.g" V"nozzleDiameters" X{null, null}
M98 P"scripts/loadPersistentGlobal.g" V"nozzleHF" X{false, false}
```

**Esempi di utilizzo:**
```gcode
; Salva il tool corrente
if {param.T} == {global.lastTool}
    pass
else
    M98 P"scripts/persistentglobal.g" V"lastTool" X{param.T}
    echo "set tool num:", {param.T}

; Aggiorna array di diametri ugelli
var tool = exists(param.T) ? param.T : max(state.currentTool, 0)
var newDiameters = global.nozzleDiameters
set var.newDiameters[var.tool] = param.D

var newHF = global.nozzleHF
var highFlow = exists(param.H) ? param.H > 0 : global.nozzleHF[var.tool]
set var.newHF[var.tool] = var.highFlow

echo "Setting T"^{var.tool}^" nozzle to "^{var.highFlow ? "HF " : ""}^{var.newDiameters[var.tool]}^"mm"

M98 P"scripts/persistentglobal.g" V"nozzleDiameters" X{var.newDiameters}
M98 P"scripts/persistentglobal.g" V"nozzleHF" X{var.newHF}
```

### Esempio 3: Creazione Dinamica di Profili Filamento

```gcode
var name = ""
if exists(param.F)
    set var.name = param.F
else
    M291 R"Creating New Filament" P"Enter Filament Name" S7 H50 J1
    set var.name = input

var temperature = 0
if exists(param.T)
    set var.temperature = param.T
else
    M291 R"Creating New Filament" P{"Enter load/unload temperature for "^var.name} S5 L0 H350 J1
    set var.temperature = input

var dir = "/filaments/"^var.name^"/"
var config = var.dir^"config.g"
var load = var.dir^"load.g"
var unload = var.dir^"unload.g"

if (fileexists(var.config))
    M291 R"Creating New Filament" P{"Filament "^var.name^" already exists, overwrite?"} S3

echo "Creating directory "^var.dir
M98 P"scripts/createDirectory.g" D{var.dir}

echo {"Creating filament "^var.name^" (un)loading at "^var.temperature^"C"}

echo >var.load "M98 P""scripts/load.g"" F"""^{var.name}^""" T"^{var.temperature}
echo >{var.unload} "M98 P""scripts/unload.g"" F"""^{var.name}^""" T"^{var.temperature}

echo >{var.config} "var tool = state.currentTool"
echo >>{var.config} "var nozzleDiameter = global.nozzleDiameters[var.tool]"
echo >>{var.config} "var extruderDrive = tools[var.tool].filamentExtruder"
echo >>{var.config} "set global.defaultFilamentTemperature = "^var.temperature
echo >>{var.config} ""
echo >>{var.config} "if (global.nozzleHF[var.tool])"
echo >>{var.config} "    if (var.nozzleDiameter <= 0.25)"
echo >>{var.config} "        M572 D{var.extruderDrive} S{global.defaultPA}"
; ... (continua con altre configurazioni)
```

---

## Risorse Aggiuntive

- [Object Model di RepRapFirmware](https://github.com/Duet3D/RepRapFirmware/wiki/Object-Model-Documentation)
- [Changelog RRF 3.x](https://github.com/Duet3D/RepRapFirmware/wiki/Changelog-RRF-3.x)
- [Forum Duet3D - Sezione Meta GCode](https://forum.duet3d.com/category/34/gcode-meta-commands)
- [Documentazione Macro](/User_manual/Tuning/Macros)
- [Object Model Personalizzato](/User_manual/RepRapFirmware/Object_Model#job-information-and-custom-object-model-keys)

---

*Documentazione aggiornata per RepRapFirmware 3.x*
