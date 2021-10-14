
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name Waitinglist_onyu -dir "C:/Users/23529/Desktop/vhdl/Waitinglist_1208/Waitinglist_onyu/planAhead_run_4" -part xc3s200pq208-4
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "waitinglist.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {mode.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {LCD_display.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {data.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {clock.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {waitinglist.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set_property top waitinglist $srcset
add_files [list {waitinglist.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc3s200pq208-4
