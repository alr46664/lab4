# compile os modulos para o modelsim

vlog ../verilog_source/pipeline.v ../verilog_source/pipeline_testbench.v

# abra ambiente de simulacao

vsim -gui work.pipeline_testbench

# limpe o ambiente

delete wave *

# configure o ambiente de simulacao

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /pipeline_testbench/clk
add wave -noupdate -radix binary /pipeline_testbench/RST
add wave -noupdate -divider {PIPE 1}
add wave -noupdate -radix binary /pipeline_testbench/pipe/clk_p1
add wave -noupdate -radix binary /pipeline_testbench/pipe/pc_chg_p1
add wave -noupdate -radix unsigned /pipeline_testbench/pipe/pc_in_p1
add wave -noupdate -radix unsigned /pipeline_testbench/pipe/pc_out_p1
add wave -noupdate -radix binary /pipeline_testbench/pipe/instr
add wave -noupdate -radix binary /pipeline_testbench/pipe/done_p1
add wave -noupdate -divider {PIPE 2}
add wave -noupdate -radix binary /pipeline_testbench/pipe/clk_p2
add wave -noupdate -radix binary /pipeline_testbench/pipe/reg_en_p2
add wave -noupdate -radix unsigned /pipeline_testbench/pipe/reg_addr_p2
add wave -noupdate -radix decimal /pipeline_testbench/pipe/reg_data_p2
add wave -noupdate -radix unsigned /pipeline_testbench/pipe/A_addr
add wave -noupdate -radix decimal /pipeline_testbench/pipe/A
add wave -noupdate -radix unsigned /pipeline_testbench/pipe/B_addr
add wave -noupdate -radix decimal /pipeline_testbench/pipe/B
add wave -noupdate -radix decimal /pipeline_testbench/pipe/imm
add wave -noupdate -radix unsigned /pipeline_testbench/pipe/pc_out_p2
add wave -noupdate -radix binary /pipeline_testbench/pipe/ctrl_p2
add wave -noupdate -radix binary /pipeline_testbench/pipe/done_p2
add wave -noupdate -divider {PIPE 3}
add wave -noupdate -radix binary /pipeline_testbench/pipe/clk_p3
add wave -noupdate -radix decimal /pipeline_testbench/pipe/data_p3
add wave -noupdate -radix unsigned /pipeline_testbench/pipe/addr_p3
add wave -noupdate -radix unsigned /pipeline_testbench/pipe/reg_addr_p3
add wave -noupdate -radix binary /pipeline_testbench/pipe/ctrl_out_p3
add wave -noupdate -radix binary /pipeline_testbench/pipe/done_p3
add wave -noupdate -divider {PIPE 4}
add wave -noupdate -radix binary /pipeline_testbench/pipe/clk_p4
add wave -noupdate -radix decimal /pipeline_testbench/pipe/reg_data_out_p4
add wave -noupdate -radix unsigned /pipeline_testbench/pipe/reg_addr_out_p4
add wave -noupdate -radix binary /pipeline_testbench/pipe/ctrl_out_p4
add wave -noupdate -radix binary /pipeline_testbench/pipe/done_p4
add wave -noupdate -divider {PIPE 5}
add wave -noupdate -radix binary /pipeline_testbench/pipe/clk_p5
add wave -noupdate -radix binary /pipeline_testbench/pipe/done_p5
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 258
configure wave -valuecolwidth 205
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
WaveRestoreZoom {0 ps} {188 ps}



# inicie simulacao

restart -f
run
run
