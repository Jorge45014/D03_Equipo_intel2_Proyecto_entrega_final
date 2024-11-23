`timescale 1ps/1ps

// Read Address ///////////////////////////////
module readAddress(
    input wire [4:0] i,
    output reg [31:0] TB_out
);

    reg [31:0] mem[0:31];

    initial begin
        $readmemb("instrucciones.txt", mem);
    end

    always @(*) begin
        TB_out = mem[i];
    end
endmodule
