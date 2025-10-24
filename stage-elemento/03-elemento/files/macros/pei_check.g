if sensors.gpIn[11].value == 1
    M291 P"Posizionare il piano di stampa per continuare." R"ATTENZIONE: PIANO ASSENTE!" S3
    var timeout_bed = 300
    var counter_bed = 0
    while sensors.gpIn[11].value == 1 && var.counter_bed < var.timeout_bed
        G4 S1
        set var.counter_bed = {var.counter_bed + 1}
        if mod(var.counter_bed, 10) == 0
            M291 P{"Attendere posizionamento piano... (" ^ var.counter_bed ^ "s)"} S0 T1
    if sensors.gpIn[11].value == 1
        M291 P"ERRORE: Piano non rilevato! Stampa annullata." R"Timeout Piano" S1
        M292
        M99
else
    M291 P"Piano presente ✓" S0 T1