#!/usr/bin/python3
# -*- coding: utf-8 -*-

# /!\ Warning /!\ 
# This file may be overwritten by the plugin
# Do not modify, create your own instead

from RPi import GPIO
import time

#tipo di riferimento, numerazione della cpu
GPIO.setmode(GPIO.BCM)

#imposto linea 21, pin 40, come uscita
GPIO.setup(20, GPIO.OUT)

    #metto la linea 21 alta
GPIO.output(20, GPIO.LOW)
