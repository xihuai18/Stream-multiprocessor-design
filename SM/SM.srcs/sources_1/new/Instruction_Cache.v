module Instruction_Cache(
    input wire [7:0] validVector,
//    output reg [3:0] BarrierNum,
    output reg [64*8-1:0] Ins
    );

reg [3:0] BarrierNum;
reg [7:0] InsMem[0:1023];
reg [9:0] InsPtr;

reg [63:0] InsReal[7:0];

integer i, j, t;

initial begin
    $readmemb("../../../Ins.txt", InsMem);
    InsPtr = 0;
end    

always @(validVector) begin
    for(j = 0; j < 8; j = j + 1) begin
        for(t = 0; t < 64; t = t + 1) begin
            Ins[j*64+t] <= InsReal[j][t];
        end
    end
end

always @(validVector) begin
    BarrierNum = 8;
    for(i = 0; i < 8; i=i + 1) begin
        if(validVector[i] == 0 && i < BarrierNum) begin
            InsReal[i] = {InsMem[InsPtr], InsMem[InsPtr+1], InsMem[InsPtr+2], InsMem[InsPtr+3], InsMem[InsPtr+4], InsMem[InsPtr+5], InsMem[InsPtr+6], InsMem[InsPtr+7]}; 
            if(InsReal[i][63:54] == 10'b1111_1111_10) begin
                BarrierNum = i;
                InsReal[i] = 64'hFFFF_FFFF;//needn't to process
            end
            InsPtr = InsPtr + 8;
        end
        else begin
            InsReal[i] = 64'hFFFF_FFFF; //invalid
        end
    end
end


endmodule
