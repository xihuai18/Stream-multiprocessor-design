`timescale 1ns / 1ps
module StreamingMultiprocesser(
    input wire CLK
    );
wire [64*8-1:0] Ins;
wire [64*8-1:0] InsOutOfMulInsUnit;
wire [7:0] ValidVector;

Instruction_Cache InsCache(
    .validVector(ValidVector), .Ins(Ins)
);

wire [7:0] ValidVectorFromSP;


MultithreadInstructionUnit MulInsUnit(
    .clk(CLK), .validVectorOri(ValidVectorFromSP), .Ins(Ins), .instructions(InsOutOfMulInsUnit), .validVectorTo(ValidVector)
);

wire [7:0] ReturnFMulNet;
wire [7:0] ReturnFShared;
//wire [31:0] DataFMulNet[7:0];
wire [32*8-1:0] DataFMulNet;
//wire [31:0] DataFShared[15:0];
wire [32*16-1:0] DataFShared;
//wire [7:0] RequestVector[15:0];
//wire [7:0] RequestVector[15:0];
//wire [31:0] MemoryAddress[7:0];
//wire [31:0] MemoryWriteData[7:0];
wire [8*16-1:0] RequestVector;
wire [32*8-1:0] MemoryAddress;
wire [32*8-1:0] MemoryWriteData;
wire [7:0] MemoryRead;
wire [7:0] MemoryWrite;

genvar gv_i;
generate
    for(gv_i = 0; gv_i < 8; gv_i = gv_i + 1) begin : SP
        StreamProcessor _SP(
            .clk(CLK), .instruction(InsOutOfMulInsUnit[(gv_i+1)*64-1:gv_i*64]), 
            .Return(ReturnFMulNet[gv_i]), .MemoryReadData(DataFMulNet[(gv_i+1)*32-1:gv_i*32]),
            .Occupied(ValidVectorFromSP[gv_i]), .MemoryAddress(MemoryAddress[(gv_i+1)*32-1:gv_i*32]),
            .MemoryWriteData(MemoryWriteData[(gv_i+1)*32-1:gv_i*32]), .MemoryRead(MemoryRead[gv_i]),
            .MemoryWrite(MemoryWrite[gv_i])
        );
    end
endgenerate

MulticastNetwork MulNet(
    .DataIn(DataFShared), .RequestVector(RequestVector), .ReturnIn(ReturnFShared),
    .DataOut(DataFMulNet), .ReturnOut(ReturnFMulNet)
);

ShareMemory SharedMem(
    .clk(CLK), .MemoryWrite(MemoryWrite), .MemoryRead(MemoryRead), .WriteData(MemoryWriteData), .Address(MemoryAddress),
    .Return(ReturnFShared), .RequestVector(RequestVector), .Data(DataFShared)
);

endmodule
