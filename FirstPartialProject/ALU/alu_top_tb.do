vlib work
vlog ../../16x16_multiplier/mult16x16/mult16x16.v
vlog ../../16x16_multiplier/adder/adder.v
vlog ../../16x16_multiplier/mult4x4/mult4x4.v
vlog ../../16x16_multiplier/mux4/mux4.v
vlog ../../16x16_multiplier/shifter/shifter.v
vlog ../../16x16_multiplier/seven_segment_cntrl/seven_segment_cntrl.v
vlog ../../16x16_multiplier/reg16/reg16.v
vlog ../../16x16_multiplier/counter/counter.v
vlog ../../16x16_multiplier/mult_control/mult_control.v
vlog ../alu/alu.v
vlog ../alu_control/alu_control.v
vlog alu_top.v alu_top_tb.v
vsim -t ns work.alu_top_tb
view wave
add wave -radix binary /clk
add wave -radix binary /start
add wave -radix binary /reset_a
add wave -radix binary /carry_flag
add wave -radix binary /zero_flag
add wave -radix binary /done_flag
add wave -radix binary /opcode
add wave -radix unsigned /dataa
add wave -radix unsigned /datab
add wave -radix unsigned /out
run 500 ns
