`timescale 1ps/1ps

// Memoria de datos /////////////////////////
module Mem_datos (
	input wire [31:0] Address,
	input wire [31:0] writeData,
	input wire EnW,
    input wire EnR,

	output reg[31:0] dataOutput
);

reg [31:0] mem [0:63];

always @(*) begin
    if (EnW) begin
        mem[Address] = writeData;
    end else if (EnR) begin
        dataOutput = mem[Address];
    end else begin
        dataOutput = 32'b0;
    end
end
endmodule