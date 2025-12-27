`timescale 1ns / 1ps

module hdb3_top(
        input wire sys_clk,
        input wire rst_n,
        output wire data_orig,
        output wire hdb3_p,
        output wire hdb3_n,
        output wire data_decoded
    );

    // 实例化：生成数据 -> 编码 -> 译码，便于仿真观察原始与还原数据
    gen_data_fixed u_gen_data (
                       .clk(sys_clk),
                       .rst_n(rst_n),
                       .data_out(data_orig)
                   );

    hdb3_enc u_hdb3_enc (
                 .clk(sys_clk),
                 .rst_n(rst_n),
                 .data_in(data_orig),
                 .hdb3_p(hdb3_p),
                 .hdb3_n(hdb3_n)
             );

    hdb3_dec u_hdb3_dec (
                 .clk(sys_clk),
                 .rst_n(rst_n),
                 .hdb3_p(hdb3_p),
                 .hdb3_n(hdb3_n),
                 .data_out(data_decoded)
             );

endmodule
