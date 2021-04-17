# all the files will be generated with this name (main.elf, main.bin, main.hex, etc)
PROJECT_NAME	= stm32-demo

############################################################
# toolchain
############################################################
BINPATH = /usr/local/Arm/gcc-arm-none-eabi-8-2018-q4-major/bin
TOOLCHAIN    	= $(BINPATH)/arm-none-eabi-
CC           	= $(TOOLCHAIN)gcc
AS           	= $(TOOLCHAIN)gcc -x assembler-with-cpp
CP           	= $(TOOLCHAIN)objcopy
AR 				= $(TOOLCHAIN)ar
HEX          	= $(CP) -O ihex
BIN          	= $(CP) -O binary -S

############################################################
# directories in the root dir
############################################################
ROOT_DIR     	= .
USER_DIR     	= $(ROOT_DIR)/hardware
BUILD_DIR    	= $(ROOT_DIR)/build
STM32F10x_LIB_DIR      = $(ROOT_DIR)/libraries

############################################################
# MCU information
############################################################
# define mcu, specify the target processor
MCU          	= cortex-m3

# debug build?
DEBUG = 1

# link file
LINK_SCRIPT  	= $(ROOT_DIR)/libraries/script/linker/stm32_flash_512_64_F103ZE.ld

# specify define
DDEFS       	=

# run from Flash
DEFS	 		= $(DDEFS) -DRUN_FROM_FLASH=1

# Define optimisation level here
OPT 			= -Os

############################################################
# configuration for user src file and include path
############################################################
USER_INCLUDE_DIRS 	= .
USER_SRC 			=
# configuration for user hardware files
include $(USER_DIR)/makefile_hardware.mk

############################################################
# configuration for STM32 Standard Peripheral Library
############################################################
STM32F10X_LIB_SRC   =
INCLUDE_DIRS 		= 
ASM_SRC      		=
include $(STM32F10x_LIB_DIR)/makefile_std_lib.mk

############################################################
# gcc flags
############################################################
INC_DIR  	= $(patsubst %, -I%, $(INCLUDE_DIRS) $(USER_INCLUDE_DIRS))

MCU_FLAGS 	= -mcpu=$(MCU)

CP_FLAGS 	= $(MCU_FLAGS) $(OPT) -mthumb -fomit-frame-pointer -Wall -fdata-sections -ffunction-sections -fverbose-asm -Wa,-ahlms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $(DEFS)

ifeq ($(DEBUG), 1)
	CP_FLAGS += -g -gdwarf-2
endif

CP_FLAGS	+= -MMD -MP -MF"$(@:%.0=%.d)" -MT"$(@:%.o=%.d)"

AS_FLAGS 	= $(MCU_FLAGS) -mthumb  -Wa,-ahlms=$(BUILD_DIR)/$(notdir $(<:.s=.lst))

LD_FLAGS 	= $(MCU_FLAGS) -g -gdwarf-2 -mthumb -nostartfiles -Xlinker --gc-sections -T$(LINK_SCRIPT) -Wl,-Map=$(BUILD_DIR)/$(PROJECT_NAME).map,--cref,--no-warn-mismatch

############################################################
# configuration for objects
############################################################
S_OBJECTS 	= $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SRC:.s=.o)))
C_OBJECTS 	= $(addprefix $(BUILD_DIR)/,$(notdir $(USER_SRC:.c=.o)))
C_OBJECTS 	+= $(addprefix $(BUILD_DIR)/,$(notdir $(STM32F10X_LIB_SRC:.c=.o)))
# codes below add all the .c file to path when using %.o:%.c
vpath %.s $(sort $(dir $(ASM_SRC)))
vpath %.c $(sort $(dir $(USER_SRC)))
vpath %.c $(sort $(dir $(STM32F10X_LIB_SRC)))

# make rules
include makefile_rules.mk

# *** EOF ***
