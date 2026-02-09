M564 H0 S0
G0 X{global.x_cleaning_pos_max} Y{global.y_cleaning_pos_max} Z5
G1 E25 F200
G1 E-1 F10
G0 X{global.x_cleaning_pos_min} F2000 
G0 X{global.x_cleaning_pos_max} F2000
G0 X{global.x_cleaning_pos_min} F2000
G0 X{global.x_cleaning_pos_max} F2000
G0 Z5
G0 X{global.x_cleaning_pos_min} F4000
G0 X{global.x_cleaning_pos_max} F4000
G0 X{global.x_cleaning_pos_min} F5000
G0 X{global.x_cleaning_pos_max} F5000
M564 S1 H1