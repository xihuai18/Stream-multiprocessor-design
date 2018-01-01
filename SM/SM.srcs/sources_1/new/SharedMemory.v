`define K 4
`define MAX 9

//may be we can consider other methods to avoid confilcts, such as maintain a vector.

module ShareMemory(
    input wire clk,
    input wire [7:0] MemoryWrite,
    input wire [7:0] MemoryRead,
    input wire [31:0][7:0] WriteData,
//    input wire [31:0] WriteData0, [31:0] WriteData1, [31:0] WriteData2, [31:0] WriteData3, [31:0] WriteData4, [31:0] WriteData5, [31:0] WriteData6, [31:0] WriteData7, 
    input wire [31:0][7:0] Address,
//    input wire [31:0] AddressReal0, [31:0] AddressReal1, [31:0] AddressReal2, [31:0] AddressReal3, [31:0] AddressReal4, [31:0] AddressReal5, [31:0] AddressReal6, [31:0] AddressReal7, 
    output reg [7:0] Return,
    output reg [7:0][15:0] RequestVector,
//    output reg [7:0] RequestVectorReal[0], [7:0] RequestVectorReal[1], [7:0] RequestVectorReal[2], [7:0] RequestVectorReal[3], [7:0] RequestVectorReal[4], [7:0] RequestVectorReal[5], [7:0] RequestVectorReal[6], [7:0] RequestVectorReal[7], [7:0] RequestVectorReal[8], [7:0] RequestVectorReal[9], [7:0] RequestVectorReal[1]0, [7:0] RequestVectorReal[1]1, [7:0] RequestVectorReal[1]2, [7:0] RequestVectorReal[1]3, [7:0] RequestVectorReal[1]4, [7:0] RequestVectorReal[1]5, 
    output reg [31:0][15:0] Data
//    output reg [31:0]Data0, [31:0]Data1, [31:0]Data2, [31:0]Data3, [31:0]Data4, [31:0]Data5, [31:0]Data6, [31:0]Data7, [31:0]Data8, [31:0]Data9, [31:0]Data10, [31:0]Data11, [31:0]Data12, [31:0]Data13, [31:0]Data14, [31:0]Data15
);

reg [31:0]WriteDataReal[7:0];
reg [31:0]AddressReal[7:0];
reg [7:0]RequestVectorReal[15:0];
reg [31:0]DataReal[15:0];

integer i, j, t, z;

always@(Address or WriteData) begin
    for(i = 0; i < 8; i = i + 1) begin
        AddressReal[i] = Address[i];
        WriteDataReal[i] = WriteData[i];
    end
end

