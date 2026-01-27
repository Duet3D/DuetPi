M118 P0 L2 S"T2 Post"
M116 P1
if state.status == "processing" && job.duration != null
	M591 D1 S0
	if heat.heaters[2].active > 160
    M83
    ;G1 E5 F200
	M564 H1 S0
	G0 X{global.xPT2Position}  Y{-global.yPT2Position+11} F5000
	G0 Y{move.axes[1].min - 40 } F6000 
	G0 Y{move.axes[1].min - 70 } F6000 
	G0 Y{move.axes[1].min - 40 } F6000
	G0 Y{move.axes[1].min - 70 } F6000
	M400
	M564 H1 S1
;M703
M564 H0 S0
G0 Y{move.axes[1].min} F5000
M400
M564 H1 S1
