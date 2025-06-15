M291 R"Valuete your print" P"How was the quality and consistency of the print? Were there any visible defects or irregularities?" K{"1","2","3","4","5","SKIP"} S4
var quality = input
    if input = 5
       set var.quality = "-1"
    echo "User quality:"^var.quality
M291 R"Valuete your removal" P"Did you encounter any difficulties removing the object from the print bed?" K{"1","2","3","4","5","SKIP"} S4
var removal = input
    if input = 5
       set var.removal = "-1"
    echo "User removal:"^var.removal
M291 R"Valuete material profile" P"How would you rate the print profile used for this object in terms of accuracy and precision?" K{"1","2","3","4","5","SKIP"} S4
var profile = input
    if input = 5
       set var.profile = "-1"
    echo "User profile:"^var.profile
M291 R"Thanks!" P"This will help you to find the right way!" S1