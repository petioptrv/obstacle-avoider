# obstacle-avoider
This is a portfolio project intended to demonstrate knowledge of embedded systems throughout the design and development process.

The code has been mostly developed from scratch with minimal use of Arduino libraries.

# 1. Requirements Specifications
Template: IEEE STD 830-1998

## Overview

### Objectives
The goal of this project is to design an obstacle-avoidant, battery-powered, low-cost vehicle.

### Processes
The hardware infrastructure of the project will be dicatate by availability, cost and commonality of the parts. 

The software infrastructure will be built using a top-down approach, by firstly designing the infrastructure of the system, and incrementally progressing to lower-level details, ending with the optimization phase.

### Roles and Responsibilities
I, Petio Petrov, will be responsible for both the hardware and software aspects of the project.

### Interactions with Existing Systems
N/A

### Terminology
**Pinned-mode:** the vehicle cannot make any more progress.

### Security
This is a common embedded systems project for begginers; intellectual property management not required.

## Function Description

### Functionality
The vehicle will drive forward until it detects an imminent obstacle. It will then halt and scan its surroundings (left and right directions). It will then select and continue down the least obstructed direction.

If both directions are unobstructed, the vehicle will choose randomly. If both directions are obstructed, the vehicle will backup a certain distance and scan its environment again.

### Scope
- **Phase 1:** Componenets selection
	- *Deliverables*
		- A list of the hardware componenets
- **Phase 2:** Planning
	- *Deliverables*
		- Circuite schematics
		- Data flow graph
		- Call graph
		- UML diagram
- **Phase 3:** Implementation
	- *Deliverables*
		- Hardware assembly
		- Software implementation

### Prototypes
N/A

### Performance
Performance will be assessed based on 

1. number of colisions with obstacles, 
2. halt-distance from the obstacle, and 
3. power-efficiency.

### Usability
The vehicle will have an RGB LED that will be solid green during normal operation, and will flash red if the vehicles is in *pinned-mode*.

The reset button will restart normal operations.

### Safety
If the vehicle detects that it's path is blocked in all three directions, and defaults to back-tracking behaviour, it cannot back-track further than the distance it has ran since the last course-correction.

If the vehicle backtracks as far back as allowed and still finds it's left and right directions obstructed, it will enter *pinned-mode*, imobilising itself and switching the LED to flashing red.

## Deliverables

### Reports
The final deliverable is a report assessing the vehicle's performance as described in the *Performance* section of the report.

### Audits
N/A

### Outcomes
The system is considered complete upon successful completion of the performance assessment.

# 2. Componenets
The componenets were selected based on availability, cost, and what is commonly used in other similar projects.

1. SG90 Micro servo motor
	- [Datasheet](https://components101.com/sites/default/files/component_datasheet/SG90%20Servo%20Motor%20Datasheet.pdf)
	- Relevant specifications
		- Stall torque: 1.8 kg/cm
		- Operating speed: 0.1 s/60 degree
		- Operating voltage: 4.8 V (~5 V)
		- PWM period: 20ms (50Hz)
			- -90 degrees (left): ~1 ms pulse
			- 0 degrees (center): 1.5 ms pulse
			- 90 degrees (right): ~2 ms pulse
2. HC - SR04 Ultrasonic Ranging Module
	- [Datasheet](https://cdn.sparkfun.com/datasheets/Sensors/Proximity/HCSR04.pdf)
	- Relevant specifications
		- Operating voltage: 5 V
		- Operating current: 15 mA
		- Operating frequency: 40 Hz
		- Max range: 4 m
		- Min range: 2 cm
		- Trigger input signal: 10 µs TTL pulse
		- Echo output signal: TTL pulse in duration equal to time from trigger to echo
3. DC Motor (x4)
	- [Product page (amazon)](https://www.amazon.ca/gp/product/B075LD4FPN/ref=ppx_yo_dt_b_asin_title_o04_s00?ie=UTF8&psc=1)
	- Relevant specifications
		- Operating voltage: 6 V
4. Arduino DC Motor Shield
	- [Product page (amazon)](https://www.amazon.ca/gp/product/B07TTRXXJ5/ref=ppx_yo_dt_b_asin_title_o04_s00?ie=UTF8&psc=1)

# 3. Diagrams & Schematics

- Use pin 9 for servo ([library-based code](https://www.makerguides.com/servo-arduino-tutorial/))

# 4. Performance Assessment
