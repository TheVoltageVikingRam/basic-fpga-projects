transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Ram/Documents/GitHub/basic-fpga-projects/seven-segment-on\ quartus/Seven_Segment_Display {C:/Users/Ram/Documents/GitHub/basic-fpga-projects/seven-segment-on quartus/Seven_Segment_Display/Seven_Segment_Display.v}

vlog -vlog01compat -work work +incdir+C:/Users/Ram/Documents/GitHub/basic-fpga-projects/seven-segment-on\ quartus/Seven_Segment_Display {C:/Users/Ram/Documents/GitHub/basic-fpga-projects/seven-segment-on quartus/Seven_Segment_Display/tb_seven_segment.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb_seven_segment

add wave *
view structure
view signals
run -all
