if state.status = "idle"
	M141 S{heat.heaters[3].current + 0.5}
elif state.status = "processing"
	var totalLEDs = 78;
	var greenLEDs = 0
	var orangeLEDs = 0
	var printProgress = 0 
	if exists(job.file.filament[1])
		set var.printProgress = (job.rawExtrusion * 100) / (job.file.filament[0] + job.file.filament[1]);
	else
		set var.printProgress = (job.rawExtrusion * 100) / (job.file.filament[0]);
		set var.greenLEDs = ceil(var.totalLEDs * var.printProgress / 100);
		set var.orangeLEDs = var.totalLEDs - var.greenLEDs;
			if (var.greenLEDs > 0) 
    			M150 E0 R0 U255 B0 P255 S{var.greenLEDs} F1  ; Sets LEDs to green based on print progress
			if (var.orangeLEDs > 0) 
    			M150 E0 R0 U255 B0 P20 S{var.orangeLEDs} F0  ; Sets remaining LEDs to orange