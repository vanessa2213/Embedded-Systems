vlib work
vlog mult4x4.v mult4x4_tb.v
vsim -t ns work.mult4x4_tb
view wave
add wave -radix hex /dataa
add wave -radix hex /datab
add wave -radix hex /product
run 80 ns