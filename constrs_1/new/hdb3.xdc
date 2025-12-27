# 时钟周期约束: 50MHz (周期 20ns)
create_clock -period 20.000 -name sys_clk -waveform {0.000 10.000} [get_ports sys_clk]

# 暂时不配置 IO 引脚和电平标准
# 如果后续需要生成比特流并上板，请取消注释并根据实际开发板修改以下内容：

# set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]
# set_property PACKAGE_PIN <PIN_NUM> [get_ports sys_clk]

# set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
# set_property PACKAGE_PIN <PIN_NUM> [get_ports rst_n]

# set_property IOSTANDARD LVCMOS33 [get_ports data_orig]
# set_property PACKAGE_PIN <PIN_NUM> [get_ports data_orig]

# set_property IOSTANDARD LVCMOS33 [get_ports hdb3_p]
# set_property PACKAGE_PIN <PIN_NUM> [get_ports hdb3_p]

# set_property IOSTANDARD LVCMOS33 [get_ports hdb3_n]
# set_property PACKAGE_PIN <PIN_NUM> [get_ports hdb3_n]

# set_property IOSTANDARD LVCMOS33 [get_ports data_decoded]
# set_property PACKAGE_PIN <PIN_NUM> [get_ports data_decoded]
