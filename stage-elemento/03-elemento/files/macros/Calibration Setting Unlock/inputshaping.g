;Medium setting 
M566 X600 Y600 P1                         ; set maximum instantaneous speed changes (mm/min)
M203 X18000 Y18000                          ; set maximum speeds (mm/min)
M201 X10000 Y10000                          ; set accelerations (mm/s^2)
M906 E1000:1000

M593 P"MZV" F27.4

; Extruders
M92 E210:210
M566 E120:120                            ; set maximum instantaneous speed changes (mm/min)
M203 E10000:10000                          ; set maximum speeds (mm/min)
M201 E5000:5000                            ; set accelerations (mm/s^2)

M117 "Input Settings"
M118 P0 S"InputShaping Settings"


m591 d0 s0
m591 d1 s0