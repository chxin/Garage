# user include
USER_INCLUDE_DIRS  += $(USER_DIR)
USER_INCLUDE_DIRS  += $(subst :,,$(shell ls -R $(USER_DIR) | grep :))

# user specific src file
USER_SRC			= $(foreach dir_name, $(USER_INCLUDE_DIRS), $(wildcard *.c $(dir_name)/*.c))
