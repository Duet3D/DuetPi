from RPi import GPIO
import time

#tipo di riferimento, numerazione della cpu
GPIO.setmode(GPIO.BCM)

#imposto linea 21, pin 40, come uscita
    #metto la linea 21 alta
GPIO.setup(20, GPIO.OUT, initial=1)
