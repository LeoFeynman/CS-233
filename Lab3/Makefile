CXX = clang++
CPPFLAGS = -Wall -g

mux4_deps = mux.v mux4_tb.v
logicunit_deps = mux.v logicunit.v logicunit_tb.v
alu1_deps = mux.v logicunit.v alu.v alu1_tb.v
alu32_deps = mux.v logicunit.v alu.v alu32_tb.v
zero_checker_deps = zero_checker.v zero_checker_tb.v

BENCHES = mux4 logicunit alu1 alu32 zero_checker
all: $(BENCHES) example_generator
.PHONY: all $(BENCHES) clean
.SECONDEXPANSION:

$(BENCHES): %: %_exe
	./$<

%_exe: $$(%_deps)
	iverilog -o $@ -Wall $^

clean:
	rm -rf example_generator *_exe *.exe *.vcd *.dSYM
