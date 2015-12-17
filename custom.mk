#### for arm (embedded cpu board)
#QMAKE_OPT:=-spec qws/linux-arm-g++ 
#MY_CFLAGS:=-D__ICS_ARM__

#### for PC (x86, x86_64)
CROSS_COMPILE:=2
QT_QUICK_VER:=5

#constant values for specific platforms
ARMV7L:=1
LINUX_X86:=2
LINUX_X86_64:=3
MINGW_X86:=4
MACOS_X86_64:=5
MSYS_X86:=6

QMAKE_OPT:= 
MY_CFLAGS:=-D__ICS_INTEL__
VERSION:=1.1.0
#indicate QT QUICK VERSION, 5: used for QT 5, 4 for QT 4
QQ_VERSION:=1.1
QML_DIR:=qml
QML_GEN_DIR:=qml-gen

ifeq ($(QT_QUICK_VER),4)
	QtQuick:=import QtQuick 1.1
	QtWindow:=
	Window:=Rectangle
else
	QtQuick:=import QtQuick 2.3
	QtWindow:=import QtQuick.Window 2.2
	Window:=Window
endif

ifeq ($(CROSS_COMPILE),$(ARMV7L))
	CROSS_TOOL:=$(EX)-gcc
	LIBS_DIR:=../libs/linux-armv7l
	EX:=arm-none-linux-gnueabi
	LIBS:= -L$(LIBS_DIR)/lib $(LIBS_DIR)/lib/libjson-c.a -lpjsua2-$(EX) -lstdc++ -lpjsua-$(EX) -lpjsip-ua-$(EX) -lpjsip-simple-$(EX) -lpjsip-$(EX) -lpjmedia-codec-$(EX) -lpjmedia-$(EX) -lpjmedia-videodev-$(EX) -lpjmedia-audiodev-$(EX) -lpjmedia-$(EX) -lpjnath-$(EX) -lpjlib-util-$(EX) -lsrtp-$(EX) -lresample-$(EX) -lgsmcodec-$(EX) -lspeex-$(EX) -lilbccodec-$(EX) -lg7221codec-$(EX) -lportaudio-$(EX) -lpj-$(EX) -lm -lrt -lpthread -lsqlite3 -lasound
endif
ifeq ($(CROSS_COMPILE),$(LINUX_X86))
	CROSS_TOOL:=gcc
	LIBS_DIR:=../libs/linux-i686
	EX:=i686-pc-linux-gnu
	LIBS:= -L$(LIBS_DIR)/lib $(LIBS_DIR)/lib/libjson-c.a -lpjsua2-$(EX) -lstdc++ -lpjsua-$(EX) -lpjsip-ua-$(EX) -lpjsip-simple-$(EX) -lpjsip-$(EX) -lpjmedia-codec-$(EX) -lpjmedia-$(EX) -lpjmedia-videodev-$(EX) -lpjmedia-audiodev-$(EX) -lpjmedia-$(EX) -lpjnath-$(EX) -lpjlib-util-$(EX) -lsrtp-$(EX) -lresample-$(EX) -lgsmcodec-$(EX) -lspeex-$(EX) -lilbccodec-$(EX) -lg7221codec-$(EX) -lportaudio-$(EX) -lpj-$(EX) -lm -lrt -lpthread -lasound -lpthread -pthread -lm -lsqlite3
endif
ifeq ($(CROSS_COMPILE),$(LINUX_X86_64))
	CROSS_TOOL:=gcc
	LIBS_DIR:=../libs/linux-x86_64
	EX:=x86_64-unknown-linux-gnu
    LIBS:= -L$(LIBS_DIR)/lib -ljson-c -lpjsua2-$(EX) -lstdc++ -lpjsua-$(EX) -lpjsip-ua-$(EX) -lpjsip-simple-$(EX) -lpjsip-$(EX) -lpjmedia-codec-$(EX) -lpjmedia-$(EX) -lpjmedia-videodev-$(EX) -lpjmedia-audiodev-$(EX) -lpjnath-$(EX) -lpjlib-util-$(EX) -lsrtp-$(EX) -lresample-$(EX) -lgsmcodec-$(EX) -lspeex-$(EX) -lilbccodec-$(EX) -lg7221codec-$(EX) -lportaudio-$(EX) -lpj-$(EX) -ldl -lz -lm -lrt -lpthread -lasound -lsqlite3
endif
ifeq ($(CROSS_COMPILE),$(MINGW_X86))
	CROSS_TOOL:=gcc
	LIBS_DIR:=../libs/mingw32-i586
	EX:=i586-pc-mingw32
    LIBS:=-L$(LIBS_DIR)/lib -lpjsua2-$(EX) -lstdc++ -lpjsua-$(EX) -lpjsip-ua-$(EX) -lpjsip-simple-$(EX) -lpjsip-$(EX) -lpjmedia-codec-$(EX) -lpjmedia-$(EX) -lpjmedia-videodev-$(EX) -lpjmedia-audiodev-$(EX) -lpjmedia-$(EX) -lpjnath-$(EX) -lpjlib-util-$(EX)  -lsrtp-$(EX) -lresample-$(EX) -lgsmcodec-$(EX) -lspeex-$(EX) -lilbccodec-$(EX) -lg7221codec-$(EX) -lportaudio-$(EX)  -lpj-$(EX) -lm -lpthread -ljson-c
endif
ifeq ($(CROSS_COMPILE),$(MACOS_X86_64))
	CROSS_TOOL:=gcc
	LIBS_DIR:=../libs/darwin-x86_64
	EX:=x86_64-apple-darwin12.5.0
    LIBS:=-L$(LIBS_DIR)/lib -lpjsua2-$(EX) -lstdc++ -lpjsua-$(EX) -lpjsip-ua-$(EX) -lpjsip-simple-$(EX) -lpjsip-$(EX) -lpjmedia-codec-$(EX) -lpjmedia-$(EX) -lpjmedia-videodev-$(EX) -lpjmedia-audiodev-$(EX) -lpjmedia-$(EX) -lpjnath-$(EX) -lpjlib-util-$(EX)  -lsrtp-$(EX) -lresample-$(EX) -lgsmcodec-$(EX) -lspeex-$(EX) -lilbccodec-$(EX) -lg7221codec-$(EX) -lportaudio-$(EX)  -lpj-$(EX) -lm -lpthread  -framework CoreAudio -framework CoreServices -framework AudioUnit -framework AudioToolbox -framework Foundation -framework AppKit -framework QTKit -framework QuartzCore -framework OpenGL  -L/opt/local/lib -lavformat -lavcodec -lswscale -lavutil  -lcrypto -lssl -lsqlite3 -ljson-c
endif
ifeq ($(CROSS_COMPILE),$(MSYS_X86))
	CROSS_TOOL:=gcc
	LIBS_DIR:=../libs/msys-i686
	EX:=i686-pc-msys
    LIBS:=-L$(LIBS_DIR)/lib -lpjsua2-$(EX) -lstdc++ -lpjsua-$(EX) -lpjsip-ua-$(EX) -lpjsip-simple-$(EX) -lpjsip-$(EX) -lpjmedia-codec-$(EX) -lpjmedia-$(EX) -lpjmedia-videodev-$(EX) -lpjmedia-audiodev-$(EX) -lpjmedia-$(EX) -lpjnath-$(EX) -lpjlib-util-$(EX)  -lsrtp-$(EX) -lresample-$(EX) -lgsmcodec-$(EX) -lspeex-$(EX) -lilbccodec-$(EX) -lg7221codec-$(EX) -lportaudio-$(EX)  -lpj-$(EX) -lm -lpthread -ljson-c
endif
