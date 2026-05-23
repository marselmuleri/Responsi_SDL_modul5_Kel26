## ============================================================
## Constraint File: Nexys A7-100T
## Project        : Door Lock Security FSM Mealy
## ============================================================

## Clock (100 MHz)
set_property -dict { PACKAGE_PIN E3   IOSTANDARD LVCMOS33 } [get_ports { clk }];
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { clk }];

## Switches
## SW[0]  ? reset
set_property -dict { PACKAGE_PIN J15  IOSTANDARD LVCMOS33 } [get_ports { reset }];
## SW[15] ? w (tombol input keypad)
set_property -dict { PACKAGE_PIN V10  IOSTANDARD LVCMOS33 } [get_ports { w }];

## 7-Segment Segments (active-low)
set_property -dict { PACKAGE_PIN T10  IOSTANDARD LVCMOS33 } [get_ports { seg[6] }]; ## ca
set_property -dict { PACKAGE_PIN R10  IOSTANDARD LVCMOS33 } [get_ports { seg[5] }]; ## cb
set_property -dict { PACKAGE_PIN K16  IOSTANDARD LVCMOS33 } [get_ports { seg[4] }]; ## cc
set_property -dict { PACKAGE_PIN K13  IOSTANDARD LVCMOS33 } [get_ports { seg[3] }]; ## cd
set_property -dict { PACKAGE_PIN P15  IOSTANDARD LVCMOS33 } [get_ports { seg[2] }]; ## ce
set_property -dict { PACKAGE_PIN T11  IOSTANDARD LVCMOS33 } [get_ports { seg[1] }]; ## cf
set_property -dict { PACKAGE_PIN L18  IOSTANDARD LVCMOS33 } [get_ports { seg[0] }]; ## cg

## 7-Segment Anodes (active-low)
set_property -dict { PACKAGE_PIN J17  IOSTANDARD LVCMOS33 } [get_ports { anode[0] }];
set_property -dict { PACKAGE_PIN J18  IOSTANDARD LVCMOS33 } [get_ports { anode[1] }];
set_property -dict { PACKAGE_PIN T9   IOSTANDARD LVCMOS33 } [get_ports { anode[2] }];
set_property -dict { PACKAGE_PIN J14  IOSTANDARD LVCMOS33 } [get_ports { anode[3] }];
set_property -dict { PACKAGE_PIN P14  IOSTANDARD LVCMOS33 } [get_ports { anode[4] }];
set_property -dict { PACKAGE_PIN T14  IOSTANDARD LVCMOS33 } [get_ports { anode[5] }];
set_property -dict { PACKAGE_PIN K2   IOSTANDARD LVCMOS33 } [get_ports { anode[6] }];
set_property -dict { PACKAGE_PIN U13  IOSTANDARD LVCMOS33 } [get_ports { anode[7] }];