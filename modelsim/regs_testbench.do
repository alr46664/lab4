# compile os modulos para o modelsim

vlog ../verilog_source/regs.v ../verilog_source/regs_testbench.v

# abra ambiente de simulacao

vsim -gui work.regs_testbench

# limpe o ambiente

delete wave *

# configure o ambiente de simulacao

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider testbench
add wave -noupdate -radix unsigned /regs_testbench/testes
add wave -noupdate -radix binary /regs_testbench/clk
add wave -noupdate -divider write
add wave -noupdate -radix binary /regs_testbench/en_write
add wave -noupdate -radix unsigned /regs_testbench/addr_write
add wave -noupdate -radix decimal /regs_testbench/data_write
add wave -noupdate -divider read_1
add wave -noupdate -radix unsigned /regs_testbench/addr_read1
add wave -noupdate -radix decimal /regs_testbench/data_read1
add wave -noupdate -divider read_2
add wave -noupdate -radix unsigned /regs_testbench/addr_read2
add wave -noupdate -radix decimal /regs_testbench/data_read2
add wave -noupdate -divider -height 30 {tested module}
add wave -noupdate -radix binary /regs_testbench/regs0/clk
add wave -noupdate -radix decimal /regs_testbench/regs0/ram
add wave -noupdate -divider write
add wave -noupdate -radix binary /regs_testbench/regs0/en_write
add wave -noupdate -radix unsigned /regs_testbench/regs0/addr_write
add wave -noupdate -radix decimal /regs_testbench/regs0/data_write
add wave -noupdate -divider read_1
add wave -noupdate -radix unsigned /regs_testbench/regs0/addr_read1
add wave -noupdate -radix decimal /regs_testbench/regs0/data_read1
add wave -noupdate -divider read_2
add wave -noupdate -radix unsigned /regs_testbench/regs0/addr_read2
add wave -noupdate -radix decimal /regs_testbench/regs0/data_read2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {18 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 292
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
WaveRestoreZoom {0 ps} {56 ps}

# inicie simulacao

restart -f
run