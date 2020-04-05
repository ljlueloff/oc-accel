
set action_root $::env(ACTION_ROOT)
set fpga_part $::env(FPGACHIP)
set software_root $::env(OCACCEL_ROOT)/software


set top_name matmul
set hls_proj ${top_name}_${fpga_part}
set cflags " -I$action_root/include -I$software_root/include"

open_project $hls_proj

# top_name should match the name of the entry function
set_top $top_name

# Can that be a list?
foreach file [ list $action_root/hw/hls/$top_name.cpp ] {
  add_files ${file} -cflags ${cflags}
}

open_solution $top_name
set_part $fpga_part

create_clock -period 4 -name default
config_interface -m_axi_addr64=true
#config_rtl -reset all -reset_level low
config_export -format ip_catalog -rtl verilog -version 1.0 -vendor opencapi.org -library ocaccel
csynth_design
export_design -format ip_catalog -rtl verilog -vendor "opencapi.org" -library "ocaccel" -version "1.0"
exit