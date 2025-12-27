`timescale 1ns / 1ps

module gen_pcm_signal(
        input wire clk,
        input wire rst_n,
        input wire sample_en,
        output reg [7:0] data_out
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 8'd0;
        end
        else begin
            if (sample_en) begin
                data_out <= data_out + 1; // 产生锯齿波
            end
        end
    end

endmodule
