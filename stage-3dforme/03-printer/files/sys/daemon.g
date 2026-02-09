if sensors.analog[13].lastReading > 60
    M291 P{"Humidity not in currect range, please try to stay in range 20-40%, current Humidity is: "^ sensors.analog[13].lastReading} R"Humidity Allert" S0 T5

if sensors.analog[11].lastReading > 35
    M291 P{"Temperature not in currect range, please try to stay in range 20-35 deg, current Temperature is: "^ sensors.analog[11].lastReading} R"Temperature Allert" S0 T5