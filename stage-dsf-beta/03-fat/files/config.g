; Default config.g template for DuetPi
; Replace this with a proper configuration file (e.g from https://configtool.reprapfirmware.org)

; Display initial welcome message
M291 P"You are operating an SBC image in standalone mode. Please see <a href=""https://www.duet3d.com/StartHere"" target=""_blank"">here</a> further information." R"Welcome to your new Duet 3!" S1 T0

; Enable PanelDue
M575 P1 B57600 S1

; Enable network
M552 P0.0.0.0 S1
