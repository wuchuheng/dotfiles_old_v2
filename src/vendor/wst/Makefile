# Makefile for compiling the 'bar' project

# Compiler and compiler flags
CC := gcc
CFLAGS := -Wall -Wextra -Werror
# the width of string in terminal.
APP_NAME := wst

# Output directory
OUTPUT_DIR := bin

# Source files directory
SRC_DIR := src

$(shell mkdir "bin")

# Platform-specific configurations
ifeq ($(shell uname -s),Darwin)
	# macOS
	EXECUTABLE_X86 := $(OUTPUT_DIR)/$(APP_NAME)_darwin_x86_64
	EXECUTABLE_ARM := $(OUTPUT_DIR)/$(APP_NAME)_darwin_arm64
else
	# Linux or other Unix-like systems
	EXECUTABLE_X86 := $(OUTPUT_DIR)/$(APP_NAME)_linux_x86_64
	EXECUTABLE_ARM := $(OUTPUT_DIR)/$(APP_NAME)_linux_arm64
endif

# Create the output directory if it doesn't exist
$(shell mkdir -p $(OUTPUT_DIR))

# Default target: build all platforms
all: $(EXECUTABLE_X86) $(EXECUTABLE_ARM)

# Target for building the executable for macOS (x86_64)
$(EXECUTABLE_X86): $(SRC_DIR)/main.c
ifeq ($(shell uname -s),Darwin)
	# macOS
	$(CC) $(CFLAGS) -arch x86_64 $< -o $@
else
	# Linux or other Unix-like systems
	$(CC) $(CFLAGS) -m64  $< -o $@
endif

# Target for building the executable for macOS (arm64)
$(EXECUTABLE_ARM): $(SRC_DIR)/main.c
ifeq ($(shell uname -s),Darwin)
	# macOS
	$(CC) $(CFLAGS) -arch arm64 $< -o $@
endif

# Target for cleaning the build
clean:
	rm -rf bin
