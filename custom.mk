#### for arm (embedded cpu board)
#QMAKE_OPT:=-spec qws/linux-arm-g++ 
#MY_CFLAGS:=-D__ICS_ARM__

#### for PC (x86, x86_64)
QMAKE_OPT:= 
MY_CFLAGS:=-D__ICS_INTEL__
VERSION:=1.0.1
