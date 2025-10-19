if (move.axes[0].homed = false || move.axes[1].homed = false)
    M98 P"homey.g"
	M98 P"homex.g"
G1 X40.3 Y55 F2000
G1 X37.1 Y0 F2000
G1 X43 F3000