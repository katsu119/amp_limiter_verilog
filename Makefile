TOP_NAME ?= limiter
NXDC_FILES = ./constr/$(TOP_NAME).nxdc
INC_PATH ?=

PROJ_NAME ?= ./new_proj

# Build related diretories
BUILD_DIR = ./build
OBJ_DIR = $(BUILD_DIR)/obj_dir
BIN = $(BUILD_DIR)/$(TOP_NAME)
WAVEFORM = $(BUILD_DIR)/waveform.vcd

$(shell mkdir -p $(BUILD_DIR))

VERILATOR = verilator
VERILATOR_CFLAG += -MMD --build -O3 --cc --trace \
				   --x-assign fast --x-assign fast

default: sim

# constraint file
SRC_AUTO_BIND = $(abspath $(BUILD_DIR)/auto_bind.cpp)
# $(SRC_AUTO_BIND): $(NXDC_FILES)
# 	python3 $(NVBOARD_HOME)/scripts/auto_pin_bind.py $^ $@

include $(NVBOARD_HOME)/scripts/nvboard.mk

# project source files
VSRCS = $(shell find $(abspath ./vsrc) -name "*.v" -or -name "*.sv")
#CSRCS = $(shell find $(abspath ./csrc) -name "*.c" -or -name "*.cc" -or -name "*.cpp")
CSRCS = $(shell find $(abspath ./csrc) -name "$(TOP_NAME).cpp" )
#CSRCS = $(wildcard ./csrc/$(TOP_NAME).c*)
# CSRCS += $(SRC_AUTO_BIND)

# rules for cflags and ldflags
INCFLAGS = $(addprefix -I, $(INC_PATH))
CFLAGS += $(INCFLAGS) -DTOP_NAME="\"V$(TOP_NAME)"\"
LDFLAGS += $(addprefix -l,SDL2 SDL2_image)

.PHONY: all
all: sim

.PHONY: sim
sim: $(WAVEFORM) 
	# $(call git_commit, "sim RTL") # DO NOT REMOVE THIS LINE!!!
	@echo "##### Display Waveform #####"
	gtkwave $(WAVEFORM)

$(WAVEFORM): $(BIN)
	@echo "##### Simulation Running #####"
	cd $(BUILD_DIR) && ./$(TOP_NAME)
.PHONY: run
run: $(BIN)
	$^

$(BIN): $(VSRCS) $(CSRCS) $(NVBOARD_ARCHIVE)
	@echo "##### Compiling Files #####"
	$(VERILATOR) $(VERILATOR_CFLAG) \
		--top $(TOP_NAME) $^ \
		$(addprefix -CFLAGS , $(CFLAGS)) $(addprefix -LDFLAGS , $(LDFLAGS)) \
		--Mdir $(OBJ_DIR) --exe -o $(abspath $(BIN))

.PHONY: new 
new: 
	mkdir -p $(PROJ_NAME)/csrc $(PROJ_NAME)/vsrc $(PROJ_NAME)/constr
	touch $(PROJ_NAME)/constr/$(TOP_NAME).nxdc
	cp ./Makefile $(PROJ_NAME)/

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)

include $(NPC_HOME)/../Makefile
