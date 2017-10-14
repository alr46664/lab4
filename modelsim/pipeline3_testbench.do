# compile os modulos para o modelsim

vlog ../verilog_source/pipeline3.v ../verilog_source/pipeline3_testbench.v

# abra ambiente de simulacao

vsim -gui work.pipeline3_testbench

# limpe o ambiente

delete wave *

# configure o ambiente de simulacao

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /pipeline3_testbench/testes
add wave -noupdate -radix binary /pipeline3_testbench/clk_in
add wave -noupdate -radix binary /pipeline3_testbench/RST
add wave -noupdate -radix binary /pipeline3_testbench/done
add wave -noupdate -divider CTRL
add wave -noupdate -radix binary /pipeline3_testbench/ctrl_in
add wave -noupdate -radix binary /pipeline3_testbench/ctrl_out
add wave -noupdate -divider A
add wave -noupdate -radix unsigned /pipeline3_testbench/A_addr
add wave -noupdate -radix decimal /pipeline3_testbench/A
add wave -noupdate -divider B
add wave -noupdate -radix unsigned /pipeline3_testbench/B_addr
add wave -noupdate -radix decimal /pipeline3_testbench/B
add wave -noupdate -divider IMM
add wave -noupdate /pipeline3_testbench/imm
add wave -noupdate -divider PC
add wave -noupdate -radix binary /pipeline3_testbench/pc_chg
add wave -noupdate -radix unsigned /pipeline3_testbench/pc_in
add wave -noupdate -radix unsigned /pipeline3_testbench/pc_out
add wave -noupdate -divider {MEM OUTPUT}
add wave -noupdate -radix decimal /pipeline3_testbench/data
add wave -noupdate -radix unsigned /pipeline3_testbench/addr
add wave -noupdate -radix unsigned /pipeline3_testbench/reg_addr
add wave -noupdate -divider -height 25 AUXILIARY
add wave -noupdate -radix decimal /pipeline3_testbench/pipeline30/B_imm
add wave -noupdate -radix binary /pipeline3_testbench/pipeline30/rflags_last
add wave -noupdate -divider ULA
add wave -noupdate -radix binary /pipeline3_testbench/pipeline30/ula_to_data
add wave -noupdate -radix binary /pipeline3_testbench/pipeline30/ula_opcode
add wave -noupdate -radix decimal /pipeline3_testbench/pipeline30/ula_data1
add wave -noupdate -radix decimal /pipeline3_testbench/pipeline30/ula_data2
add wave -noupdate -radix decimal /pipeline3_testbench/pipeline30/ula_out
add wave -noupdate -radix binary /pipeline3_testbench/pipeline30/rflags
add wave -noupdate -divider DEFAULT
add wave -noupdate -radix decimal /pipeline3_testbench/pipeline30/data_default
add wave -noupdate -radix unsigned /pipeline3_testbench/pipeline30/addr_default
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 279
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
WaveRestoreZoom {0 ps} {100 ps}





# inicie simulacao

restart -f
run
run