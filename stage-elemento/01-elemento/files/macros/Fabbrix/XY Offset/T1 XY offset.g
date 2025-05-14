M564 H0
M291 P"Choose the right X offset for T1" R"T1 XY Offset" S3 X1 
G10 P1 X{move.axes[0].machinePosition}
M291 P"Choose the right Y offset for T1" R"T1 XY Offset" S3 Y1 
G10 P1 Y{move.axes[1].machinePosition}
M500 P10:31