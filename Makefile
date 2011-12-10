
export PROJECT_NAME = 
export AUTHOR       = 
export DESCRIPTION  = 
export VERSION      = 
export LICENSE      = 
SOURCES             = 

# include some command
include command.make

DDOCFILES	        = 
OBJECTS             = $(patsubst %.d,$(BUILD_PATH)/%.o,    $(SOURCES))
PICOBJECTS          = $(patsubst %.d,$(BUILD_PATH)/%.pic.o,$(SOURCES))
HEADERS             = $(patsubst %.d,$(IMPORT_PATH)/%.di,  $(SOURCES))
DOCUMENTATIONS      = $(patsubst %.d,$(DOC_PATH)/%.html,   $(SOURCES))
define make-lib
	$(MKDIR) $(DLIB_PATH)
	$(AR) rcs $(DLIB_PATH)/$@ $^
	$(RANLIB) $(DLIB_PATH)/$@
endef

all: static-libs header doc pkgfile

.PHONY : pkgfile
.PHONY : doc
.PHONY : ddoc
.PHONY : clean

static-libs: $(LIBNAME)

shared-libs: $(SONAME)

header: $(HEADERS)

doc: $(DOCUMENTATIONS)

ddoc:
	$(DC) $(DDOCFILES) index.d $(DF)$(DOC_PATH)/index.html

geany-tag:
	$(MKDIR) geany_config
	geany -c geany_config -g $(PROJECT_NAME).d.tags $(SOURCES)

pkgfile:
	@echo ------------------ creating pkg-config file
	@echo "# Package Information for pkg-config"                        >  $(PKG_CONFIG_FILE)
	@echo "# Author: $(AUTHOR)"                                         >> $(PKG_CONFIG_FILE)
	@echo "# Created: `date`"                                           >> $(PKG_CONFIG_FILE)
	@echo "# Licence: $(LICENSE)"                                       >> $(PKG_CONFIG_FILE)
	@echo                                                               >> $(PKG_CONFIG_FILE)
	@echo prefix=$(PREFIX)                                              >> $(PKG_CONFIG_FILE)
	@echo exec_prefix=$(PREFIX)                                         >> $(PKG_CONFIG_FILE)
	@echo libdir=$(LIB_DIR)                                             >> $(PKG_CONFIG_FILE)
	@echo includedir=$(INCLUDE_DIR)                                     >> $(PKG_CONFIG_FILE)
	@echo                                                               >> $(PKG_CONFIG_FILE)
	@echo Name: "$(PROJECT_NAME)"                                       >> $(PKG_CONFIG_FILE)
	@echo Description: "$(DESCRIPTION)"                                 >> $(PKG_CONFIG_FILE)
	@echo Version: "$(VERSION)"                                         >> $(PKG_CONFIG_FILE)
	@echo Libs: -L$(LIB_DIR) $(LINKERFLAG)-l$(PROJECT_NAME)-$(COMPILER) >> $(PKG_CONFIG_FILE)
	@echo Cflags: -I$(INCLUDE_DIR)                                      >> $(PKG_CONFIG_FILE)
	@echo                                                               >> $(PKG_CONFIG_FILE)
	

# For build lib need create object files and after run make-lib
$(LIBNAME): $(OBJECTS)
	$(make-lib)

# create object files
$(BUILD_PATH)/%.o : %.d
	$(DC) $(DFLAGS) $(DFLAGS_LINK) $(DFLAGS_IMPORT) -c $< $(OUTPUT)$@

# create shared object files
$(BUILD_PATH)/%.pic.o : %.d
	$(DC) $(DFLAGS) $(DFLAGS_LINK) $(FPIC) $(DFLAGS_IMPORT) -c $< $(OUTPUT)$@

# Generate Header files
$(IMPORT_PATH)/%.di : %.d
	$(DC) $(DFLAGS) $(DFLAGS_LINK) $(DFLAGS_IMPORT) -c -o- $< $(HF)$@

# Generate Documentation
$(DOC_PATH)/%.html : %.d
	$(DC) $(DFLAGS) $(DFLAGS_LINK) $(DFLAGS_IMPORT) -c -o- $< $(DDOCFILES) $(DF)$@

# For build shared lib need create shared object files
$(SONAME): $(PICOBJECTS)
	$(MKDIR) $(DLIB_PATH)
	$(CC) -shared $^ -o $(DLIB_PATH)/$@

# create shared object files
$(BUILD_PATH)/%.pic.o : %.d
	$(DC) $(DFLAGS) $(DFLAGS_LINK) $(FPIC) $(DFLAGS_IMPORT) -c $< $(OUTPUT) $@ 

clean:
	$(RM) $(OBJECTS)
	$(RM) $(PICOBJECTS)
	$(RM) $(LIBNAME)
	$(RM) $(HEADERS)
	$(RM) $(DOCUMENTATIONS)
	$(RM) $(DOC_PATH)/index.html
	$(RM) $(PKG_CONFIG_FILE)

install:
	$(MKDIR) $(LIB_DIR)
	$(CP) $(DLIB_PATH)/* $(LIB_DIR)
	$(MKDIR) $(INCLUDE_DIR)
	$(CP) $(IMPORT_PATH) $(INCLUDE_DIR)
	$(MKDIR) $(PKGCONFIG_DIR)
	$(CP) $(PKG_CONFIG_FILE) $(PKGCONFIG_DIR)

