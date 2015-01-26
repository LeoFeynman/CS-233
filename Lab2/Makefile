CXX = clang++
LD = clang++
CPPFLAGS = -g -Wall -Werror

SVN_ROOT := $(shell svn info | sed -n 's/Repository Root: //p')
PICTURE := $(SVN_ROOT)/_shared/Lab2/picture.bmp

.PHONY: all steering clean

EXES = steering_exe example extractMessage countOnes
all: $(EXES)

steering: steering_exe
	./$<

steering_exe: steering.v steering_tb.v
	iverilog -o $@ -Wall $^

example: example.o bmp.o picture.bmp
	$(LD) -o $@ $(filter %.o,$^)

extractMessage: extractMessage_main.o extractMessage.o bmp.o picture.bmp
	$(LD) -o $@ $(filter %.o,$^)

countOnes: countOnes_main.o countOnes.o
	$(LD) -o $@ $^

example.o: example.cpp bmp.h

bmp.o: bmp.cpp bmp.h

extractMessage_main.o: extractMessage_main.cpp bmp.h extractMessage.h

extractMessage.o: extractMessage.cpp extractMessage.h bmp.h

countOnes_main.o: countOnes_main.cpp countOnes.h

countOnes.o: countOnes.cpp countOnes.h

picture.bmp:
	@echo Downloading picture.bmp from SVN. If prompted for password, enter AD password.
	svn export $(PICTURE)

clean:
	rm -f $(EXES) *.o *.exe *.vcd
