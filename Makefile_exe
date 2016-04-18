export PROJECT_NAME =
export AUTHOR	   =
export DESCRIPTION  =
export VERSION	  =
export LICENSE	  =
ROOT_SOURCE_DIR	 =
EXE_NAME			=
DDOCFILES		   =

# include some command
include command.make

SOURCES			 = $(getSource)
OBJECTS			 = $(patsubst %.d,$(BUILD_PATH)$(PATH_SEP)%.o,	$(SOURCES))
PICOBJECTS		  = $(patsubst %.d,$(BUILD_PATH)$(PATH_SEP)%.pic.o,$(SOURCES))
HEADERS			 = $(patsubst %.d,$(IMPORT_PATH)$(PATH_SEP)%.di,  $(SOURCES))
DOCUMENTATIONS	  = $(patsubst %.d,$(DOC_PATH)$(PATH_SEP)%.html,   $(SOURCES))
DDOCUMENTATIONS	 = $(patsubst %.d,$(DDOC_PATH)$(PATH_SEP)%.html,  $(SOURCES))
DDOC_FLAGS		  = $(foreach macro,$(DDOCFILES), $(DDOC_MACRO)$(macro))
DCFLAGS_IMPORT	 += $(foreach dir,$(ROOT_SOURCE_DIR), -I$(dir))

all: executable header doc

.PHONY : doc
.PHONY : ddoc
.PHONY : clean

executable: $(EXE_NAME)

header: $(HEADERS)

doc: $(DOCUMENTATIONS)

ddoc:
	$(DC) $(DDOC_FLAGS) index.d $(DF)$(DOC_PATH)$(PATH_SEP)index.html

# For build lib need create object files and after run make-lib
$(EXE_NAME): $(OBJECTS)
	$(DC) $^ $(OUTPUT)$@
	@echo ------------------ creating executable done

# create object files
$(BUILD_PATH)$(PATH_SEP)%.o : %.d
	$(DC) $(DCFLAGS) $(DCFLAGS_LINK) $(DCFLAGS_IMPORT) -c $< $(OUTPUT)$@

# Generate Header files
$(IMPORT_PATH)$(PATH_SEP)%.di : %.d
	$(DC) $(DCFLAGS) $(DCFLAGS_LINK) $(DCFLAGS_IMPORT) -c $(NO_OBJ) $< $(HF)$@

# Generate Documentation
$(DOC_PATH)$(PATH_SEP)%.html : %.d
	$(DC) $(DCFLAGS) $(DCFLAGS_LINK) $(DCFLAGS_IMPORT) -c $(NO_OBJ)  $< $(DF)$@

# Generate ddoc Documentation
$(DDOC_PATH)$(PATH_SEP)%.html : %.d
	$(DC) $(DCFLAGS) $(DCFLAGS_LINK) $(DCFLAGS_IMPORT) -c $(NO_OBJ) $(DDOC_FLAGS) $< $(DF)$@


############# CLEAN #############
clean: clean-objects clean-executable clean-doc clean-header
	@echo ------------------ cleaning $^ done

clean-objects:
	$(RM) $(OBJECTS)

clean-executable:
	$(RM) $(EXE_NAME)

clean-header:
	$(RM) $(HEADERS)

clean-doc:
	$(RM) $(DOCUMENTATIONS)
	$(RM) $(DOC_PATH)

clean-ddoc:
	$(RM) $(DDOCFILES)
	$(RM) $(DOC_PATH)$(PATH_SEP)index.html
	$(RM) $(DDOC_PATH)

############# INSTALL #############

install: install-executable install-doc install-header
	@echo ------------------ Installing $^ done

install-executable:
	$(MKDIR) $(DESTDIR)$(BIN_DIR)
	$(CP) $(EXE_NAME) $(DESTDIR)$(BIN_DIR)

install-header:
	$(MKDIR) $(DESTDIR)$(INCLUDE_DIR)
	$(CP) $(IMPORT_PATH) $(DESTDIR)$(INCLUDE_DIR)

install-doc:
	$(MKDIR) $(DESTDIR)$(DATA_DIR)$(PATH_SEP)doc$(PATH_SEP)$(PROJECT_NAME)$(PATH_SEP)normal_doc$(PATH_SEP)
	$(CP) $(DOC_PATH) $(DESTDIR)$(DATA_DIR)$(PATH_SEP)doc$(PATH_SEP)$(PROJECT_NAME)$(PATH_SEP)normal_doc$(PATH_SEP)

install-ddoc:
	$(MKDIR) $(DESTDIR)$(DATA_DIR)$(PATH_SEP)doc$(PATH_SEP)$(PROJECT_NAME)$(PATH_SEP)cute_doc$(PATH_SEP)
	$(CP) $(DDOC_PATH) $(DESTDIR)$(DATA_DIR)$(PATH_SEP)doc$(PATH_SEP)$(PROJECT_NAME)$(PATH_SEP)cute_doc$(PATH_SEP)
	$(CP) $(DDOC_PATH)$(PATH_SEP)index.html $(DESTDIR)$(DATA_DIR)$(PATH_SEP)doc$(PATH_SEP)$(PROJECT_NAME)$(PATH_SEP)cute_doc$(PATH_SEP)
