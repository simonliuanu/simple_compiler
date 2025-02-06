# Compiler name
TARGET = compiler

# Flex and Bison source files
LEX_SRC = simple.l
BISON_SRC = simple.y

# Generated files
BISON_OUTPUT = simple.tab.c
BISON_HEADER = simple.tab.h
LEX_OUTPUT = lex.yy.c

# Default target
all: $(TARGET)

# Build the compiler executable
$(TARGET): $(BISON_OUTPUT) $(LEX_OUTPUT)
	# Link the generated files with the Flex library (-lfl)
	gcc -o $(TARGET) $(BISON_OUTPUT) $(LEX_OUTPUT) -lfl

# Generate Bison parser source and header
$(BISON_OUTPUT): $(BISON_SRC)
	bison -d $(BISON_SRC)

# Generate Flex scanner source
$(LEX_OUTPUT): $(LEX_SRC)
	flex $(LEX_SRC)

# Clean generated files
clean:
	rm -f $(TARGET) $(BISON_OUTPUT) $(BISON_HEADER) $(LEX_OUTPUT)
