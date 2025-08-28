# Makefile for Oracle ODBC C Project

# Compiler and flags
CC = gcc
CFLAGS = -Wall -Wextra -std=c99 -Wno-format -g
LDFLAGS = -lodbc

# Directories
SRC_DIR = src
BIN_DIR = bin
OBJ_DIR = obj

# Source files
SOURCES = $(wildcard $(SRC_DIR)/*.c)
OBJECTS = $(SOURCES:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)
TARGET = $(BIN_DIR)/t_odbc

# ODBC include paths (adjust based on your system)
ODBC_INCLUDE = -I/usr/include/odbc -I/usr/local/include/odbc -I/opt/oracle/instantclient/sdk/include

# Default target
all: $(TARGET)

# Create directories if they don't exist
$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

# Build target
$(TARGET): $(OBJECTS) | $(BIN_DIR)
	$(CC) $(OBJECTS) -o $@ $(LDFLAGS)

# Compile source files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) $(ODBC_INCLUDE) -c $< -o $@

# Clean build files
clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

# Install ODBC dependencies (Ubuntu/Debian)
install-deps:
	sudo apt-get update
	sudo apt-get install -y unixodbc-dev unixodbc
	@echo "ODBC development libraries installed"
	@echo "You still need to install Oracle Instant Client and Oracle ODBC driver"

# Check ODBC installation
check-odbc:
	@echo "Checking ODBC installation..."
	@which odbcinst || echo "odbcinst not found - install unixODBC"
	@which isql || echo "isql not found - install unixODBC"
	@echo "Checking for ODBC headers..."
	@find /usr/include /usr/local/include -name "sql.h" 2>/dev/null || echo "sql.h not found"
	@echo "Checking for ODBC libraries..."
	@find /usr/lib /usr/local/lib -name "libodbc*" 2>/dev/null || echo "ODBC libraries not found"

# Run the program
run: $(TARGET)
	./$(TARGET)

# Help target
help:
	@echo "Available targets:"
	@echo "  all          - Build the project"
	@echo "  clean        - Remove build files"
	@echo "  install-deps - Install ODBC development dependencies"
	@echo "  check-odbc   - Check ODBC installation"
	@echo "  run          - Build and run the program"
	@echo "  help         - Show this help message"

.PHONY: all clean install-deps check-odbc run help
