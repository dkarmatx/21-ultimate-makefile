################################################################################
#                                                                              #
#     @@@@@@@     @@       Ultimative makefile tool. Just include it, define   #
#            @@     @@     your sources list, include directories and target,  #
#            @@     @@     hit the MAKE and watch the magic.                   #
#      @@@@@@       @@                                                         #
#    @@             @@     made by DKARMATX (intra: HGRANULE)                  #
#      @@@@@@@      @@     2022-08-23 05:48                                    #
#                                                                              #
################################################################################

ifndef SOURCE_FILES
$(error Varibale SOURCE_FILES is REQUIRED)
endif

ifndef TARGET
$(error Variable TARGET is REQUIRED)
endif

__CC                   = $(if $(CC), $(CC), clang)
__SOURCE_DIRECTORY     = $(if $(SOURCE_DIR), $(SOURCE_DIR), src)
__BIN_DIRECTORY        = $(if $(BIN_DIR), $(BIN_DIR), bin)
__INCLUDE_DIRS         = $(__SOURCE_DIRECTORY) $(INCLUDE_DIRS)
__C_FLAGS              = $(addprefix -I, $(__INCLUDE_DIRS)) $(CFLAGS) $(C_FLAGS) $(FLAGS)
__L_FLAGS              = $(LDFLAGS) $(L_FLAGS) $(FLAGS)
__C_DEBUG_FLAGS        = -DDEBUG -g $(DEBUG_FLAGS)
__C_RELEASE_FLAGS      = -DRELEASE $(RELEASE_FLAGS)
__BUILD_DIRECTORY      = build

################################################################################
# COMMON FILES                                                                 #
################################################################################

__EXECUTABLE_FILE  = $(__BIN_DIRECTORY)/$(TARGET)
__OBJECT_FILES     = $(patsubst %, $(__BUILD_DIRECTORY)/%.o, $(SOURCE_FILES))
__DEPENDENCY_FILES = $(patsubst %, $(__BUILD_DIRECTORY)/%.d, $(SOURCE_FILES))

################################################################################
# RULES                                                                        #
################################################################################

.PHONY: all \
        clean \
        fclean \
        re \
        red \
        release \
        debug \
        help

all: release

clean:
	@rm -rf $(__BUILD_DIRECTORY)
fclean: clean
	@rm -f $(__EXECUTABLE_FILE)

re: fclean debug
red: fclean release

release: __HAS_BUILD_MODE = 1
release: __C_FLAGS += $(__C_RELEASE_FLAGS)
release: $(__EXECUTABLE_FILE)

debug: __HAS_BUILD_MODE = 1
debug: __C_FLAGS += $(__C_DEBUG_FLAGS)
debug: $(__EXECUTABLE_FILE)

$(__EXECUTABLE_FILE): $(__OBJECT_FILES)
	@printf "$(__FCLR_BLUE)[LD]$(__FCLR_RESET)  %s\e[$(__FCLR_TAB)D\e[$(__FCLR_TAB)C\e[6D$(__FCLR_RED)MAKING$(__FCLR_RESET)\n" "$@"
	$(call __check_build_mode)
	@mkdir -p $(dir $@)
	@$(__CC) $(__L_FLAGS) $^ -o $@
	@printf "$(__FCLR_UP)$(__FCLR_BLUE)[LD]$(__FCLR_RESET)  %s\e[$(__FCLR_TAB)D\e[$(__FCLR_TAB)C\e[8D$(__FCLR_GREEN)FINISHED$(__FCLR_RESET)\n" "$@"

$(__BUILD_DIRECTORY)/%.o: $(__SOURCE_DIRECTORY)/%
	@printf "$(__FCLR_YELLOW)[CC]$(__FCLR_RESET)  %s\e[$(__FCLR_TAB)D\e[$(__FCLR_TAB)C\e[6D$(__FCLR_RED)MAKING$(__FCLR_RESET)\n" "$<"
	$(call __check_build_mode)
	@mkdir -p $(dir $@)
	@$(__CC) $(__C_FLAGS) -MMD -o $@ -c $<
	@printf "$(__FCLR_UP)$(__FCLR_YELLOW)[CC]$(__FCLR_RESET)  %s\e[$(__FCLR_TAB)D\e[$(__FCLR_TAB)C\e[8D$(__FCLR_GREEN)FINISHED$(__FCLR_RESET)\n" "$<"
	

