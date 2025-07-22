; homez.g
; called to home the Z axis

T-1
M18 C
G1 X{move.axes[0].max/2} Y{move.axes[1].max/2} 
F4500
M400
G30