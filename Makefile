.PHONY:build clean test clean-test

PROTOCOL_DIR:=../group-man/protocols
GM_P:=gm-proto.u
GMC_P:=gmc-proto.u
ADV_P:=adv-proto.u
GB_P:=gb-proto.u

CPP_SRC:= ./src/ctocpp.cpp \
		  ./src/main.cpp \
		  ./src/OIUC.cpp \
		  ./src/Config.cpp \
		  ./src/backend.cpp \
		  ./src/Log.cpp \
		  ./src/Radio.cpp \
		  ./src/RadioList.cpp \
		  ./src/OIU.cpp \
		  ./src/OIUList.cpp \

GEN_SRC:= gen/gm-client.c \
		  gen/gmc-server.c \
		  gen/adv-server.c \
		  gen/gb-server.c \

NODE_SRC:= ../group-man/src/node.c

EP_SRC:=../media-endpoint/src/endpoint.c

GB_SRC:= ../group-man/src/gb-receiver.c

HT_SRC:=../hash-table/src/hash-table.c

PTTC_SRC:= ../serial/src/pttc_uart.c \
		   ../serial/src/serial_utils.c

CORE_SRC:= ../concurrent_queue/src/queue.c \
		   ../ics/src/ics-command.c \
		   ../ics/src/ics.c \
		   ../ics/src/ics-event.c \
		   ../object-pool/src/object-pool.c \
		   ../common/src/ansi-utils.c \
		   ../common/src/my-pjmedia-utils.c \
		   ../common/src/my-pjlib-utils.c \

include custom.mk

QMLS:=$(shell ls -1 $(QML_DIR))

MY_CFLAGS+=-g $(shell pkg-config --cflags libpjproject json-c) -I$(PROTOCOLS_DIR)/include -D__ICS_INTEL__
MY_LIBS:=-g $(shell pkg-config --libs libpjproject json-c)

APP:=oiuc.app

USERVER_DIR:=../userver


all: gen-gm gen-gmc gen-adv gen-gb build

#gen-qml:
#   ./build_qml.sh $(QT_QUICK_VER) $(QML_GEN_DIR)

$(QML_GEN_DIR):
	mkdir -p $(QML_GEN_DIR)

$(QML_GEN_DIR)/%.qml: $(QML_DIR)/%.qml
	sed -e 's/@QtQuick/$(QtQuick)/g' -e 's/@QtWindow/$(QtWindow)/g' -e 's/@Window/$(Window)/g' < $< > $@

qml.qrc: qml.qrc.template
	sed 's/@QML_GEN_DIR/'$(QML_GEN_DIR)'/g' < $< > $@

gen-gm: $(PROTOCOL_DIR)/$(GM_P)
	mkdir -p gen
	awk -v base_dir=$(USERVER_DIR) -f $(USERVER_DIR)/gen-tools/gen.awk $<
	touch $@

gen-gmc: $(PROTOCOL_DIR)/$(GMC_P)
	mkdir -p gen
	awk -v base_dir=$(USERVER_DIR) -f $(USERVER_DIR)/gen-tools/gen.awk $<
	touch $@

gen-adv: $(PROTOCOL_DIR)/$(ADV_P)
	mkdir -p gen
	awk -v base_dir=$(USERVER_DIR) -f $(USERVER_DIR)/gen-tools/gen.awk $<
	touch $@

gen-gb: $(PROTOCOL_DIR)/$(GB_P)
	mkdir -p gen
	awk -v base_dir=$(USERVER_DIR) -f $(USERVER_DIR)/gen-tools/gen.awk $<
	touch $@
