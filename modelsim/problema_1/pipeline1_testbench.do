# compile os modulos para o modelsim

vlog ../verilog_source/pipeline1.v ../verilog_source/pipeline1_testbench.v

# abra ambiente de simulacao

vsim -gui work.pipeline1_testbench

# limpe o ambiente

delete wave *

# configure o ambiente de simulacao


onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /pipeline1_testbench/testes
add wave -noupdate -radix binary /pipeline1_testbench/clk_in
add wave -noupdate -radix binary /pipeline1_testbench/RST
add wave -noupdate -divider INPUT
add wave -noupdate -radix binary /pipeline1_testbench/pc_chg
add wave -noupdate -radix unsigned /pipeline1_testbench/pc_in
add wave -noupdate -divider OUTPUT
add wave -noupdate -radix unsigned /pipeline1_testbench/pc_out
add wave -noupdate -radix binary /pipeline1_testbench/instr
add wave -noupdate -radix binary /pipeline1_testbench/done
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 203
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {220 ps}



# inicie simulacao

restart -f
run
run
