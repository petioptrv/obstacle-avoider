GPP = avr-g++
GCC = avr-gcc
OBJCOPY = avr-objcopy
MAKEDIR = mkdir -p
CD = cd
RM = rm

FORMAT = ihex

MCU := atmega328p
PROGRAMMER := arduino
VARIANT := standard
BAUD := 115200

# MCU-specific parameters for: ATmega328P

AVR_TYPE = __AVR_ATmega328P__
F_CPU = 16000000L

APPFOLDER=$(CURDIR)
APP_CPP_FILES = $(wildcard src/*.cpp)
APP_C_FILES = $(wildcard src/*.c)

# Set the name of the output (ELF & Hex) file.
OUTPUT := chip_tester.$(MCU)
INCLUDE = -I $(APPFOLDER)/arduino -I $(APPFOLDER)/arduino/variants/$(VARIANT) \
			-I $(APPFOLDER)/arduino/libraries/EEPROM/src \
			-I $(APPFOLDER)/arduino/libraries/Wire/src \
			-I $(APPFOLDER)/arduino/libraries/SPI/src \
			-I $(APPFOLDER)/arduino/libraries/SD/src \
			-I $(APPFOLDER)/arduino/libraries/SD/src/utility

FLAGS := $(INCLUDE) -D$(AVR_TYPE) -DF_CPU=$(F_CPU) -DARDUINO=3000 -mmcu=$(MCU) -D__OPTIMIZE__ -fno-exceptions -ffunction-sections -fdata-sections -MMD -Os -g -flto -fuse-linker-plugin -Wl,-Map=$(APPFOLDER)/bin/$(OUTPUT).map,--cref -Wl,--gc-sections

CFLAGS := $(FLAGS) -std=gnu11
ASMFLAGS := $(CFLAGS) -x assembler-with-cpp -Wa,-gdwarf2
CPPFLAGS := $(FLAGS) -std=gnu++11 -fpermissive -fno-threadsafe-statics
CSOURCES := $(wildcard arduino/*.c) \
			$(wildcard arduino/libraries/Wire/src/utility/*.c) \
			$(APP_C_FILES)
ASMSOURCES := $(wildcard arduino/*.S)
CPPSOURCES := $(wildcard arduino/*.cpp) \
			$(wildcard arduino/libraries/Wire/src/*.cpp) \
			$(wildcard arduino/libraries/SPI/src/*.cpp) \
			$(wildcard arduino/libraries/SD/src/*.cpp) \
			$(wildcard arduino/libraries/SD/src/utility/*.cpp) \
			$(APP_CPP_FILES)
COBJECTS := $(addprefix $(APPFOLDER)/obj/,$(notdir) $(CSOURCES:.c=.o))
ASMOBJECTS := $(addprefix $(APPFOLDER)/obj/,$(notdir) $(ASMSOURCES:.S=_asm.o))
CPPOBJECTS := $(addprefix $(APPFOLDER)/obj/,$(notdir) $(CPPSOURCES:.cpp=.o))

all: makedir $(COBJECTS) $(ASMOBJECTS) $(CPPOBJECTS) $(APPFOLDER)/bin/$(OUTPUT).elf $(APPFOLDER)/bin/$(OUTPUT).hex

makedir:
	$(MAKEDIR) $(APPFOLDER)/obj/arch/avr
	$(MAKEDIR) $(APPFOLDER)/obj/src
	$(MAKEDIR) $(APPFOLDER)/obj/arduino/libraries/SPI/src
	$(MAKEDIR) $(APPFOLDER)/obj/arduino/libraries/Wire/src/utility
	$(MAKEDIR) $(APPFOLDER)/obj/arduino/libraries/SD/src/
	$(MAKEDIR) $(APPFOLDER)/obj/arduino/libraries/SD/src/utility
	$(MAKEDIR) $(APPFOLDER)/bin

$(APPFOLDER)/obj/%.o: %.c
	$(GCC) -c -o $@ $< $(CFLAGS)

$(APPFOLDER)/obj/%_asm.o: %.S
	$(GCC) -c -o $@ $< $(ASMFLAGS)

$(APPFOLDER)/obj/%.o: %.cpp
	$(GPP) -c -o $@ $< $(CPPFLAGS)

$(APPFOLDER)/obj/%.o: $(APPFOLDER)/%.c
	$(GCC) -c -o $@ $< $(CFLAGS)

$(APPFOLDER)/obj/%.o: $(APPFOLDER)/%.cpp
	$(GPP) -c -o $@ $< $(CPPFLAGS)
	
$(APPFOLDER)/bin/$(OUTPUT).elf:
	$(GPP) -o $@ $(COBJECTS) $(ASMOBJECTS) $(CPPOBJECTS) $(LIB) $(FLAGS)
	
$(APPFOLDER)/bin/%.hex: $(APPFOLDER)/bin/%.elf
	$(OBJCOPY) -O $(FORMAT) -R .eeprom $< $@
	
flash:
	$(CD) $(APPFOLDER) && \
	avrdude -v -p $(MCU) -c $(PROGRAMMER) -P $(COM_PORT) -b $(BAUD) -D -U flash:w:bin/$(OUTPUT).hex:i

clean:
	$(RM) $(COBJECTS) $(ASMOBJECTS) $(CPPOBJECTS) $(APPFOLDER)/bin/$(OUTPUT).*

