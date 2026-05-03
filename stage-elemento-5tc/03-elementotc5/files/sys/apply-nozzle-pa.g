; Applica pressure advance (M572) per ogni tool presente in base a global.tNPressAdv
; Chiamato da config.g dopo tools-configure.g e da set-nozzle.g dopo ogni cambio ugello
if global.tool0Present
    M572 D0 S{global.t0PressAdv}
if global.tool1Present
    M572 D1 S{global.t1PressAdv}
if global.tool2Present
    M572 D2 S{global.t2PressAdv}
if global.tool3Present
    M572 D3 S{global.t3PressAdv}
if global.tool4Present
    M572 D4 S{global.t4PressAdv}
