
# compile os modulos para o modelsim

vlog ../verilog_source/mem_program.v ../verilog_source/mem_program_testbench.v


# abra ambiente de simulacao

vsim -gui work.mem_program_testbench


# limpe o ambiente

delete wave *


# configure o ambiente de simulacao

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /mem_program_testbench/clk
add wave -noupdate -radix binary /mem_program_testbench/we
add wave -noupdate -radix unsigned /mem_program_testbench/addr
add wave -noupdate -radix hexadecimal /mem_program_testbench/data_in
add wave -noupdate -radix hexadecimal /mem_program_testbench/data_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 242
configure wave -valuecolwidth 198
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {122 ps}


# inicie simulacao

restart -f
run
run