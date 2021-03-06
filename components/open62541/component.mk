#Where the cmake project lives under this subdirectory
CODESUBDIR := $(COMPONENT_PATH)/open62541

#Path and name of the generated library
#LIBRARY := libopen62541.a

#Some projects need include files that are not available in esp-idf. You can specify a directory to 'fake'
#these entries here. Note: this will not work if the project includes these in public header files.
INCLUDE_FIXUP_DIR := $(IDF_PATH)/components/lwip/include/lwip/posix

#Include directories other components/code can use to compile against this code
COMPONENT_ADD_INCLUDEDIRS := $(CODESUBDIR)/include $(CODESUBDIR)/src_generated $(CODESUBDIR)/plugins

#Add library to things linked in
COMPONENT_ADD_LDFLAGS := $(LIBRARY)

# C compiler flags
# original one: -std=gnu99 -Og -ggdb -ffunction-sections -fdata-sections -fstrict-volatile-bitfields -mlongcalls -nostdlib -Wall -Werror=all -Wno-error=unused-function -Wno-error=unused-but-set-variable -Wno-error=unused-variable -Wno-error=deprecated-declarations -Wextra -Wno-unused-parameter -Wno-sign-compare -Wno-old-style-declaration -DWITH_POSIX -DMBEDTLS_CONFIG_FILE='"mbedtls/esp_config.h"' -DHAVE_CONFIG_H  -g   -pipe -Wextra -Wformat -Wno-unused-parameter -Wno-unused-function -Wno-unused-label -Wpointer-arith -Wreturn-type -Wsign-compare -Wmultichar -Wstrict-overflow -Wcast-qual -Wmissing-prototypes -Winit-self -Wuninitialized -Wformat-security -Wformat-nonliteral -Wshadow -Wconversion -fvisibility=hidden -fPIC
CFLAGS := -Og -ggdb -ffunction-sections -fdata-sections -fstrict-volatile-bitfields -mlongcalls -nostdlib -Wall -Wno-error=unused-function -Wno-error=unused-but-set-variable -Wno-error=unused-variable -Wno-error=deprecated-declarations -Wextra -Wno-unused-parameter -Wno-sign-compare -Wno-old-style-declaration -DWITH_POSIX -DMBEDTLS_CONFIG_FILE='"mbedtls/esp_config.h"' -DHAVE_CONFIG_H  -g   -pipe -Wextra -Wformat -Wno-unused-parameter -Wno-unused-function -Wno-unused-label -Wpointer-arith -Wreturn-type -Wsign-compare -Wmultichar -Wstrict-overflow -Wcast-qual -Wmissing-prototypes -Winit-self -Wuninitialized -Wformat-security -Wformat-nonliteral -Wshadow -Wconversion -fvisibility=hidden -fPIC

# C preprocessor flags
CPPFLAGS := -Og -ggdb -ffunction-sections -fdata-sections -fstrict-volatile-bitfields -mlongcalls -nostdlib -Wall -Wno-error=unused-function -Wno-error=unused-but-set-variable -Wno-error=unused-variable -Wno-error=deprecated-declarations -Wextra -Wno-unused-parameter -Wno-sign-compare -Wno-old-style-declaration -DWITH_POSIX -DMBEDTLS_CONFIG_FILE='"mbedtls/esp_config.h"' -DHAVE_CONFIG_H  -g   -pipe -Wextra -Wformat -Wno-unused-parameter -Wno-unused-function -Wno-unused-label -Wpointer-arith -Wreturn-type -Wsign-compare -Wmultichar -Wstrict-overflow -Wcast-qual -Wmissing-prototypes -Winit-self -Wuninitialized -Wformat-security -Wformat-nonliteral -Wshadow -Wconversion -fvisibility=hidden -fPIC

CINCLUDES := $(COMPONENT_INCLUDES) $(COMPONENT_EXTRA_INCLUDES) $(COMPONENT_ADD_INCLUDEDIRS) $(INCLUDE_FIXUP_DIR)

CMAKE_TOOLCHAIN_FILE := cmake_toolchain_file.txt

#These configure cmake for cross compilation
$(CMAKE_TOOLCHAIN_FILE):
	${file >$(CMAKE_TOOLCHAIN_FILE),#Autogenerated from component.mk}
	${file >>$(CMAKE_TOOLCHAIN_FILE),SET(CMAKE_SYSTEM_NAME Generic)}
	${file >>$(CMAKE_TOOLCHAIN_FILE),SET(CMAKE_SYSTEM_VERSION 1)}
	${file >>$(CMAKE_TOOLCHAIN_FILE),SET(CMAKE_C_COMPILER $(CC))}
	${file >>$(CMAKE_TOOLCHAIN_FILE),SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)}
	${file >>$(CMAKE_TOOLCHAIN_FILE),SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)}
	${file >>$(CMAKE_TOOLCHAIN_FILE),SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)}
	${file >>$(CMAKE_TOOLCHAIN_FILE),SET(CFLAGS $(CFLAGS))}
	${foreach incdir,$(CINCLUDES),${file >>$(CMAKE_TOOLCHAIN_FILE),include_directories($(incdir))}}


#Use cmake to generate makefile
Makefile: $(CODESUBDIR)/CMakeLists.txt $(CMAKE_TOOLCHAIN_FILE) $(COMPONENT_PATH)/component.mk
	cmake -DCMAKE_TOOLCHAIN_FILE=$(CMAKE_TOOLCHAIN_FILE) $(CODESUBDIR) -DUA_ENABLE_AMALGAMATION:BOOL=ON

build: Makefile
ifeq ($(V),)
	make
else
	make VERBOSE=1
endif

clean: Makefile
	make clean
	rm -rf CMakeCache.txt CMakeFiles *.cmake $(LIBRARY)

#We have our own clean target
COMPONENT_OWNCLEANTARGET := clean
COMPONENT_OWNBUILDTARGE := build
