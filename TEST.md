# Analisi Errori Firmware ElementoTC

## 🔴 ERRORI CRITICI

### 1. Inconsistenze nei messaggi di unload filament
**File:** `1_CFF/unload.g` e `1_GFF/load.g`
- `1_CFF/unload.g` (linea 18): Mostra "Unloading PLA" invece di "Unloading CFF"
- `1_GFF/load.g` (linea 20): Mostra "Loading PLA" invece di "Loading GFF"

### 2. Errore di sintassi nel nome file
**File:** `macros/Fabbrix/TC/Set Parcking,g`
- Nome file errato: dovrebbe essere `Set Parking.g` (virgola invece di punto)

### 3. Comando errato in tpost0.g e tpost1.g
**Files:** `sys/tpost0.g` e `sys/tpost1.g`
- Linea con `M703` che non è un comando G-code valido standard
- Dovrebbe probabilmente essere `M701` (load filament) o rimosso

### 4. Inconsistenze nelle configurazioni probe
**File:** `sys/config.g` vs `sys/config.g.bak`
- config.g: `M558 A2 Z1 K0 B1 P8` (probe abilitato)
- config.g.bak: `M558 A2 Z1 K0 B0 P8` (probe disabilitato)
- Potenziale problema di configurazione

## 🟡 ERRORI MINORI E MIGLIORAMENTI

### 5. Filament monitor settings inconsistenti
**Files:** Vari `config.g` dei filamenti
- T0 filaments: L33 per PLA/CFF/GFF/TPU, L32 per PETG
- T1 filaments: L28.2 per tutti tranne PLA (L34)
- Dovrebbero essere coerenti per tipo di filamento

### 6. Temperature di caricamento non ottimali
**Files:** Filament load.g
- CFF e GFF: 260°C (molto alta, potrebbe degradare il filamento)
- PETG T1: 220°C (dovrebbe essere ~240°C)

### 7. Variabile non utilizzata in daemon.g
**File:** `sys/daemon.g`
- La variabile `orangeLEDs` viene calcolata ma mai utilizzata per settare i LED

### 8. Commenti fuorvianti
**File:** Vari `config.g` dei filamenti
- Tutti i file mostrano ";Pressure Adv PLA settings" anche per PETG, TPU, etc.

## 🔵 PROBLEMATICHE DI SICUREZZA

### 9. Door control logic
**Files:** `sys/trigger5.g`, `sys/trigger6.g`
- Logic per controllo porta potenzialmente confusa
- Trigger5 e Trigger6 hanno condizioni che potrebbero sovrapporsi

### 10. Safety checks mancanti
**File:** `macros/Fabbrix/TC/Set Parcking,g`
- Mancano controlli di sicurezza prima di movimenti critici
- Il codice disabilita i limiti software senza verifiche sufficienti

## 🟢 RACCOMANDAZIONI

### Correzioni immediate:
1. **Correggere i messaggi dei filamenti:** Assicurarsi che ogni unload.g mostri il nome corretto del filamento
2. **Rinominare il file:** `Set Parcking,g` → `Set Parking.g`
3. **Rimuovere/correggere M703:** Sostituire con comando valido o rimuovere
4. **Unificare configurazioni probe:** Decidere se il probe deve essere abilitato o meno

### Miglioramenti suggeriti:
1. **Standardizzare temperature:** Usare temperature appropriate per ogni tipo di filamento
2. **Correggere filament monitor:** Unificare i valori L per filamenti dello stesso tipo
3. **Completare daemon.g:** Implementare correttamente la logica LED
4. **Aggiornare commenti:** Correggere i commenti per riflettere le impostazioni reali

### Test raccomandati:
1. Testare il cambio utensile con entrambi gli estrusori
2. Verificare il corretto funzionamento del filament monitor
3. Testare la logica di controllo porta
4. Verificare le temperature di stampa per ogni materiale

## 📋 PRIORITÀ

**Alta priorità:** Errori 1, 2, 3, 4
**Media priorità:** Errori 5, 6, 9, 10  
**Bassa priorità:** Errori 7, 8