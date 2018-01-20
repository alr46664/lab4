# compile os modulos para o modelsim

vlog ../verilog_source/ula.v ../verilog_source/ula_testbench.v

# abra ambiente de simulacao

vsim -gui work.ula_testbench

# limpe o ambiente

delete wave *

# configure o ambiente de simulacao

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /ula_testbench/testes
add wave -noupdate -divider INPUT
add wave -noupdate -radix binary /ula_testbench/opcode
add wave -noupdate -radix decimal /ula_testbench/data1
add wave -noupdate -radix decimal /ula_testbench/data2
add wave -noupdate -divider OUTPUT
add wave -noupdate -radix decimal /ula_testbench/out
add wave -noupdate -radix binary /ula_testbench/rflags
add wave -noupdate -divider AUXILIARY
add wave -noupdate -radix binary /ula_testbench/ula0/xor_data12_sign
add wave -noupdate -radix decimal /ula_testbench/ula0/data2_aux
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 231
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
WaveRestoreZoom {0 ps} {118 ps}

# inicie simulacao

restart -f
run
run