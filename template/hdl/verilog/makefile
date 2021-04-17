compile: test-bench.v
	iverilog -o counter.vvp test-bench.v

run:
	vvp ./counter.vvp

vcd:
	vvp -n ./counter.vvp -lxt2

wave:
	# open -a Scansion counter.vcd
	open -a gtkview counter.vcd --args "-S signal-wave.tcl"
