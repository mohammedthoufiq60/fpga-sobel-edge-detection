## CLOCK 100MHz
set_property PACKAGE_PIN R2 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin [get_ports clk]

## UART RX
## FTDI TX -> FPGA RX
set_property PACKAGE_PIN V12 [get_ports rx]
set_property IOSTANDARD LVCMOS33 [get_ports rx]

## UART TX
## FPGA TX -> FTDI RX
set_property PACKAGE_PIN R12 [get_ports tx]
set_property IOSTANDARD LVCMOS33 [get_ports tx]
