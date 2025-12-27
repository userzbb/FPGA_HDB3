`timescale 1ns / 1ps

module tb_hdb3();

    reg sys_clk;
    reg rst_n;

    wire data_orig;
    wire hdb3_p;
    wire hdb3_n;
    wire data_decoded;

    // 实例化顶层模块（连接时钟、复位和信号）
    hdb3_top u_hdb3_top (
                 .sys_clk(sys_clk),
                 .rst_n(rst_n),
                 .data_orig(data_orig),
                 .hdb3_p(hdb3_p),
                 .hdb3_n(hdb3_n),
                 .data_decoded(data_decoded)
             );

    // 产生 50MHz 时钟（每 10ns 翻转一次）
    initial begin
        sys_clk = 0;
        forever
            #10 sys_clk = ~sys_clk; // 50MHz
    end

    // 仿真复位：开始保持复位 100ns，然后释放
    initial begin
        rst_n = 0;
        #100;
        rst_n = 1;

        #10000;
        $stop;
    end

endmodule
