TARGETNAME   = prog

CC       = g++
CFLAGS   = -std=c++14 -Wall -pedantic

LINKER   = g++ -o
LFLAGS   = -std=c++14 -Wall -pedantic

SRCDIR   = src
HEADERDIR= headers
OBJDIR   = obj
BINDIR   = bin
PROGDIR  = progtest-output

RM       = rm -rf

SOURCES  := $(wildcard $(SRCDIR)/*.cpp)
INCLUDES := $(wildcard $(HEADERDIR)/*.h)
OBJECTS  := $(SOURCES:$(SRCDIR)/%.cpp=$(OBJDIR)/%.o)

TARGET = $(BINDIR)/$(TARGETNAME)

all: $(TARGET)

$(TARGET): $(OBJECTS)
	@mkdir -p $(BINDIR)
	@$(LINKER) $@ $(LFLAGS) $(OBJECTS)
	@echo "Linking complete!"

$(OBJECTS): $(OBJDIR)/%.o : $(SRCDIR)/%.cpp
	@mkdir -p $(OBJDIR)
	@$(CC) $(CFLAGS) -c $< -o $@
	@echo "Compiled "$<" successfully!"

progtest: $(PROGDIR)/progtest

$(PROGDIR)/progtest:
	@mkdir -p $(PROGDIR)
	@cat $(INCLUDES) $(SOURCES) | grep -v '#include ".*"' > $@.cpp
	@echo "Progtest-merged file generated"
	@$(CC) $(CFLAGS) $@.cpp -o $@
	@echo "Progtest-merged file successfully compiled"

.PHONY: clean
clean:
	@$(RM) $(OBJDIR) $(BINDIR) $(PROGDIR)
	@echo "Cleanup complete!"

.PHONY: todo
todo:
	@grep -n --with-filename "TODO" $(SOURCES) $(INCLUDES)

.PHONY: counttodo
counttodo:
	$(eval TODOSNUM := $(shell grep -n --with-filename "TODO" $(SOURCES) $(INCLUDES) | wc -l))

.PHONY: countwarnings
countwarnings:
	$(eval WARNINGSNUM := $(shell make --always-make all 2>&1 1> /dev/null | grep warning | wc -l))

.PHONY: status
status: counttodo countwarnings
	@echo "Project contains:"
	@echo "$(TODOSNUM) TODOs to finish"
	@echo "$(WARNINGSNUM) warnings durring compilation" 

.PHONY: test
test: $(TARGET)
	test/testscript.sh $(TARGET)

.PHONY: run
run: $(TARGET)
	$(TARGET)
