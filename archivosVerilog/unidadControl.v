`timescale 1ps/1ps

// Unidad de control /////////////////////////
module U_control (
    input wire [5:0] opCode,     // Entrada: opcode de 6 bits
    output reg RegDst,           // Salida: Mux 3 <--
    output reg Branch,           // Salida: Branch (Mux 2)
    output reg MemRead,          // Salida: Memoria datos leer
    output reg MemToReg,         // Salida: Mux 1 <--
    output reg [2:0] ALUOP,      // Salida: operacion de la ALu (3 bits) <--
    output reg MemWrite,         // Salida: Memoria datos escribir
    output reg ALUsrc,           // Salida: Mux 4 <--
    output reg RegWrite          // Salida: Banco de registros <--
);

    always @(*) begin

        case (opCode)
            6'b000000: begin // Tipo R
                RegDst = 1;
                Branch = 0;
                MemRead = 0;
                MemToReg = 0;
                ALUOP = 3'b000;
                MemWrite = 0;
                ALUsrc = 0;
                RegWrite = 1;
            end
            6'b001000: begin // Tipo ADDI
                RegDst = 0;
                Branch = 0;
                MemRead = 0;
                MemToReg = 0;
                ALUOP = 3'b010;
                MemWrite = 0;
                ALUsrc = 1;
                RegWrite = 1;
            end
            6'b001010: begin // Tipo SLTI
                RegDst = 0;
                Branch = 0;
                MemRead = 0;
                MemToReg = 0;
                ALUOP = 3'b111;
                MemWrite = 0;
                ALUsrc = 1;
                RegWrite = 1;
            end
            6'b001100: begin // Tipo ANDI
                RegDst = 0;
                Branch = 0;
                MemRead = 0;
                MemToReg = 0;
                ALUOP = 3'b011;
                MemWrite = 0;
                ALUsrc = 1;
                RegWrite = 1;
            end
            6'b001101: begin // Tipo ORI
                RegDst = 0;
                Branch = 0;
                MemRead = 0;
                MemToReg = 0;
                ALUOP = 3'b001;
                MemWrite = 0;
                ALUsrc = 1;
                RegWrite = 1;
            end
            6'b101011: begin // Tipo SW
                RegDst = 0;
                Branch = 0;
                MemRead = 0;
                MemToReg = 0;
                ALUOP = 3'b010;
                MemWrite = 1;
                ALUsrc = 1;
                RegWrite = 0;
            end
            6'b100011: begin // Tipo LW
                RegDst = 0;
                Branch = 0;
                MemRead = 1;
                MemToReg = 1;
                ALUOP = 3'b010;
                MemWrite = 0;
                ALUsrc = 1;
                RegWrite = 1;
            end
            6'b000100: begin // Tipo BEQ
                RegDst = 0;
                Branch = 1;
                MemRead = 0;
                MemToReg = 0;
                ALUOP = 3'b110; // hacer resta par saber si son iguales
                MemWrite = 0;
                ALUsrc = 0;
                RegWrite = 0;
            end

        endcase
    end
endmodule

