; Rilevamento dinamico board CAN per tool T0-T4
; Scorre l'array boards[] dell'object model e imposta global.toolNPresent
; per ogni board trovata agli indirizzi attesi (121-125).
; Chiamato da config.g dopo G4 S2.

global tool0Present = false
global tool1Present = false
global tool2Present = false
global tool3Present = false
global tool4Present = false
global toolCount    = 0

var b = 0
while var.b < #boards
    var addr = boards[var.b].canAddress
    if var.addr = 121
        set global.tool0Present = true
        set global.toolCount = global.toolCount + 1
    elif var.addr = 122
        set global.tool1Present = true
        set global.toolCount = global.toolCount + 1
    elif var.addr = 123
        set global.tool2Present = true
        set global.toolCount = global.toolCount + 1
    elif var.addr = 124
        set global.tool3Present = true
        set global.toolCount = global.toolCount + 1
    elif var.addr = 125
        set global.tool4Present = true
        set global.toolCount = global.toolCount + 1
    set var.b = var.b + 1

echo "CAN tool detect: " ^ global.toolCount ^ "/5  T0=" ^ global.tool0Present ^ " T1=" ^ global.tool1Present ^ " T2=" ^ global.tool2Present ^ " T3=" ^ global.tool3Present ^ " T4=" ^ global.tool4Present
