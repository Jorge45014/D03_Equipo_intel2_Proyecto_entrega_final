`timescale 1ps/1ps

// ADD ///////////////////////////////
module ADD (
    input [31:0] A_ADD,
    input [31:0] B_ADD,
    output [31:0] C_ADD
);
    assign C_ADD = A_ADD + B_ADD;
endmodule

// shift_left_2 ///////////////////////////////
module shift_left_2 (
    input  [31:0] inSingExtemd,
    input  [31:0] inPC,
    output [31:0] out
);

    ADD i(
        .A_ADD(inSingExtemd << 2),
        .B_ADD(inPC),             
        .C_ADD(out)               
    );

endmodule
