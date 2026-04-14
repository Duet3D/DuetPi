M118 P0 L2 S"T4 Free"

if (move.axes[0].homed = false || move.axes[1].homed = false)
    G28 Y
	G28 X
    G92 C60
G0 X{global.xPT4Position + tools[4].offsets[0]}  Y{move.axes[1].min} F5000  
M400
M564 H0 S0
G0 X{global.xPT4Position + tools[4].offsets[0]}  Y{move.axes[1].min - global.yPT4Position + 11} F5000
M400
G0 Y{move.axes[1].min - global.yPT4Position} F5000
M400
G0 C0 F5000
M400
G0 Y{-global.yPT4Position + 11} F1000
G0 Y{move.axes[1].min} F5000
M400
M564 H1 S1