reg [7:0] banks[64*`K-1:0];
reg [3:0] targetBank[7:0];
reg [3:0] firstReq[7:0];
reg [2:0] conflicts[7:0];

integer head, tail;

initial begin
    head = 0;
    tail = -1;
end

//find the targetBanks and read
always@(posedge clk) begin
    for(i = 0; i < 8; i = i + 1) begin
        firstReq[i] = 8;
    end
    for(i = 0; i < 8; i = i + 1) begin
        if(AddressReal[i]/4 % 16 == 0) begin
            targetBank[i] <= 0;
            RequestVectorReal[0][i]<=1;
        end
        else if(AddressReal[i]/4 % 16 == 1) begin
            RequestVectorReal[0][i] <= 0;
            targetBank[i] <= 1;
            RequestVectorReal[1][i] <= 1;
        end
        else if(AddressReal[i]/4 % 16 == 2) begin
            RequestVectorReal[1][i] <= 0;
            targetBank[i] <= 2;
            RequestVectorReal[2][i] <= 1;
        end
        else if(AddressReal[i]/4 % 16 == 3) begin
            RequestVectorReal[2][i] <= 0;
            targetBank[i] <= 3;
            RequestVectorReal[3][i] <= 1;
        end
        else if(AddressReal[i]/4 % 16 == 4) begin
            RequestVectorReal[3][i] <= 0;
            targetBank[i] <= 4;
            RequestVectorReal[4][i] <= 1;
        end
        else if(AddressReal[i]/4 % 16 == 5) begin
            RequestVectorReal[4][i] <= 0;
            targetBank[i] <= 5;
            RequestVectorReal[5][i] <= 1;
        end
        else if(AddressReal[i]/4 % 16 == 6) begin
            RequestVectorReal[5][i] <= 0;
            targetBank[i] <= 6;
            RequestVectorReal[6][i] <= 1;
        end
        else if(AddressReal[i]/4 % 16 == 7) begin
            RequestVectorReal[6][i] <= 0;
            targetBank[i] <= 7;
            RequestVectorReal[7][i] <= 1;
        end
        else if(AddressReal[i]/4 % 16 == 8) begin
            RequestVectorReal[7][i] <= 0;
            targetBank[i] <= 8;
            RequestVectorReal[7][i] <= 1;
        end
        else if(AddressReal[i]/4 % 16 == 9) begin
            RequestVectorReal[8][i] <= 0;
            targetBank[i] <= 9;
            RequestVectorReal[9][i] <= 1;
        end
        else if(AddressReal[i]/4 % 16 == 10) begin
            RequestVectorReal[9][i] <= 0;
            targetBank[i] <= 10;
            RequestVectorReal[10][i] <= 1;
        end
        else if(AddressReal[i]/4 % 16 == 11) begin
            RequestVectorReal[10][i] <= 0;
            targetBank[i] <= 11;
            RequestVectorReal[11][i] <= 1;
        end
        else if(AddressReal[i]/4 % 16 == 12) begin
            RequestVectorReal[11][i] <= 0;
            targetBank[i] <= 12;
            RequestVectorReal[12][i] <= 1;
        end
        else if(AddressReal[i]/4 % 16 == 13) begin
            RequestVectorReal[12][i] <= 0;
            targetBank[i] <= 13;
            RequestVectorReal[13][i] <= 1;
        end
        else if(AddressReal[i]/4 % 16 == 14) begin
            RequestVectorReal[13][i] <= 0;
            targetBank[i] <= 14;
            RequestVectorReal[14][i] <= 1;
        end
        else if(AddressReal[i]/4 % 16 == 15) begin
            RequestVectorReal[14][i] <= 0;
            targetBank[i] <= 15;
            RequestVectorReal[15][i] <= 1;
        end
        else begin
            RequestVectorReal[15][i] <= 0;
        end
        if(firstReq[targetBank[i]] != 8) begin
            if(AddressReal[i] != AddressReal[firstReq[targetBank[i]]] && MemoryRead[i] == 1) begin
                RequestVectorReal[targetBank[i]][i] <= 0;
                tail <= (tail+1)%`MAX;
                conflicts[tail] <= i;
                Return[i] <= 0;
            end
            else begin
                if(MemoryRead[i] == 1) begin
                    Return[i] <= 1;
                end
            end
//            else if(MemoryRead[i] == 1) begin        
//                Data[targetBank[i]] <= bank[targetBank[i]][AddressReal[i] - targetBank[i] * `K];
//            end 
        end
        else begin
            if(MemoryRead[i] == 1) begin
                firstReq[targetBank[i]] <= i;
                DataReal[targetBank[i]] <= {banks[AddressReal[i]], banks[AddressReal[i]+1] , banks[AddressReal[i]+2], banks[AddressReal[i]+3]};
                Return[i] <= 1;
            end
        end
    end
//serial read
    if((tail+1)%`MAX != head) begin
        DataReal[targetBank[conflicts[head]]] <= {banks[AddressReal[conflicts[head]]], banks[AddressReal[conflicts[head]]+1], banks[AddressReal[conflicts[head]]+2], banks[AddressReal[conflicts[head]]+3]};
        for(j = 0; j < 8; j = j + 1) begin
            if(j == conflicts[head]) begin
                RequestVectorReal[j] <= 1;
            end
            else begin
                RequestVectorReal[j] <= 0;
            end
        end
        Return[conflicts[head]] <= 1;
        head <= (head+1)%`MAX;
    end
end

//write
always@(posedge clk) begin
    for(t = 0; t < 8; t = t + 1) begin
        if(MemoryWrite[t] == 1) begin
            {banks[AddressReal[t]], banks[AddressReal[t]+1], banks[AddressReal[t]+2], banks[AddressReal[t]+3]} <= WriteDataReal[t];
        end
    end
end

always@(*) begin
    for(z = 0; z < 16; z = z + 1) begin
        RequestVector[z] = RequestVectorReal[z];
        Data[z] = DataReal[z]; 
    end
end



endmodule


