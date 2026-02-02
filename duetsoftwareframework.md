# Panoramica dell’API di DuetSoftwareFramework

Questo documento fornisce una panoramica dell’API di **DuetSoftwareFramework (DSF)** e spiega come interagire con una scheda Duet tramite applicazioni esterne.

---

## Cos’è l’API DSF

L’API di DuetSoftwareFramework permette a software esterni di comunicare con il sistema Duet utilizzando un meccanismo di **comunicazione tra processi (IPC)**.  
È utilizzata, ad esempio, da interfacce web, servizi di controllo e applicazioni personalizzate.

Sono disponibili client ufficiali per:
- **.NET (DuetAPIClient)**
- **Python**

È comunque possibile implementare un client personalizzato.

---

## Comunicazione IPC

La comunicazione avviene tramite un **socket UNIX**, solitamente situato in:

```
/var/run/dsf/dcs.sock
```

Quando un client si connette:
1. DSF invia un messaggio JSON di benvenuto con `id` e `version`
2. Il client deve rispondere con un messaggio di inizializzazione che indica la modalità di utilizzo

---

## Modalità di Connessione

### Command Mode

Permette di inviare comandi (G-code, M-code, T-code) a RepRapFirmware.

Messaggio di inizializzazione:

```json
{
  "mode": "Command"
}
```

Esempio di comando:

```json
{
  "command": "SimpleCode",
  "code": "G4 S3"
}
```

Risposta tipica:

```json
{
  "success": true,
  "result": ""
}
```

Durante l’esecuzione di un comando, la connessione rimane occupata.

---

### Intercept Mode

Consente di intercettare i comandi G/M/T prima o dopo che vengano elaborati.

Messaggio di inizializzazione:

```json
{
  "mode": "Intercept",
  "interceptionMode": "Pre"
}
```

Modalità disponibili:
- **Pre**: prima dell’elaborazione interna
- **Post**: dopo l’elaborazione, prima dell’invio al firmware
- **Executed**: dopo l’esecuzione

Il client può:
- Lasciare passare il comando
- Annullarlo
- Restituire un risultato personalizzato

---

### Subscribe Mode

Permette di ricevere aggiornamenti sullo stato della macchina (machine model).

Messaggio di inizializzazione:

```json
{
  "mode": "Subscribe",
  "subscriptionMode": "Patch"
}
```

Modalità di sottoscrizione:
- **Full**: invia l’intero modello macchina
- **Patch**: invia solo i campi modificati

Dopo ogni aggiornamento, il client deve inviare un messaggio di `Acknowledge` per ricevere il successivo.

---

## Endpoint HTTP Personalizzati

È possibile registrare endpoint HTTP o WebSocket personalizzati tramite DSF.

Esempio di creazione di un endpoint REST:

```json
{
  "command": "AddHttpEndpoint",
  "endpointType": "GET",
  "namespace": "third-party-app",
  "path": "test",
  "uploadRequest": false
}
```

DSF risponde fornendo il percorso del socket su cui l’applicazione dovrà mettersi in ascolto.

---

## Client Consigliati

- **DuetAPIClient (.NET)**  
  Client ufficiale con gestione completa del protocollo e degli errori.

- **Client Python**  
  Libreria Python per interagire con DSF.

---

## Note Utili

- L’API .NET è rilasciata sotto licenza **LGPL 3.0**
- Per il debug, è possibile avviare DuetControlServer con un livello di log elevato (`trace`) per visualizzare i messaggi JSON scambiati

---

Documento in formato Markdown, pronto per essere usato come README o documentazione tecnica.
