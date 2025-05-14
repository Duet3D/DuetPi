;Medium setting 
M566 X1000 Y1000 Z5 C10000                        ; set maximum instantaneous speed changes (mm/min)
M203 X4000 Y4000 Z3000 C2000                        ; set maximum speeds (mm/min)
M201 X1000 Y1000 Z5 C400                         ; set accelerations (mm/s^2)

; Extruders
M566 E1000:1000                            ; set maximum instantaneous speed changes (mm/min)
M203 E10000:10000                          ; set maximum speeds (mm/min)
M201 E500:500                            ; set accelerations (mm/s^2)