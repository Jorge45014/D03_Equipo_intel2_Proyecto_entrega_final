`timescale 1ps/1ps

// Mux 2 a 1 /////////////////////////
module mux2_1_5bits (
    input sel,
    input [4:0] a,
    input [4:0] b,
    output reg [4:0] c
);

always @* begin
    if (sel) begin
        c = b;
    end
    else begin
        c = a;
    end    
end
endmodule