oiuc.pro: $(QML_GEN_DIR) $(addprefix $(QML_GEN_DIR)/, $(QMLS)) qml.qrc
	echo "## Project file gen by Make" > oiuc.pro
	echo "TEMPLATE = app" >> oiuc.pro
	echo "TARGET = $(APP)" >> oiuc.pro
	echo "OBJECTS_DIR = temp" >> oiuc.pro
	echo "MOC_DIR = temp" >> oiuc.pro
	echo "RESOURCES += qml.qrc" >> oiuc.pro
	echo "DEFINES += APP_VERSION=\\\\\\\"\\\"$(VERSION)\\\\\\\"\\\" QML_GEN_DIR=\\\\\\\"\\\"$(QML_GEN_DIR)\\\\\\\"\\\"" >> oiuc.pro
	echo "" >> oiuc.pro
	echo "DEPENDPATH += . \\" >> oiuc.pro
	echo "			include \\" >> oiuc.pro
	echo "			src \\" >> oiuc.pro
	echo "			gen \\" >> oiuc.pro
	echo "			../concurrent_queue/include \\" >> oiuc.pro
	echo "			../concurrent_queue/src \\" >> oiuc.pro
	echo "			../concurrent_queue/test \\" >> oiuc.pro
	echo "			../ics/include \\" >> oiuc.pro
	echo "			../ics/src \\" >> oiuc.pro
	echo "			../ics/test \\" >> oiuc.pro
	echo "			../object-pool/include \\" >> oiuc.pro
	echo "			../object-pool/src \\" >> oiuc.pro
	echo "			../common/include \\" >> oiuc.pro
	echo "			../common/src \\" >> oiuc.pro
	echo "			../group-man/src \\" >> oiuc.pro
	echo "			../group-man/include \\" >> oiuc.pro
	echo "			../media-endpoint/src \\" >> oiuc.pro
	echo "			../media-endpoint/include \\" >> oiuc.pro
	echo "			../hash-table/src \\" >> oiuc.pro
	echo "			../hash-table/include \\" >> oiuc.pro
	echo "			../serial/src \\" >> oiuc.pro
	echo "			../serial/include" >> oiuc.pro
	echo "" >> oiuc.pro
	echo "INCLUDEPATH += . \\" >> oiuc.pro
	echo "			 include \\" >> oiuc.pro
	echo "			 gen \\" >> oiuc.pro
	echo "			 ../ics/include \\" >> oiuc.pro
	echo "			 ../concurrent_queue/include \\" >> oiuc.pro
	echo "			 ../object-pool/include \\" >> oiuc.pro
	echo "			 ../common/include \\" >> oiuc.pro
	echo "			../group-man/include \\" >> oiuc.pro
	echo "			../media-endpoint/include \\" >> oiuc.pro
	echo "			../hash-table/include \\" >> oiuc.pro
	echo "			../serial/include " >> oiuc.pro
	echo "" >> oiuc.pro
	echo "equals(QT_MAJOR_VERSION, 5) {QT += qml quick xml svg multimedia sql}" >> oiuc.pro
	echo "equals(QT_MAJOR_VERSION, 4) {QT += declarative svg xml multimedia sql core gui}" >> oiuc.pro
	echo "QMAKE_CFLAGS += $(MY_CFLAGS)" >> oiuc.pro
	echo "QMAKE_CXXFLAGS += $(MY_CFLAGS)" >> oiuc.pro
	echo "QMAKE_LIBS += $(MY_LIBS)" >> oiuc.pro
	echo "" >> oiuc.pro
	echo "HEADERS += $(subst /src/,/include/,$(CPP_SRC:.cpp=.h)) $(subst /src/,/include/,$(NODE_SRC:.c=.h)) $(subst /src/,/include/,$(GB_SRC:.c=.h)) $(GEN_SRC:.c=.h) $(subst /src/,/include/,$(CORE_SRC:.c=.h)) $(subst /src/,/include/,$(EP_SRC:.c=.h)) $(subst /src/,/include/,$(EP_SRC:.c=.h)) $(subst /src/,/include/,$(PTTC_SRC:.c=.h))">> oiuc.pro
	echo "" >> oiuc.pro
	echo "SOURCES += $(CPP_SRC) $(GEN_SRC) $(CORE_SRC) $(NODE_SRC) $(GB_SRC) $(EP_SRC) $(HT_SRC) $(PTTC_SRC)" >> oiuc.pro

Makefile.qt.mk: oiuc.pro
	qmake -makefile $(QMAKE_OPT) $< -o $@

build: Makefile.qt.mk
	make -f Makefile.qt.mk 

clean:
	rm -fr temp gen $(APP) gen-gm gen-gmc gen-adv gen-gb /tmp/oiuc.log $(QML_GEN_DIR) qml.qrc
	make clean -f Makefile.qt.mk
	rm -fr Makefile.qt.mk oiuc.pro 

test:
	make -f Makefile.quy

clean-test:
	make -f Makefile.quy clean
