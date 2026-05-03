M118 P0 L2 S"T4 Post"
M116 P4
if state.status == "processing" && job.duration != null
	M591 D4 S0
	if heat.heaters[5].active > 160
    M83
    ;G1 E5 F200
	M564 H1 S0
	G0 X{global.xPT4Position}  Y{-global.yPT4Position+11} F5000
	G0 Y{move.axes[1].min - 40 } F6000
	G0 Y{move.axes[1].min - 70 } F6000
	G0 Y{move.axes[1].min - 40 } F6000
	G0 Y{move.axes[1].min - 70 } F6000
	M400
	M564 H1 S1
if move.axes[0].homed = true && move.axes[1].homed = true
	M564 H0 S0
	G0 Y{move.axes[1].min} F5000
	M400
	M564 H1 S1
