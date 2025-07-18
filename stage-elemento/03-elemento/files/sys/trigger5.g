if sensors.gpIn[9].value = 1 && sensors.gpIn[10].value = 0
    M118 P0 S"INTERBLOCCO DISATTIVATO, PORTA CHIUSA"
	M117 "INTERBLOCCO DISATTIVATO, PORTA CHIUSA"
if sensors.gpIn[9].value = 0 && sensors.gpIn[10].value = 0
    M118 P0 S"PORTA SBLOCCATA, APERTA"
	M117 "PORTA SBLOCCATA, APERTA"
    