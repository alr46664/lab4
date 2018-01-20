# compile os modulos para o modelsim

vlog ../verilog_source/pipeline2.v ../verilog_source/pipeline2_testbench.v

# abra ambiente de simulacao

vsim -gui work.pipeline2_testbench

# limpe o ambiente

delete wave *

# configure o ambiente de simulacao

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /pipeline2_testbench/testes
add wave -noupdate -radix binary /pipeline2_testbench/clk_in
add wave -noupdate -radix binary /pipeline2_testbench/RST
add wave -noupdate -divider PC
add wave -noupdate -radix unsigned /pipeline2_testbench/pc_in
add wave -noupdate -radix unsigned /pipeline2_testbench/pc_out
add wave -noupdate -divider Instruction
add wave -noupdate -radix binary /pipeline2_testbench/instr
add wave -noupdate -radix binary /pipeline2_testbench/pipeline20/opcode
add wave -noupdate -radix unsigned -childformat {{{/pipeline2_testbench/A_addr[4]} -radix unsigned} {{/pipeline2_testbench/A_addr[3]} -radix unsigned} {{/pipeline2_testbench/A_addr[2]} -radix unsigned} {{/pipeline2_testbench/A_addr[1]} -radix unsigned} {{/pipeline2_testbench/A_addr[0]} -radix unsigned}} -subitemconfig {{/pipeline2_testbench/A_addr[4]} {-height 15 -radix unsigned} {/pipeline2_testbench/A_addr[3]} {-height 15 -radix unsigned} {/pipeline2_testbench/A_addr[2]} {-height 15 -radix unsigned} {/pipeline2_testbench/A_addr[1]} {-height 15 -radix unsigned} {/pipeline2_testbench/A_addr[0]} {-height 15 -radix unsigned}} /pipeline2_testbench/A_addr
add wave -noupdate -radix unsigned -childformat {{{/pipeline2_testbench/B_addr[4]} -radix unsigned} {{/pipeline2_testbench/B_addr[3]} -radix unsigned} {{/pipeline2_testbench/B_addr[2]} -radix unsigned} {{/pipeline2_testbench/B_addr[1]} -radix unsigned} {{/pipeline2_testbench/B_addr[0]} -radix unsigned}} -subitemconfig {{/pipeline2_testbench/B_addr[4]} {-height 15 -radix unsigned} {/pipeline2_testbench/B_addr[3]} {-height 15 -radix unsigned} {/pipeline2_testbench/B_addr[2]} {-height 15 -radix unsigned} {/pipeline2_testbench/B_addr[1]} {-height 15 -radix unsigned} {/pipeline2_testbench/B_addr[0]} {-height 15 -radix unsigned}} /pipeline2_testbench/B_addr
add wave -noupdate -radix decimal -childformat {{{/pipeline2_testbench/imm[15]} -radix decimal} {{/pipeline2_testbench/imm[14]} -radix decimal} {{/pipeline2_testbench/imm[13]} -radix decimal} {{/pipeline2_testbench/imm[12]} -radix decimal} {{/pipeline2_testbench/imm[11]} -radix decimal} {{/pipeline2_testbench/imm[10]} -radix decimal} {{/pipeline2_testbench/imm[9]} -radix decimal} {{/pipeline2_testbench/imm[8]} -radix decimal} {{/pipeline2_testbench/imm[7]} -radix decimal} {{/pipeline2_testbench/imm[6]} -radix decimal} {{/pipeline2_testbench/imm[5]} -radix decimal} {{/pipeline2_testbench/imm[4]} -radix decimal} {{/pipeline2_testbench/imm[3]} -radix decimal} {{/pipeline2_testbench/imm[2]} -radix decimal} {{/pipeline2_testbench/imm[1]} -radix decimal} {{/pipeline2_testbench/imm[0]} -radix decimal}} -subitemconfig {{/pipeline2_testbench/imm[15]} {-radix decimal} {/pipeline2_testbench/imm[14]} {-radix decimal} {/pipeline2_testbench/imm[13]} {-radix decimal} {/pipeline2_testbench/imm[12]} {-radix decimal} {/pipeline2_testbench/imm[11]} {-radix decimal} {/pipeline2_testbench/imm[10]} {-radix decimal} {/pipeline2_testbench/imm[9]} {-radix decimal} {/pipeline2_testbench/imm[8]} {-radix decimal} {/pipeline2_testbench/imm[7]} {-radix decimal} {/pipeline2_testbench/imm[6]} {-radix decimal} {/pipeline2_testbench/imm[5]} {-radix decimal} {/pipeline2_testbench/imm[4]} {-radix decimal} {/pipeline2_testbench/imm[3]} {-radix decimal} {/pipeline2_testbench/imm[2]} {-radix decimal} {/pipeline2_testbench/imm[1]} {-radix decimal} {/pipeline2_testbench/imm[0]} {-radix decimal}} /pipeline2_testbench/imm
add wave -noupdate -radix decimal /pipeline2_testbench/A
add wave -noupdate -radix decimal /pipeline2_testbench/B
add wave -noupdate -divider {Store Register}
add wave -noupdate -radix binary /pipeline2_testbench/reg_en
add wave -noupdate -radix unsigned /pipeline2_testbench/reg_addr
add wave -noupdate -radix decimal /pipeline2_testbench/reg_data
add wave -noupdate -divider Registers
add wave -noupdate -radix decimal -childformat {{{/pipeline2_testbench/pipeline20/regs0/ram[0]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[1]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[2]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[3]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[4]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[5]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[6]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[7]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[8]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[9]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[10]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[11]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[12]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[13]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[14]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[15]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[16]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[17]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[18]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[19]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[20]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[21]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[22]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[23]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[24]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[25]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[26]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[27]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[28]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[29]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[30]} -radix decimal} {{/pipeline2_testbench/pipeline20/regs0/ram[31]} -radix decimal}} -subitemconfig {{/pipeline2_testbench/pipeline20/regs0/ram[0]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[1]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[2]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[3]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[4]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[5]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[6]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[7]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[8]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[9]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[10]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[11]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[12]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[13]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[14]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[15]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[16]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[17]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[18]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[19]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[20]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[21]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[22]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[23]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[24]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[25]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[26]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[27]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[28]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[29]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[30]} {-radix decimal} {/pipeline2_testbench/pipeline20/regs0/ram[31]} {-radix decimal}} /pipeline2_testbench/pipeline20/regs0/ram
add wave -noupdate -divider Control
add wave -noupdate -radix binary /pipeline2_testbench/ctrl
add wave -noupdate -radix binary /pipeline2_testbench/done
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {28 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 243
configure wave -valuecolwidth 204
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
WaveRestoreZoom {87 ps} {206 ps}



# inicie simulacao

restart -f
run
run