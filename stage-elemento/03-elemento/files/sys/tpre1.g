M118 P0 L2 S"T1 Pre"
if (move.axes[0].homed = false || move.axes[1].homed = false)
    G28 Y
	G28 X
M564 H1 S0
G0 C0 F10000
G0 X{global.xPT1Position} Y{move.axes[1].min - global.yPT0Position + 11} F8000
G0 Y{move.axes[1].min - global.yPT1Position} F8000
M400
G0 C60 F10000
M400
G0 Y{move.axes[1].min - global.yPT1Position + 11}
M564 H1 S1
