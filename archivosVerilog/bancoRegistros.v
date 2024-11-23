`timescale 1ps/1ps

// Banco de registros /////////////////////////
module Banco_registros (
	input[4:0] AR1,
	input[4:0] AR2,
	input[4:0] AW,
	input[31:0] DW,
	input EnW,
	output reg[31:0] DR1,
	output reg[31:0] DR2
);

reg [31:0] mem [0:63];

initial begin
    $readmemh("Datos.txt", mem);
    #10;
end

always @(*) begin
	if (EnW) begin
		mem[AW] = DW;
    end
	DR1 = mem[AR1];
	DR2 = mem[AR2];
end
endmodule