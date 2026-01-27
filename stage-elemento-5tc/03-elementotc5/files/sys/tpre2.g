M118 P0 L2 S"T2 Pre"
if move.axes[0].homed == false || move.axes[1].homed == false || move.axes[3].homed == false 
    G28 Y
	G28 X
	G28 C
M564 H1 S0
G0 C0 F6000
G0 X{global.xPT2Position} Y{move.axes[1].min - global.yPT2Position + 11} F5000
G0 Y{move.axes[1].min - global.yPT2Position} F5000
M400
G0 C60 F6000
M400
G0 Y{move.axes[1].min - global.yPT2Position + 11} F1000
M564 H1 S1
