`timescale 1ns / 1ps

module tb_hdb3();

    reg sys_clk;
    reg rst_n;

    wire [7:0] pcm_source_data;
    wire hdb3_enc_in;
    wire hdb3_p;
    wire hdb3_n;
    wire hdb3_decoded_data;
    wire [7:0] pcm_decoded_data;
    wire pcm_decoded_valid;

    // 实例化顶层模块
    hdb3_top u_hdb3_top (
                 .sys_clk(sys_clk),
                 .rst_n(rst_n),
                 .pcm_source_data(pcm_source_data),
                 .hdb3_enc_in(hdb3_enc_in),
                 .hdb3_p(hdb3_p),
                 .hdb3_n(hdb3_n),
                 .hdb3_decoded_data(hdb3_decoded_data),
                 .pcm_decoded_data(pcm_decoded_data),
                 .pcm_decoded_valid(pcm_decoded_valid)
             );

    // 产生 50MHz 时钟
    initial begin
        sys_clk = 0;
        forever
            #10 sys_clk = ~sys_clk;
    end

    // 复位逻辑
    initial begin
        rst_n = 0;
        #100;
        rst_n = 1;

        // 运行足够长的时间以观察 PCM 数据变化
        #20000;
        $stop;
    end

endmodule