-include $(__DEPENDENCY_FILES)

################################################################################
# SYSTEM UTILS																   #
################################################################################

__FCLR_RED    = \e[31m
__FCLR_GREEN  = \e[32m
__FCLR_YELLOW = \e[33m
__FCLR_BLUE   = \e[36m
__FCLR_BOLD   = \e[1m
__FCLR_RESET  = \e[0m
__FCLR_UP     = \e[1A

__FCLR_TAB    = 100

__check_build_mode = \
	$(if $(__HAS_BUILD_MODE),, \
		$(error Undefined build mode))

help:
	@printf  "$(__FCLR_BOLD)21 ultimative makefile$(__FCLR_RESET) (by dkarmatx)\n"
	@printf  "\n"
	@printf  "$(__FCLR_BOLD)Description:$(__FCLR_RESET)\n"
	@printf  "    This is an ultimative makefile which could compile simple program by\n"
	@printf  "    user-defined list of source files. For make it work just define target,\n"
	@printf  "    sources list and include \"21.mk\" to your makefile. It has predefined rules\n"
	@printf  "    to build your target or to clean up your workspace.\n"
	@printf  "\n"
	@printf  "$(__FCLR_BOLD)Rules:$(__FCLR_RESET)\n"
	@printf  "    $(__FCLR_BOLD)clean$(__FCLR_RESET)     - clean up object files\n"
	@printf  "    $(__FCLR_BOLD)fclean$(__FCLR_RESET)    - clean up object files and target\n"
	@printf  "    $(__FCLR_BOLD)all$(__FCLR_RESET)       - same as \"release\" rule\n"
	@printf  "    $(__FCLR_BOLD)re$(__FCLR_RESET)        - same as \"fclean\" and \"release\" rules\n"
	@printf  "    $(__FCLR_BOLD)red$(__FCLR_RESET)       - same as \"fclean\" and \"debug\" rules\n"
	@printf  "    $(__FCLR_BOLD)release$(__FCLR_RESET)   - build your target at release mode\n"
	@printf  "    $(__FCLR_BOLD)debug$(__FCLR_RESET)     - build your target at debug mode\n"
	@printf  "    $(__FCLR_BOLD)help$(__FCLR_RESET)      - prints this message\n"
	@printf  "\n"
	@printf  "$(__FCLR_BOLD)Required variables:$(__FCLR_RESET)\n"
	@printf  "    $(__FCLR_BOLD)TARGET$(__FCLR_RESET)       - name of the executable\n"
	@printf  "    $(__FCLR_BOLD)SOURCE_FILES$(__FCLR_RESET) - list of filenames located at source directory\n"
	@printf  "\n"
	@printf  "$(__FCLR_BOLD)Optional variables:$(__FCLR_RESET)\n"
	@printf  "    $(__FCLR_BOLD)CC$(__FCLR_RESET)           - C language compiler program to use\n"
	@printf  "    $(__FCLR_BOLD)SOURCE_DIR$(__FCLR_RESET)   - source directory\n"
	@printf  "    $(__FCLR_BOLD)BIN_DIR$(__FCLR_RESET)      - output directory\n"
	@printf  "    $(__FCLR_BOLD)INCLUDE_DIRS$(__FCLR_RESET) - space separated list of include directories\n"
	@printf  "    $(__FCLR_BOLD)C_FLAGS$(__FCLR_RESET)      - flags for C compiler\n"
	@printf  "    $(__FCLR_BOLD)L_FLAGS$(__FCLR_RESET)      - flags for linker\n"
	@printf  "\n"
