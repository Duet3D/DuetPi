while heat.heaters[3].current > 60
	M291 R"Attendi il raffreddamento" P"Per Motivi di sicurezza attendere il raffreddamento della stazione, Un popup ti avviserà quando potrai rimuovere il connettore"
M291 R"Stazione Raffreddata" P"Ora puoi staccare il connettore" S2
M563 P1 H-3 
M117 "Stazione di Pulizia rimossa"