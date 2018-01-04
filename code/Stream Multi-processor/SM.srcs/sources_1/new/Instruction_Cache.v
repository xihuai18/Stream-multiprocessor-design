module Instruction_Cache(
    input wire [7:0] validVector,
//    output reg [3:0] BarrierNum,
    output reg [64*8-1:0] Ins
    );

reg [3:0] BarrierNum;
reg [7:0] InsMem[0:1023];

reg [63:0] InsReal[7:0];

integer i, j, t, InsPtr;

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
//    if(validVector[0] == 0 && 0 < BarrierNum) begin
//        InsReal[0] = {InsMem[InsPtr], InsMem[InsPtr+1], InsMem[InsPtr+2], InsMem[InsPtr+3], InsMem[InsPtr+4], InsMem[InsPtr+5], InsMem[InsPtr+6], InsMem[InsPtr+7]}; 
//        if(InsReal[0][63:54] == 10'b1111_1111_10) begin
//            BarrierNum = 0;
//            InsReal[0] = 64'hFFFF_FFFF;//needn't to process
//        end
//        InsPtr = InsPtr + 8;
//    end
//    else begin
//        InsReal[0] = 64'hFFFF_FFFF; //invalid
//    end
    
//    if(validVector[1] == 0 && 1 < BarrierNum) begin
//        InsReal[1] = {InsMem[InsPtr], InsMem[InsPtr+1], InsMem[InsPtr+2], InsMem[InsPtr+3], InsMem[InsPtr+4], InsMem[InsPtr+5], InsMem[InsPtr+6], InsMem[InsPtr+7]}; 
//        if(InsReal[1][63:54] == 10'b1111_1111_10) begin
//            BarrierNum = 1;
//            InsReal[1] = 64'hFFFF_FFFF;//needn't to process
//        end
//        InsPtr = InsPtr + 8;
//    end
//    else begin
//        InsReal[1] = 64'hFFFF_FFFF; //invalid
//    end
    
//    if(validVector[2] == 0 && 2 < BarrierNum) begin
//        InsReal[2] = {InsMem[InsPtr], InsMem[InsPtr+1], InsMem[InsPtr+2], InsMem[InsPtr+3], InsMem[InsPtr+4], InsMem[InsPtr+5], InsMem[InsPtr+6], InsMem[InsPtr+7]}; 
//        if(InsReal[2][63:54] == 10'b1111_1111_10) begin
//            BarrierNum = 2;
//            InsReal[2] = 64'hFFFF_FFFF;//needn't to process
//        end
//        InsPtr = InsPtr + 8;
//    end
//    else begin
//        InsReal[2] = 64'hFFFF_FFFF; //invalid
//    end
    
//    if(validVector[3] == 0 && 3 < BarrierNum) begin
//        InsReal[3] = {InsMem[InsPtr], InsMem[InsPtr+1], InsMem[InsPtr+2], InsMem[InsPtr+3], InsMem[InsPtr+4], InsMem[InsPtr+5], InsMem[InsPtr+6], InsMem[InsPtr+7]}; 
//        if(InsReal[3][63:54] == 10'b1111_1111_10) begin
//            BarrierNum = 3;
//            InsReal[3] = 64'hFFFF_FFFF;//needn't to process
//        end
//        InsPtr = InsPtr + 8;
//    end
//    else begin
//        InsReal[3] = 64'hFFFF_FFFF; //invalid
//    end
    
//    if(validVector[4] == 0 && 4 < BarrierNum) begin
//        InsReal[4] = {InsMem[InsPtr], InsMem[InsPtr+1], InsMem[InsPtr+2], InsMem[InsPtr+3], InsMem[InsPtr+4], InsMem[InsPtr+5], InsMem[InsPtr+6], InsMem[InsPtr+7]}; 
//        if(InsReal[4][63:54] == 10'b1111_1111_10) begin
//            BarrierNum = 4;
//            InsReal[4] = 64'hFFFF_FFFF;//needn't to process
//        end
//        InsPtr = InsPtr + 8;
//    end
//    else begin
//        InsReal[4] = 64'hFFFF_FFFF; //invalid
//    end
    
//    if(validVector[5] == 0 && 5 < BarrierNum) begin
//        InsReal[5] = {InsMem[InsPtr], InsMem[InsPtr+1], InsMem[InsPtr+2], InsMem[InsPtr+3], InsMem[InsPtr+4], InsMem[InsPtr+5], InsMem[InsPtr+6], InsMem[InsPtr+7]}; 
//        if(InsReal[5][63:54] == 10'b1111_1111_10) begin
//            BarrierNum = 5;
//            InsReal[5] = 64'hFFFF_FFFF;//needn't to process
//        end
//        InsPtr = InsPtr + 8;
//    end
//    else begin
//        InsReal[5] = 64'hFFFF_FFFF; //invalid
//    end
    
//    if(validVector[6] == 0 && 6 < BarrierNum) begin
//        InsReal[6] = {InsMem[InsPtr], InsMem[InsPtr+1], InsMem[InsPtr+2], InsMem[InsPtr+3], InsMem[InsPtr+4], InsMem[InsPtr+5], InsMem[InsPtr+6], InsMem[InsPtr+7]}; 
//        if(InsReal[6][63:54] == 10'b1111_1111_10) begin
//            BarrierNum = 6;
//            InsReal[6] = 64'hFFFF_FFFF;//needn't to process
//        end
//        InsPtr = InsPtr + 8;
//    end
//    else begin
//        InsReal[6] = 64'hFFFF_FFFF; //invalid
//    end
    
//    if(validVector[7] == 0 && 7 < BarrierNum) begin
//        InsReal[7] = {InsMem[InsPtr], InsMem[InsPtr+1], InsMem[InsPtr+2], InsMem[InsPtr+3], InsMem[InsPtr+4], InsMem[InsPtr+5], InsMem[InsPtr+6], InsMem[InsPtr+7]}; 
//        if(InsReal[7][63:54] == 10'b1111_1111_10) begin
//            BarrierNum = 7;
//            InsReal[7] = 64'hFFFF_FFFF;//needn't to process
//        end
//        InsPtr = InsPtr + 8;
//    end
//    else begin
//        InsReal[7] = 64'hFFFF_FFFF; //invalid
//    end
    
end


endmodule
