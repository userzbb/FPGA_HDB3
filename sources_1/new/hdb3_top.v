`timescale 1ns / 1ps

module hdb3_top(
        input wire sys_clk,
        input wire rst_n,

        // 观察信号
        output wire [7:0] pcm_source_data, // 原始PCM并行数据
        output wire hdb3_enc_in,           // PCM串行数据 (HDB3输入)
        output wire hdb3_p,                // HDB3 +
        output wire hdb3_n,                // HDB3 -
        output wire hdb3_decoded_data,     // HDB3译码后串行数据 (PCM译码输入)
        output wire [7:0] pcm_decoded_data,// PCM译码后并行数据
        output wire pcm_decoded_valid      // PCM译码有效指示
    );

    wire sample_en;

    // 1. 生成 PCM 原始信号 (8-bit 并行)
    gen_pcm_signal u_gen_pcm (
                       .clk(sys_clk),
                       .rst_n(rst_n),
                       .sample_en(sample_en),
                       .data_out(pcm_source_data)
                   );

    // 2. PCM 编码 (并行 -> 串行)
    pcm_enc u_pcm_enc (
                .clk(sys_clk),
                .rst_n(rst_n),
                .pcm_data_in(pcm_source_data),
                .pcm_serial_out(hdb3_enc_in),
                .sample_en(sample_en)
            );

    // 3. HDB3 编码 (串行 -> HDB3脉冲)
    hdb3_enc u_hdb3_enc (
                 .clk(sys_clk),
                 .rst_n(rst_n),
                 .data_in(hdb3_enc_in),
                 .hdb3_p(hdb3_p),
                 .hdb3_n(hdb3_n)
             );

    // 4. HDB3 译码 (HDB3脉冲 -> 串行)
    hdb3_dec u_hdb3_dec (
                 .clk(sys_clk),
                 .rst_n(rst_n),
                 .hdb3_p(hdb3_p),
                 .hdb3_n(hdb3_n),
                 .data_out(hdb3_decoded_data)
             );

    // 5. PCM 译码 (串行 -> 并行)
    pcm_dec u_pcm_dec (
                .clk(sys_clk),
                .rst_n(rst_n),
                .pcm_serial_in(hdb3_decoded_data),
                .pcm_data_out(pcm_decoded_data),
                .data_valid(pcm_decoded_valid)
            );

endmodule
