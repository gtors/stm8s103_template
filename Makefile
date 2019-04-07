# STM8 device (for supported devices see stm8s.h)
DEVICE=STM8S103

FLASHUTIL  = stm8flash
FLASHFLAGS = -c stlinkv2 -p stm8s103 -w 

# set compiler path & parameters 
CC_ROOT =
CC      = sdcc
CFLAGS  = -mstm8 -lstm8 --opt-code-size

# set output folder and target name
OUTPUT_DIR = ./out
TARGET     = $(OUTPUT_DIR)/$(DEVICE).hex

# set project folder and files (all *.c)
PRJ_ROOT    = .
PRJ_SRC_DIR = $(PRJ_ROOT)
PRJ_INC_DIR = $(PRJ_ROOT)
PRJ_SOURCE  = $(notdir $(wildcard $(PRJ_SRC_DIR)/*.c))
PRJ_OBJECTS := $(addprefix $(OUTPUT_DIR)/, $(PRJ_SOURCE:.c=.rel))

# set SPL paths
SPL_ROOT    = ./spl
SPL_SRC_DIR = $(SPL_ROOT)/src
SPL_INC_DIR = $(SPL_ROOT)/inc
SPL_SOURCE  = stm8s_gpio.c
SPL_OBJECTS := $(addprefix $(OUTPUT_DIR)/, $(SPL_SOURCE:.c=.rel))

# set path to STM8S_EVAL board routines
EVAL_DIR     = $(SPL_ROOT)/utils/STM8S_EVAL
EVAL_SOURCE  = 
EVAL_OBJECTS := $(addprefix $(OUTPUT_DIR)/, $(EVAL_SOURCE:.c=.rel))

# set path to STM8S_EVAL common routines
EVAL_COMM_DIR     = $(EVAL_DIR)/Common
EVAL_COMM_SOURCE  = 
EVAL_COMM_OBJECTS := $(addprefix $(OUTPUT_DIR)/, $(EVAL_COMM_SOURCE:.c=.rel))

# set path to STM8-128_EVAL board routines
EVAL_STM8S_128K_DIR     = $(EVAL_DIR)/STM8-128_EVAL
EVAL_STM8S_128K_SOURCE  = 
EVAL_STM8S_128K_OBJECTS := $(addprefix $(OUTPUT_DIR)/, $(EVAL_STM8S_128K_SOURCE:.c=.rel))

# collect all include folders
INCLUDE = -I$(PRJ_SRC_DIR) -I$(SPL_INC_DIR) -I$(EVAL_DIR) -I$(EVAL_COMM_DIR) -I$(EVAL_STM8S_128K_DIR)

# collect all source directories
VPATH=$(PRJ_SRC_DIR):$(SPL_SRC_DIR):$(EVAL_DIR):$(EVAL_COMM_DIR):$(EVAL_STM8S_128K_DIR)


.PHONY : clean flash all

all : $(OUTPUT_DIR) $(TARGET)

$(OUTPUT_DIR):
	mkdir -p $(OUTPUT_DIR)

$(OUTPUT_DIR)/%.rel: %.c
	$(CC) $(CFLAGS) $(INCLUDE) -D$(DEVICE) -c $? -o $@

$(TARGET): $(PRJ_OBJECTS) $(SPL_OBJECTS) $(EVAL_OBJECTS) $(EVAL_COMM_OBJECTS) $(EVAL_STM8S_128K_OBJECTS)
	$(CC) $(CFLAGS) -o $(TARGET) $^

clean :
	rm -f *.cdb *.lk *.lst *.map *.rel *.rst *.sym *.asm

flash : all
	$(FLASHUTIL) $(FLASHFLAGS) $(TARGET)
	make clean
