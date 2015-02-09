all: l_reader lol_reader rf
.PHONY: all clean l_reader lol_reader rf

l_reader: l_reader_exe
	./l_reader_exe

l_reader_exe: l_reader.v l_reader_tb.v 
	iverilog -o l_reader_exe -Wall l_reader.v l_reader_tb.v 

lol_reader: lol_reader_exe
	./lol_reader_exe

lol_reader_exe: lol_reader.v lol_reader_tb.v 
	iverilog -o lol_reader_exe -Wall lol_reader.v lol_reader_tb.v 

rf: rf_exe
	./rf_exe

rf_exe: rf.v rf_tb.v mux_lib.v
	iverilog -o rf_exe -Wall rf.v rf_tb.v mux_lib.v

clean:
	rm -f *_exe *.vcd
