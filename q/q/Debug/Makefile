################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL := cmd.exe
RM := rm -rf

USER_OBJS :=

LIBS := 
PROJ := 

O_SRCS := 
C_SRCS := 
S_SRCS := 
S_UPPER_SRCS := 
OBJ_SRCS := 
ASM_SRCS := 
PREPROCESSING_SRCS := 
OBJS := 
OBJS_AS_ARGS := 
C_DEPS := 
C_DEPS_AS_ARGS := 
EXECUTABLES := 
OUTPUT_FILE_PATH :=
OUTPUT_FILE_PATH_AS_ARGS :=
AVR_APP_PATH :=$$$AVR_APP_PATH$$$
QUOTE := "
ADDITIONAL_DEPENDENCIES:=
OUTPUT_FILE_DEP:=
LIB_DEP:=
LINKER_SCRIPT_DEP:=

# Every subdirectory with source files must be described here
SUBDIRS :=  \
../__vm/


# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS +=  \
../BME280.c \
../CFile1.c \
../Convert.c \
../Rain.c \
../twi.c \
../usart.c


PREPROCESSING_SRCS += 


ASM_SRCS += 


OBJS +=  \
BME280.o \
CFile1.o \
Convert.o \
Rain.o \
twi.o \
usart.o

OBJS_AS_ARGS +=  \
BME280.o \
CFile1.o \
Convert.o \
Rain.o \
twi.o \
usart.o

C_DEPS +=  \
BME280.d \
CFile1.d \
Convert.d \
Rain.d \
twi.d \
usart.d

C_DEPS_AS_ARGS +=  \
BME280.d \
CFile1.d \
Convert.d \
Rain.d \
twi.d \
usart.d

OUTPUT_FILE_PATH +=q.elf

OUTPUT_FILE_PATH_AS_ARGS +=q.elf

ADDITIONAL_DEPENDENCIES:=

OUTPUT_FILE_DEP:= ./makedep.mk

LIB_DEP+= 

LINKER_SCRIPT_DEP+= 


# AVR32/GNU C Compiler













./%.o: .././%.c
	@echo Building file: $<
	@echo Invoking: AVR8/GNU C Compiler : 5.4.0
	$(QUOTE)C:\Program Files (x86)\Atmel\Studio\7.0\toolchain\avr8\avr8-gnu-toolchain\bin\avr-gcc.exe$(QUOTE)  -x c -funsigned-char -funsigned-bitfields -D__AVR_ATmega328p__ -D__AVR_ATmega328P__ -DARDUINO=10805 -DARDUINO_MAIN -DF_CPU=16000000L -D__AVR__ -DARDUINO_AVR_NANO -DARDUINO_ARCH_AVR  -I"../../../q" -I"C:/Program Files (x86)/Arduino/libraries" -I"C:/Program Files (x86)/Arduino/hardware/arduino/avr/libraries" -I"C:/Users/pgmv2/Documents/Arduino/libraries" -I"C:/Program Files (x86)/Arduino/hardware/arduino/avr/cores/arduino" -I"C:/Program Files (x86)/Arduino/hardware/arduino/avr/variants/eightanaloginputs" -I"C:/Program Files (x86)/Arduino/hardware/tools/avr/avr/include" -I"C:/Program Files (x86)/Arduino/hardware/tools/avr/avr/include/avr" -I"C:/Program Files (x86)/Arduino/hardware/tools/avr/lib/gcc/avr/4.8.1/include" -I"C:/Program Files (x86)/Arduino/hardware/tools/avr/lib/gcc/avr/4.9.2/include" -I"C:/Program Files (x86)/Arduino/hardware/tools/avr/lib/gcc/avr/4.9.3/include"  -O1 -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -g2 -Wall -mmcu=atmega328p -B "C:\Program Files (x86)\Atmel\Studio\7.0\Packs\atmel\ATmega_DFP\1.2.150\gcc\dev\atmega328p" -c -std=gnu99 -include=arduino.h -MD -MP -MF "$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -MT"$(@:%.o=%.o)"   -o "$@" "$<" 
	@echo Finished building: $<
	



# AVR32/GNU Preprocessing Assembler



# AVR32/GNU Assembler




ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
endif

# Add inputs and outputs from these tool invocations to the build variables 

# All Target
all: $(OUTPUT_FILE_PATH) $(ADDITIONAL_DEPENDENCIES)

$(OUTPUT_FILE_PATH): $(OBJS) $(USER_OBJS) $(OUTPUT_FILE_DEP) $(LIB_DEP) $(LINKER_SCRIPT_DEP)
	@echo Building target: $@
	@echo Invoking: AVR8/GNU Linker : 5.4.0
	$(QUOTE)C:\Program Files (x86)\Atmel\Studio\7.0\toolchain\avr8\avr8-gnu-toolchain\bin\avr-g++.exe$(QUOTE) -o$(OUTPUT_FILE_PATH_AS_ARGS) $(OBJS_AS_ARGS) $(USER_OBJS) $(LIBS) -Wl,-Map="q.map" -Wl,--start-group -Wl,-lm  -Wl,--end-group -Wl,--gc-sections -mmcu=atmega328p -B "C:\Program Files (x86)\Atmel\Studio\7.0\Packs\atmel\ATmega_DFP\1.2.150\gcc\dev\atmega328p"  
	@echo Finished building target: $@
	"C:\Program Files (x86)\Atmel\Studio\7.0\toolchain\avr8\avr8-gnu-toolchain\bin\avr-objcopy.exe" -O ihex -R .eeprom -R .fuse -R .lock -R .signature -R .user_signatures  "q.elf" "q.hex"
	"C:\Program Files (x86)\Atmel\Studio\7.0\toolchain\avr8\avr8-gnu-toolchain\bin\avr-objcopy.exe" -j .eeprom  --set-section-flags=.eeprom=alloc,load --change-section-lma .eeprom=0  --no-change-warnings -O ihex "q.elf" "q.eep" || exit 0
	"C:\Program Files (x86)\Atmel\Studio\7.0\toolchain\avr8\avr8-gnu-toolchain\bin\avr-objdump.exe" -h -S "q.elf" > "q.lss"
	"C:\Program Files (x86)\Atmel\Studio\7.0\toolchain\avr8\avr8-gnu-toolchain\bin\avr-objcopy.exe" -O srec -R .eeprom -R .fuse -R .lock -R .signature -R .user_signatures "q.elf" "q.srec"
	"C:\Program Files (x86)\Atmel\Studio\7.0\toolchain\avr8\avr8-gnu-toolchain\bin\avr-size.exe" "q.elf"
	
	





# Other Targets
clean:
	-$(RM) $(OBJS_AS_ARGS) $(EXECUTABLES)  
	-$(RM) $(C_DEPS_AS_ARGS)   
	rm -rf "q.elf" "q.a" "q.hex" "q.lss" "q.eep" "q.map" "q.srec" "q.usersignatures"
	