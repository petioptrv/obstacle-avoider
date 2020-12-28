//
// Created by Petio Petrov on 2020-12-27.
//

#include <Arduino.h>
#include "ultrasonic_sensor.h"

#define echo_pin 14
#define trig_pin 15
#define trig_pulse_us 10
#define cm_factor 58  // high level time * velocity (340M/S) / 2

void UltrasonicSensor::us_init() {
  pinMode(echo_pin, INPUT);
  pinMode(trig_pin, OUTPUT);
}

double UltrasonicSensor::get_dist() {
  digitalWrite(trig_pin, HIGH);
  delayMicroseconds(trig_pulse_us);
  digitalWrite(trig_pin, LOW);
  unsigned long duration = pulseIn(echo_pin, HIGH);
  return double(duration)/cm_factor;
}
