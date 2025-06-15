; === daemon.g ===
; Logging automatico durante la stampa, ogni 60s
; Esegui solo se è in corso una stampa
if job.duration != null
  set global.logFile = job.file.fileName ^ ".log"
  echo >>global.logFile heat.heaters[0].current^ "," ^heat.heaters[1].current
