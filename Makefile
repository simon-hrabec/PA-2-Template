TARGETNAME          = prog
PROGTESTTARGETNAME  = progtest
HEADERSORTTARGETNAME= headersort

CC       = g++
CFLAGS   = -std=c++14 -Wall -pedantic

LINKER   = g++ -o
LFLAGS   = -std=c++14 -Wall -pedantic

SRCDIR    = src
HEADERDIR = headers
OBJDIR    = obj
BINDIR    = bin
PROGDIR   = progtest-output
PROGSRCDIR= progtest-generator

RM       = rm -rf

SOURCES  := $(wildcard $(SRCDIR)/*.cpp)
INCLUDES := $(wildcard $(HEADERDIR)/*.h)
OBJECTS  := $(SOURCES:$(SRCDIR)/%.cpp=$(OBJDIR)/%.o)

TARGET          = $(BINDIR)/$(TARGETNAME)
PROGTESTTARGET  = $(PROGDIR)/$(PROGTESTTARGETNAME)
HEADERSORTTARGET= $(PROGDIR)/$(HEADERSORTTARGETNAME)

HEADERSORTSRC = $(PROGSRCDIR)/$(HEADERSORTTARGETNAME).cpp
PROGTESTSRC = $(PROGTESTTARGET).cpp

#----------------BASIC COMMANDS----------------
.PHONY: all
all: $(TARGET)

$(TARGET): $(OBJECTS)
	@mkdir -p $(BINDIR)
	@$(LINKER) $@ $(LFLAGS) $(OBJECTS)
	@echo "Linking complete!"

$(OBJECTS): $(OBJDIR)/%.o : $(SRCDIR)/%.cpp
	@mkdir -p $(OBJDIR)
	@$(CC) $(CFLAGS) -c $< -o $@
	@echo "Compiled "$<" successfully!"

#----------------HELPER COMMANDS----------------
.PHONY: clean
clean:
	@$(RM) $(OBJDIR) $(BINDIR) $(PROGDIR)
	@echo "Cleanup complete!"

.PHONY: run
run: $(TARGET)
	$(TARGET)

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
	@test/testscript.sh $(TARGET)

#----------------PROGTEST COMMANDS----------------
.PHONY: progtest
progtest: $(PROGTESTTARGET) testprogtest

$(PROGTESTTARGET): $(HEADERSORTTARGET)
	@mkdir -p $(PROGDIR)/temp
	@grep -h 'include *<.*>' $(INCLUDES) $(SOURCES) | sort -u > $(PROGDIR)/temp/libheaderincludes
	@echo $(INCLUDES) | $(HEADERSORTTARGET) | xargs grep -hv "^#include " > $(PROGDIR)/temp/sortedheaders
	@grep -hv "^#include " $(SOURCES) > $(PROGDIR)/temp/sourcefiles

	@cat $(PROGDIR)/temp/libheaderincludes $(PROGDIR)/temp/sortedheaders $(PROGDIR)/temp/sourcefiles > $(PROGTESTSRC)
	@echo "Generated "$(PROGTESTSRC)" successfully!"
	@$(CC) $(CFLAGS) $(PROGTESTSRC) -o $(PROGTESTTARGET)
	@echo "Compiled "$(PROGTESTSRC)" successfully!"

$(HEADERSORTTARGET): $(HEADERSORTSRC)
	@mkdir -p $(PROGDIR)
	@$(CC) $(CFLAGS) $< -o $@

.PHONY: testprogtest
testprogtest: $(PROGTESTTARGET)
	@test/testscript.sh $(PROGTESTTARGET)
