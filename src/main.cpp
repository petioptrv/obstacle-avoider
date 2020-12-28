//
// Created by Petio Petrov on 2020-12-27.
//

#include <SPI.h>
#include "ultrasonic_sensor.h"

int main(void) {
  init();
  initVariant();

  Serial.begin(9600);
  UltrasonicSensor::us_init();

  while (1) {
    Serial.println(UltrasonicSensor::get_dist());
    delay(60);
  }
}
