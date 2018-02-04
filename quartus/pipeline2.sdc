## Generated SDC file "top.out.sdc"

## Copyright (C) 2017  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 17.1.0 Build 590 10/25/2017 SJ Lite Edition"

## DATE    "Sat Feb 03 16:04:29 2018"

##
## DEVICE  "EP4CE115F29I7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk} -period 20.000 -waveform { 0.000 10.000 } [get_ports {clk_in}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************

set_clock_latency -source 2 [get_clocks {clk}]

#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  1.000  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  1.000  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  1.000  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  1.000  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {clk}]  4.000 [get_ports {RST*}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  4.000 [get_ports {pc_in*}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  4.000 [get_ports {reg_addr*}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  4.000 [get_ports {reg_data*}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  4.000 [get_ports {instr*}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  4.000 [get_ports {reg_en*}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay -clock { clk } 4.000 [get_ports imm*]
set_output_delay -add_delay -clock { clk } 4.000 [get_ports pc_out*]
set_output_delay -add_delay -clock { clk } 4.000 [get_ports A_addr*]
set_output_delay -add_delay -clock { clk } 4.000 [get_ports B_addr*]
set_output_delay -add_delay -clock { clk } 4.000 [get_ports A*]
set_output_delay -add_delay -clock { clk } 4.000 [get_ports B*]
set_output_delay -add_delay -clock { clk } 4.000 [get_ports ctrl*]

#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

