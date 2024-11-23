`timescale 1ps/1ps

// Alu ///////////////////////////////
module alu (
    input [31:0] dataInput1,
    input [31:0] dataInput2,
    input [2:0] sel,
    output reg [31:0] dataOutput,
    output reg zero,
    output reg retraso
);

always @(*) begin
    zero = 0;
    #1;
    case (sel)
        3'b000: begin
            dataOutput = dataInput1 & dataInput2;
        end
        3'b001: begin
            dataOutput = dataInput1 | dataInput2;
        end
        3'b010: begin
            dataOutput = dataInput1 + dataInput2;
            retraso = 1;
            #1;
            retraso = 0;
        end
        3'b110: begin
            dataOutput = dataInput1 - dataInput2;
            if (dataOutput == 0) begin
                zero = 1;
            end
        end
        3'b111: begin
            dataOutput = (dataInput1 < dataInput2) ? 32'd1 : 32'd0;
        end
        3'b100: begin
            dataOutput = ~(dataInput1 | dataInput2);
        end
        3'b101: begin
            dataOutput = dataInput1 ^ dataInput2;
        end
        3'b011: begin
            dataOutput = 32'b0;
        end
    endcase
end
endmodule