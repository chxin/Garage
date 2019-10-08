#
# makefile rules
#
OUTPUT_DIR = $(BUILD_DIR)/output
all: $(C_OBJECTS) $(S_OBJECTS) $(OUTPUT_DIR)/$(PROJECT_NAME).elf  $(OUTPUT_DIR)/$(PROJECT_NAME).hex $(OUTPUT_DIR)/$(PROJECT_NAME).bin
	$(TOOLCHAIN)size $(OUTPUT_DIR)/$(PROJECT_NAME).elf

$(BUILD_DIR)/%.o: %.c Makefile | $(OUTPUT_DIR) 
	$(CC) -c $(CP_FLAGS) $(INC_DIR) $< -o $@

$(BUILD_DIR)/%.o: %.s Makefile | $(OUTPUT_DIR)
	$(AS) -c $(AS_FLAGS) $< -o $@

$(OUTPUT_DIR)/$(PROJECT_NAME).elf: $(C_OBJECTS) $(S_OBJECTS) Makefile
	# mkdir -p $(OUTPUT_DIR)
	$(CC) $(C_OBJECTS) $(S_OBJECTS) $(LD_FLAGS) -o $@

$(OUTPUT_DIR)/%.hex: $(OUTPUT_DIR)/%.elf | $(OUTPUT_DIR)
	$(HEX) $< $@

$(OUTPUT_DIR)/%.bin: $(OUTPUT_DIR)/%.elf | $(OUTPUT_DIR)
	$(BIN) $< $@

$(OUTPUT_DIR):
	mkdir -p $@

flash: $(OUTPUT_DIR)/$(PROJECT_NAME).bin
	st-flash write $(OUTPUT_DIR)/$(PROJECT_NAME).bin 0x8000000

erase:
	st-flash erase

clean:
	-rm $(C_OBJECTS)
	-rm $(S_OBJECTS)
	-rm $(C_OBJECTS:.o=.lst)
	-rm $(S_OBJECTS:.o=.lst)

cleanall: clean
	-rm $(BUILD_DIR)/$(PROJECT_NAME).map
	-rm $(OUTPUT_DIR)/$(PROJECT_NAME).elf
	-rm $(OUTPUT_DIR)/$(PROJECT_NAME).hex
	-rm $(OUTPUT_DIR)/$(PROJECT_NAME).bin

status:
	@ echo $(USER_SRC)
	@ echo $(ASM_SRC)
	@ echo $(STM32F10X_LIB_SRC)
	@ echo $(USER_INCLUDE_DIRS)
	@ echo $(INCLUDE_DIRS)
	@ echo $(C_OBJECTS)
	@ echo $(S_OBJECTS)

include:
	@ echo $(INC_DIR) > .clang_complete
