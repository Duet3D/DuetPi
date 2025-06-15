; calibrate_trigger_height.g
; This macro helps in calibrating the trigger height of the Z-probe

G28 ; Home all axes

; Move the nozzle to a position above the bed where the probe can safely trigger
G1 X150 Y150 F6000

; Lower the nozzle to just above the bed
G1 Z5 F300

; Perform a probe to find the bed
G30 S-1

; The result of the G30 command will give you the Z-height at which the probe triggered.
; You can use this information to adjust your trigger height in the configuration.

; Example command to set the trigger height (adjust the value as needed)
; M558 P9 H5 C"zprobe.in" F120 T6000 ; Adjust the H parameter to set the trigger height

M291 P"Calibration Complete" R"Trigger Height Calibration" S3 ; Display a message
