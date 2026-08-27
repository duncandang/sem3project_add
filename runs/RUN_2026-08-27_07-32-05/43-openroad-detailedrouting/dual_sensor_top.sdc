###############################################################################
# Created by write_sdc
###############################################################################
current_design dual_sensor_top
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk_10mhz -period 100.0000 [get_ports {clk_10mhz}]
set_clock_transition 0.1500 [get_clocks {clk_10mhz}]
set_clock_uncertainty 0.2500 clk_10mhz
set_propagated_clock [get_clocks {clk_10mhz}]
set_input_delay 20.0000 -clock [get_clocks {clk_10mhz}] -add_delay [get_ports {i2c_scl}]
set_input_delay 20.0000 -clock [get_clocks {clk_10mhz}] -add_delay [get_ports {i2c_sda}]
set_input_delay 20.0000 -clock [get_clocks {clk_10mhz}] -add_delay [get_ports {rst_n}]
set_input_delay 20.0000 -clock [get_clocks {clk_10mhz}] -add_delay [get_ports {srf_echo}]
set_output_delay 20.0000 -clock [get_clocks {clk_10mhz}] -add_delay [get_ports {i2c_scl}]
set_output_delay 20.0000 -clock [get_clocks {clk_10mhz}] -add_delay [get_ports {i2c_sda}]
set_output_delay 20.0000 -clock [get_clocks {clk_10mhz}] -add_delay [get_ports {led_status[0]}]
set_output_delay 20.0000 -clock [get_clocks {clk_10mhz}] -add_delay [get_ports {led_status[1]}]
set_output_delay 20.0000 -clock [get_clocks {clk_10mhz}] -add_delay [get_ports {led_status[2]}]
set_output_delay 20.0000 -clock [get_clocks {clk_10mhz}] -add_delay [get_ports {pwr_ctrl}]
set_output_delay 20.0000 -clock [get_clocks {clk_10mhz}] -add_delay [get_ports {srf_trig}]
set_output_delay 20.0000 -clock [get_clocks {clk_10mhz}] -add_delay [get_ports {uart_tx_pin}]
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.0334 [get_ports {i2c_scl}]
set_load -pin_load 0.0334 [get_ports {i2c_sda}]
set_load -pin_load 0.0334 [get_ports {pwr_ctrl}]
set_load -pin_load 0.0334 [get_ports {srf_trig}]
set_load -pin_load 0.0334 [get_ports {uart_tx_pin}]
set_load -pin_load 0.0334 [get_ports {led_status[2]}]
set_load -pin_load 0.0334 [get_ports {led_status[1]}]
set_load -pin_load 0.0334 [get_ports {led_status[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {clk_10mhz}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {i2c_scl}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {i2c_sda}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {rst_n}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {srf_echo}]
###############################################################################
# Design Rules
###############################################################################
set_max_transition 0.7500 [current_design]
set_max_capacitance 0.2000 [current_design]
set_max_fanout 10.0000 [current_design]
