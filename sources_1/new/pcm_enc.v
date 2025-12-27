`timescale 1ns / 1ps

module pcm_enc(
        input wire clk,
        input wire rst_n,
        input wire [7:0] pcm_data_in,
        output reg pcm_serial_out,
        output reg sample_en // 输出给数据源，指示当前字节已读取，可以更新下一个数据
    );

    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_cnt <= 3'd0;
            shift_reg <= 8'd0;
            pcm_serial_out <= 1'b0;
            sample_en <= 1'b0;
        end
        else begin
            // 简单的 8-bit 循环计数
            // 在 bit_cnt == 0 时加载新数据
            if (bit_cnt == 3'd0) begin
                shift_reg <= pcm_data_in;
                pcm_serial_out <= pcm_data_in[7]; // 先发高位 MSB
                shift_reg[7:1] <= pcm_data_in[6:0]; // 移位准备
                sample_en <= 1'b1; // 通知数据源更新
            end
            else begin
                pcm_serial_out <= shift_reg[7]; // 输出当前最高位
                shift_reg <= {shift_reg[6:0], 1'b0}; // 左移
                sample_en <= 1'b0;
            end

            bit_cnt <= bit_cnt + 1;
        end
    end

endmodule
