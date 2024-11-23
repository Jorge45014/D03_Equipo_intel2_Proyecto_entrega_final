`timescale 1ps/1ps

// topLevel ///////////////////////////////
module topLevel (
    input wire clk,
    output reg [31:0] salida,
    output reg [31:0] alu1,
    output reg [31:0] alu2,
    output reg [4:0] pc
);

    // Salidas de: UNIDAD DE CONTROL (UC)
    wire UC_MUX_3;
    wire UC_MUX_1;
    wire [2:0] UC_AC;
    wire UC_MUX_2; // Branch
    wire UC_MUX_4;
    wire UC_BR;
    wire UC_MD_R;
    wire UC_MD_W;

    // Salidas de: BANCO DE REGISTROS (BR)
    wire [31:0] BR_ALU;
    wire [31:0] BR_MUX_4;

    // Salidas de: MUX 1
    wire [31:0] MUX_1_BR;

    // Salidas de: ALU CONTROL (AC)
    wire [2:0] AC_ALU;

    // Salidas de: ALU (ALU)
    wire [31:0] ALU_MD_MUX;
    wire ALU_MUX_2;
    wire ALU_retraso;

    // Salidas de: MEMORIA DATOS (MD)
    wire [31:0] MD_MUX_1;

    // Salidas de: MUX 2
    wire [4:0] MUX_2_PC;

    // Salidas de: PC
    wire [4:0] PC_MUX_2_RA;

    // Salidas de: Read Address (RA)
    wire [31:0] RA_;

    // Salidas de: MUX 3
    wire [4:0] MUX_3_BR;

    // Salidas de: SE
    wire [31:0] SE_MUX_4;

    // Salidas de: MUX 4
    wire [31:0] MUX_4_ALU;

    // Salidas de: SL2
    wire [31:0] SL2_MUX_2;

    U_control iUnidadControl(
        .opCode(RA_[31:26]),
        .Branch(UC_MUX_2),
        .RegDst(UC_MUX_3),
        .MemRead(UC_MD_R),
        .MemWrite(UC_MD_W),
        .MemToReg(UC_MUX_1),   
        .ALUOP(UC_AC),
        .ALUsrc(UC_MUX_4),     
        .RegWrite(UC_BR)  
    );

    aluControl iAluControl(
        .UC_input(UC_AC),
        .funct(RA_[5:0]),
        .AC_output(AC_ALU)
    );

    alu iALU(
        .dataInput1(BR_ALU),
        .dataInput2(MUX_4_ALU),
        .sel(AC_ALU),
        .dataOutput(ALU_MD_MUX),
        .zero(ALU_MUX_2),
        .retraso(ALU_retraso)
    );

    Banco_registros iBancoRegistros(
        .AR1(RA_[25:21]),
        .AR2(RA_[20:16]),
        .AW(MUX_3_BR),
        .DW(MUX_1_BR),
        .EnW(UC_BR),
        .DR1(BR_ALU),
        .DR2(BR_MUX_4)
    );

    mux2_1_32bits_MUX_1 iMUX_1(
        .sel(UC_MUX_1),
        .a(MD_MUX_1),
        .b(ALU_MD_MUX),
        .c(MUX_1_BR)
    );

    Mem_datos iMemoriaDatos(
        .Address(ALU_MD_MUX),
        .writeData(BR_MUX_4),
        .EnW(UC_MD_W && ALU_retraso),
        .EnR(UC_MD_R),
        .dataOutput(MD_MUX_1)
    );

    mux2_1_5bits iMUX_2(
        .sel(1'b0),
        .a(PC_MUX_2_RA),
        .b(SL2_MUX_2),
        .c(MUX_2_PC)
    );

    PC iPC(
        .clk(clk),
        .pc_in(MUX_2_PC),
        .pc_out(PC_MUX_2_RA)
    );

    readAddress iReadAddress(
        .i(PC_MUX_2_RA),
        .TB_out(RA_)
    );

    mux2_1_5bits iMUX_3(
        .sel(UC_MUX_3),
        .a(RA_[20:16]),
        .b(RA_[15:11]),
        .c(MUX_3_BR)
    );

    sign_extend iSE(
        .in(RA_[15:0]),
        .out(SE_MUX_4)
    );

    mux2_1_32bits_MUX_4 iMUX_4(
        .sel(UC_MUX_4),
        .a(BR_MUX_4),
        .b(SE_MUX_4),
        .c(MUX_4_ALU)
    );

    shift_left_2 iSL2(
        .inSingExtemd(SE_MUX_4),
        .inPC(PC_MUX_2_RA),
        .out(SL2_MUX_2)
    );

    always @* begin
        salida = ALU_MD_MUX; //MUX_1_BR
        pc = PC_MUX_2_RA;
        alu1 = BR_ALU;
        alu2 = MUX_4_ALU;
    end

endmodule

// TB_topLevel ///////////////////////////////
module TB_topLevel;
    reg TB_clk;
    wire [31:0] TB_out;
    wire [31:0] talu1;
    wire [31:0] talu2;
    wire [4:0] TB_pc;

    topLevel uut(
        .clk(TB_clk),
        .salida(TB_out),
        .pc(TB_pc),
        .alu1(talu1),
        .alu2(talu2)

    );

    initial begin
        TB_clk = 0;
        forever #100 TB_clk = ~TB_clk;
    end
endmodule