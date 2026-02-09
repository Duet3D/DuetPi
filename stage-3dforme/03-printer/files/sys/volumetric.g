M350 E1 I1
; set step mm
M92 E200.00 ; set steps per mm
; set maximum instantaneous speed changes (mm/min)
M566 E10.00        
; set maximum speeds (mm/min)
M203 E400.00   
; set accelerations (mm/s^2)
M201 E10.00  
; set motor currents (mA) and motor idle factor in per cent    
M906 E1300 I30