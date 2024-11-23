`timescale 1ps/1ps

// ALU Control ///////////////////////////////
module aluControl(
    input [2:0] UC_input,
    input [5:0] funct,

    output reg [2:0] AC_output
);

always @(*) begin
    case (UC_input)
        3'b000:
            case (funct)
                6'b100000: AC_output = 3'b010; // add
                6'b100010: AC_output = 3'b110; // sub
                6'b101010: AC_output = 3'b111; // slt
                6'b100100: AC_output = 3'b000; // and
                6'b100101: AC_output = 3'b001; // or
                6'b100110: AC_output = 3'b101; // xor
                6'b100111: AC_output = 3'b100; // nor
                6'b000000: AC_output = 3'b011; // nop (no operacion)
            endcase
        3'b010: // add
            AC_output = 3'b010;
        3'b110: // sub
            AC_output = 3'b110;
        3'b111: // slt
            AC_output = 3'b111;
        3'b011: // and
            AC_output = 3'b000;
        3'b001: // or
            AC_output = 3'b001;

        default: AC_output = 3'bxxx;
    endcase
end
endmodule