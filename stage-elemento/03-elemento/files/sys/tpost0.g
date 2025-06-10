M118 P0 L2 S"T0 Post"
M116 P0
if state.status == "processing" && job.duration != null
	if heat.heaters[1].active > 160
    M83
    G1 E5 F200
	M564 H1 S0
	G0 X{global.xPT0Position}  Y{-global.yPT0Position+11} F8000
	G0 Y{move.axes[1].min - 40 } F6000 
	G0 Y{move.axes[1].min - 70 } F6000 
	G0 Y{move.axes[1].min - 40 } F6000
	G0 Y{move.axes[1].min - 70 } F6000
	G0 Y{move.axes[1].min - 40 } F6000
	G0 Y{move.axes[1].min - 70 } F6000 
	G0 Y{move.axes[1].min - 40 } F6000 
	G0 Y{move.axes[1].min - 70 } F6000 
	G0 Y{move.axes[1].min - 40 } F6000 
	G0 Y{move.axes[1].min - 70 } F6000 
	G0 Y{move.axes[1].min - 40 } F6000 
	M400
M703