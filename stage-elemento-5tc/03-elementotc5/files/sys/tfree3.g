M118 P0 L2 S"T3 Free"

if (move.axes[0].homed = false || move.axes[1].homed = false)
    G28 Y
	G28 X
    G92 C60
G0 X{global.xPT3Position}  Y{move.axes[1].min} F5000  
M400
M564 H0 S0
G0 X{global.xPT3Position}  Y{move.axes[1].min - global.yPT3Position + 11} F5000
M400
G0 Y{move.axes[1].min - global.yPT3Position} F5000
M400
G0 C0 F5000
M400
G0 Y{-global.yPT3Position + 11} F1000
G0 Y{move.axes[1].min} F5000
M400
M564 H1 S1
