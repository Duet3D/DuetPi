M118 P0 L2 S"T1 Post"
M116 P1
T1
if state.status == "processing" && job.duration != null
	M83 
	M564 H1 S0
	G0 X{global.xPT1Position}  Y{-global.yPT0Position+11} F8000
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