`timescale 1ps/1ps
module sign_extend (
    input  [15:0] in,   // Entrada de 16 bits
    output [31:0] out   // Salida de 32 bits
);

    // Si el bit mas significativo de la entrada es 1, los bits superiores de la salida se llenan con 1s.
    // Si el MSB es 0, los bits superiores de la salida se llenan con 0s.
    assign out = { {16{in[15]}}, in };
endmodule
