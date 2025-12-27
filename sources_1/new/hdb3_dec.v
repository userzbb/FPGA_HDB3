`timescale 1ns / 1ps

module hdb3_dec(
        input wire clk,
        input wire rst_n,
        input wire hdb3_p,
        input wire hdb3_n,
        output reg data_out
    );

    reg [1:0] pulse_buf [3:0]; // 存最近 4 个周期的脉冲状态（用于检测 B00V）
    reg [3:0] data_buf; // 位缓冲：data_buf[3] 是最终输出（有延迟）

    reg last_pulse_pol; // 记录上一次脉冲极性：0 = -, 1 = +

    wire [1:0] current_pulse;
    assign current_pulse = hdb3_p ? 2'b01 : (hdb3_n ? 2'b11 : 2'b00); // 编码为 2 位：01 表示正脉冲，11 表示负脉冲，00 表示空（无脉冲）

    wire is_v;
    // 如果当前脉冲和上一次脉冲同极性（且非 0），判为 V（破坏脉冲）
    assign is_v = (current_pulse != 0) &&
           ((current_pulse == 2'b01 && last_pulse_pol == 1) ||
            (current_pulse == 2'b11 && last_pulse_pol == 0));

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<4; i=i+1)
                pulse_buf[i] <= 2'b00;
            data_buf <= 4'b0;
            last_pulse_pol <= 1'b0; // 复位时把极性初始化为 0（负）
            data_out <= 1'b0;
        end
        else begin
            // 把本周期脉冲放入 pulse_buf[0]，历史数据依次后移
            pulse_buf[0] <= current_pulse;
            pulse_buf[1] <= pulse_buf[0];
            pulse_buf[2] <= pulse_buf[1];
            pulse_buf[3] <= pulse_buf[2];

            // 只有普通脉冲（非 V）才更新 last_pulse_pol（记录最新有效极性）
            if (current_pulse != 0 && !is_v) begin
                last_pulse_pol <= (current_pulse == 2'b01) ? 1 : 0;
            end

            // Decode logic

            // 当前位判定：V -> 0；有脉冲 -> 1；没脉冲 -> 0
            if (is_v) begin
                data_buf[0] <= 0;
            end
            else begin
                data_buf[0] <= (current_pulse != 0) ? 1 : 0;
            end

            // 2. Shift data buffer
            data_buf[1] <= data_buf[0];
            data_buf[2] <= data_buf[1];

            // 如果检测到 B00V（当前是 V，之前是 B 0 0），把 B 修正为 0（还原原始 0000）

            if (is_v && pulse_buf[0] == 0 && pulse_buf[1] == 0 && pulse_buf[2] != 0) begin
                data_buf[3] <= 0;
            end
            else begin
                data_buf[3] <= data_buf[2];
            end

            // Output
            data_out <= data_buf[3];
        end
    end

endmodule
