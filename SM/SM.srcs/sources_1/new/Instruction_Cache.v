module Instruction_Cache(
    input wire [7:0] validVector,
//    output reg [3:0] BarrierNum,
    output reg [63:0] Ins[7:0]
    );

reg [3:0] BarrierNum;
reg [7:0] InsMem[0:1023];
reg [9:0] InsPtr;

integer i;

initial begin
    $readmemb("../../../Ins.txt", InsMem);
    InsPtr = 0;
end    

always @(validVector) begin
    BarrierNum = 8;
    for(i = 0; i < 8; i=i + 1) begin
        if(validVector[i] == 0 && i < BarrierNum) begin
            Ins[i] = {InsMem[InsPtr], InsMem[InsPtr+1], InsMem[InsPtr+2], InsMem[InsPtr+3], InsMem[InsPtr+4], InsMem[InsPtr+5], InsMem[InsPtr+6], InsMem[InsPtr+7]}; 
            if(Ins[i][63:54] == 10'b1111_1111_10) begin
                BarrierNum = i;
                Ins[i] = 64'hFFFF_FFFF;//needn't to process
            end
            InsPtr = InsPtr + 8;
        end
        else begin
            Ins[i] = 64'hFFFF_FFFF; //invalid
        end
    end
end


endmodule
