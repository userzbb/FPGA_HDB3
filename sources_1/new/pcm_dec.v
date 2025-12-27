`timescale 1ns / 1ps

module pcm_dec(
        input wire clk,
        input wire rst_n,
        input wire pcm_serial_in,
        output reg [7:0] pcm_data_out,
        output reg data_valid
    );

    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_cnt <= 3'd0;
            shift_reg <= 8'd0;
            pcm_data_out <= 8'd0;
            data_valid <= 1'b0;
        end
        else begin
            // 移入数据 (MSB first，与编码器一致)
            shift_reg <= {shift_reg[6:0], pcm_serial_in};

            // 假设系统复位是同步的，解码器和编码器的 bit_cnt 会保持相位一致
            // 在实际系统中需要帧同步机制，这里简化处理
            if (bit_cnt == 3'd7) begin
                pcm_data_out <= {shift_reg[6:0], pcm_serial_in};
                data_valid <= 1'b1;
            end
            else begin
                data_valid <= 1'b0;
            end

            bit_cnt <= bit_cnt + 1;
        end
    end

endmodule
