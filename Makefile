SHELL		:= bash

BUILD_DIR	:= ./build
SRC_DIR		:= ./srcs/
OBJ_DIR		:= $(BUILD_DIR)/objs/
DEP_DIR		:= $(BUILD_DIR)/deps/

SRCS		:= $(shell find . -name '*.c')
OBJS		:= $(patsubst $(SRC_DIR)%,$(OBJ_DIR)%, $(SRCS:.c=.o))
DEPS		:= $(patsubst $(SRC_DIR)%,$(DEP_DIR)%, $(SRCS:.c=.d))

CC			:= cc
CFLAGS		:= -Wall -Wextra -MMD
#LDLIBS	=
TARGET		:= bin

all: ${TARGET}

debug:
	@echo $(SRCS)
	@echo $(OBJS)
	@echo $(DEPS)

${TARGET}: ${OBJS}
	@if ${CC} ${OBJS} -o ${TARGET} ${LDLIBS} >/dev/null 2>&1; then \
		printf "\n\e[38;2;0;229;232m Compilation \e[0m $(TARGET) \e[38;2;84;213;52m	\e[75G OK\n\e[0m"; \
	else \
		printf "\n\e[38;2;0;229;232m Compilation \e[0m $(TARGET) \e[38;2;213;84;52m	\e[75G KO\n\e[0m"; \
		${CC} ${OBJS} -o ${TARGET} ${LDLIBS}>/dev/null; \
	fi

$(OBJ_DIR)%.o: $(SRC_DIR)%.c
	@mkdir -p $(dir $@) >/dev/null
	@mkdir -p $(patsubst $(OBJ_DIR)%,$(DEP_DIR)%, ./$(dir $@)) >/dev/null
	@if ${CC} ${CFLAGS} -MF $(DEP_DIR)$*.d -c $< -o $@ >/dev/null 2>err_makefile.log; then \
		printf "\e[38;2;0;229;232m Compilation \e[0m $*.c \e[38;2;84;213;52m	\e[75G OK\n\e[0m"; \
	else \
		printf "\e[38;2;0;229;232m Compilation \e[0m $*.c \e[38;2;213;84;52m	\e[75G KO\n\e[0m"; \
		${CC} ${CFLAGS} -MF $(DEP_DIR)$*.d -c $< -o $@ >/dev/null; \
	fi

clean:
	@rm -rf $(BUILD_DIR)
	@rm -rf err_makefile.log

fclean: clean
	@rm -rf $(TARGET)

-include $(DEPS)
