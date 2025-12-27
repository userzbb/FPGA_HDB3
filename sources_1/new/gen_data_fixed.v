`timescale 1ns / 1ps

module gen_data_fixed(
        input wire clk,
        input wire rst_n,
        output reg data_out
    );
    // 固定 32 位循环测试序列，包含 0000 用于触发 HDB3 的替代规则
    reg [31:0] pattern = 32'b1011_0000_0000_1100_0010_0000_0000_1011;

    // 每个时钟周期输出最高位，然后把序列循环左移，序列会重复产生
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pattern <= 32'b1011_0000_0000_1100_0010_0000_0000_1011;
            data_out <= 1'b0;
        end
        else begin
            data_out <= pattern[31];
            pattern <= {pattern[30:0], pattern[31]}; // 循环移位
        end
    end
endmodule
