`timescale 1ps/1ps

// PC ///////////////////////////////
module PC (
    input wire clk,
    input wire [4:0] pc_in,
    output reg [4:0] pc_out
);

    initial begin
        pc_out = 0;
    end

    always @(posedge clk) begin
        if (pc_out + 5'd4 > 5'd31)
            pc_out <= pc_in;
        else
            pc_out <= pc_out + 5'd4;
    end
endmodule