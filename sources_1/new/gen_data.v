`timescale 1ns / 1ps

module gen_data(
        input wire clk,
        input wire rst_n,
        output reg data_out
    );
    // 使用一个简单的线性反馈移位寄存器 (LFSR) 作为伪随机数据源
    // 采用多项式 x^4 + x^3 + 1（反馈位为 lfsr[3] ^ lfsr[2]）
    // lfsr 为 4 位寄存器，输出取 lfsr[3]（最高位），初始值不能为全 0，以保证伪随机序列产生
    reg [3:0] lfsr;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lfsr <= 4'b1001; // 初始值不能为全0
            data_out <= 1'b0;
        end
        else begin
            lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[2]};
            data_out <= lfsr[3];
        end
    end
endmodule
