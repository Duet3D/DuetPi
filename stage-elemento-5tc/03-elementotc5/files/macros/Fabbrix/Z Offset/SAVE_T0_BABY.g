;save_babystep.g
; Add babystep to Z offset and make "persistant"
; from https://forum.duet3d.com/topic/16328/baby-stepping-can-it-or-can-it-not-be-permanent/10
if move.axes[2].babystep !=0
        M564 H0
        G10 P0 Z{tools[0].offsets[2] - move.axes[2].babystep}
        M500 P10 ; save settings to config-overide.g - Must have M501 in config.g
        M290 R0 S0
        M564 H1
        M501
else
        echo "No babystep offset.  Nothing to save"