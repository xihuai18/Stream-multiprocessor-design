`timescale 1ns / 1ps


module StreamProcessor(
    input clk,
    input [63:0] instruction,
    input Return,
    input [31:0] MemoryReadData,
    output Occupied,
    output [31:0] MemoryAddress,
    output [31:0] MemoryWriteData,
    output MemoryRead,
    output MemoryWrite
    );
    
    wire WriteRegSrc;  //
    wire RegWre;     //
    wire ALUSrcB;    // 
    wire [4:0]ALUOp;  //
    
    wire DBDataSrc;  // 
    wire [31:0] immediate;
    wire [31:0] result;
    wire [31:0] rega;
    wire [31:0] regb;
    
    
    wire [9:0] ReadReg1;
    wire [9:0] ReadReg2;
    wire [9:0] WriteReg;
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;
    wire [31:0] WriteData;
    
    assign immediate = instruction[33:2];
    assign rega = ReadData1;
    assign regb = (ALUSrcB == 0)? ReadData2 : immediate;
    assign MemoryAddress = result;
    
    assign ReadReg1 = instruction[53:44];
    assign ReadReg2 = instruction[43:34];
    assign WriteReg = (WriteRegSrc == 0)? instruction[43:34]: instruction[33:24];
    assign WriteData = (DBDataSrc == 0)? result: MemoryReadData;
    ControlUnit CU(
        .clk(clk),
        .insOp(instruction[63:54]),
        .Return(Return),
        .WriteRegSrc(WriteRegSrc),
        .RegWre(RegWre),
        .ALUSrcB(ALUSrcB),
        .DBDataSrc(DBDataSrc),
        .ALUOp(ALUOp),
        .MemoryRead(MemoryRead),
        .MemoryWrite(MemoryWrite),
        .Occupied(Occupied)
     );
    ALU alu(
        .ALUOp(ALUOp) , .rega(rega), .regb(regb) , .result(result)
    );
    
    RegFile RF(
        .clk(clk), .RegWre(RegWre), .ReadReg1(ReadReg1),
        .ReadReg2(ReadReg2), .WriteReg(WriteReg),
        .WriteData(WriteData), .ReadData1(ReadData1), .ReadData2(ReadData2)
    );
    
endmodule
