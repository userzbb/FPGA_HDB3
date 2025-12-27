`timescale 1ns / 1ps

module hdb3_enc(
        input wire clk,
        input wire rst_n,
        input wire data_in,
        output reg hdb3_p, // + 脉冲输出（1 表示正脉冲）
        output reg hdb3_n  // - 脉冲输出（1 表示负脉冲）
    );

    reg [3:0] data_buf;
    reg [1:0] skip_cnt;
    reg last_pulse_pol; // 记录上一次脉冲极性：0 = -, 1 = +（判断下一脉冲极性用）
    reg odd_pulses;     // 自上次 V 以来发出的脉冲奇偶：0 = 偶数，1 = 奇数（决定用 B00V 还是 000V）

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_buf <= 4'b0;
            skip_cnt <= 2'b0;
            last_pulse_pol <= 1'b0;
            odd_pulses <= 1'b0;
            hdb3_p <= 1'b0;
            hdb3_n <= 1'b0;
        end
        else begin
            // 把新位放进 4 位窗口，data_buf[3] 是本周期要处理的位
            data_buf <= {data_buf[2:0], data_in};

            if (skip_cnt > 0) begin
                // 处于替代处理中：skip_cnt 表示还剩多少替代位

                skip_cnt <= skip_cnt - 1;

                if (skip_cnt == 1) begin
                    // 第4位：输出 V（与上次同极）
                    if (last_pulse_pol) begin // 上一个脉冲为正
                        hdb3_p <= 1;
                        hdb3_n <= 0;
                    end
                    else begin // 上一个脉冲为负
                        hdb3_p <= 0;
                        hdb3_n <= 1;
                    end
                    // V 到：把 odd_pulses 设 0（重置）
                    odd_pulses <= 0;
                    // V 不改 last_pulse_pol（保持记忆）
                end
                else begin
                    // 替代序列的中间 0：不输出脉冲（保持 0）
                    hdb3_p <= 0;
                    hdb3_n <= 0;
                end

            end
            else begin
                // 普通处理（不在替代状态）
                if (data_buf[3] == 1) begin
                    // 遇到 1：输出脉冲，本次极性与上次相反
                    if (last_pulse_pol == 0) begin // 上次为负 -> 本次为正
                        hdb3_p <= 1;
                        hdb3_n <= 0;
                        last_pulse_pol <= 1;
                    end
                    else begin // 上次为正 -> 本次为负
                        hdb3_p <= 0;
                        hdb3_n <= 1;
                        last_pulse_pol <= 0;
                    end
                    // 每次输出脉冲，翻转 odd_pulses 标志
                    odd_pulses <= ~odd_pulses;
                end
                else begin
                    // 遇到 0：检查是否连续四个 0（window == 0000）
                    if (data_buf[3] == 0 && data_buf[2] == 0 && data_buf[1] == 0 && data_buf[0] == 0) begin
                        // 找到 0000，开始替代：设置 skip_cnt = 3（接下来的 3 位被替代处理）
                        skip_cnt <= 3; // 接下来 3 位由替代规则处理

                        if (odd_pulses == 0) begin
                            // odd_pulses = 0（偶数） -> 用 B00V：在第三位发送 B（脉冲），第四位发送 V
                            // B 是个正常脉冲，会改变极性
                            if (last_pulse_pol == 0) begin
                                hdb3_p <= 1;
                                hdb3_n <= 0;
                                last_pulse_pol <= 1;
                            end
                            else begin
                                hdb3_p <= 0;
                                hdb3_n <= 1;
                                last_pulse_pol <= 0;
                            end
                            // B 已发，等 V 来清 odd_pulses
                        end
                        else begin
                            // odd_pulses = 1（奇数） -> 用 000V：第4位是 V（此处不输出脉冲）
                            hdb3_p <= 0;
                            hdb3_n <= 0;
                        end
                    end
                    else begin
                        // 单个 0：不输出脉冲
                        hdb3_p <= 0;
                        hdb3_n <= 0;
                    end
                end
            end
        end
    end

endmodule
