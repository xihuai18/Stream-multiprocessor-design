`define K 1024
`define MAX 9

//may be we can consider other methods to avoid confilcts, such as maintain a vector.

module ShareMemory(
    input wire clk,
    input wire MemoryWrite[7:0],
    input wire MemoryRead[7:0],
    input wire [31:0] WriteData[7:0],
    input wire [31:0] Address[7:0],
    output reg [7:0] Return,
    output reg [7:0] RequestVector[15:0],
    output reg [31:0] Data[15:0]
);

reg [0:4*`K-1][7:0] bank[15:0];
reg [3:0] targetBank[7:0];
reg [3:0] firstReq[7:0];
reg [2:0] conficts[7:0];

integer i;
integer head, tail;

initial begin
    head = 0;
    tail = -1;
end

//find the targetBanks and read
always@(MemoryRead or Address or MemoryWrite or WriteData) begin
    for(i = 0; i < 8; i = i + 1) begin
        firstReq[i] = 8;
//        Return[i] = 0;
    end
    for(i = 0; i < 8; i = i + 1) begin
        if(Address[i] < `K) begin
            targetBank[i] <= 0;
//            RequestVector[targetBank[i]][i] = 1;
            RequestVector[0][i]<=1;
        end
        else if(Address[i] < 2*`K) begin
            RequestVector[0][i] <= 0;
            targetBank[i] <= 1;
            RequestVector[1][i] <= 1;
        end
        else if(Address[i] < 3*`K) begin
            RequestVector[1][i] <= 0;
            targetBank[i] <= 2;
            RequestVector[2][i] <= 1;
        end
        else if(Address[i] < 4*`K) begin
            RequestVector[2][i] <= 0;
            targetBank[i] <= 3;
            RequestVector[3][i] <= 1;
        end
        else if(Address[i] < 5*`K) begin
            RequestVector[3][i] <= 0;
            targetBank[i] <= 4;
            RequestVector[4][i] <= 1;
        end
        else if(Address[i] < 6*`K) begin
            RequestVector[4][i] <= 0;
            targetBank[i] <= 5;
            RequestVector[5][i] <= 1;
        end
        else if(Address[i] < 7*`K) begin
            RequestVector[5][i] <= 0;
            targetBank[i] <= 6;
            RequestVector[6][i] <= 1;
        end
        else if(Address[i] < 8*`K) begin
            RequestVector[6][i] <= 0;
            targetBank[i] <= 7;
            RequestVector[7][i] <= 1;
        end
        else if(Address[i] < 9*`K) begin
            RequestVector[7][i] <= 0;
            targetBank[i] <= 8;
            RequestVector[8][i] <= 1;
        end
        else if(Address[i] < 10*`K) begin
            RequestVector[8][i] <= 0;
            targetBank[i] <= 9;
            RequestVector[9][i] <= 1;
        end
        else if(Address[i] < 11*`K) begin
            RequestVector[9][i] <= 0;
            targetBank[i] <= 10;
            RequestVector[10][i] <= 1;
        end
        else if(Address[i] < 12*`K) begin
            RequestVector[10][i] <= 0;
            targetBank[i] <= 11;
            RequestVector[11][i] <= 1;
        end
        else if(Address[i] < 13*`K) begin
            RequestVector[11][i] <= 0;
            targetBank[i] <= 12;
            RequestVector[12][i] <= 1;
        end
        else if(Address[i] < 14*`K) begin
            RequestVector[12][i] <= 0;
            targetBank[i] <= 13;
            RequestVector[13][i] <= 1;
        end
        else if(Address[i] < 15*`K) begin
            RequestVector[13][i] <= 0;
            targetBank[i] <= 14;
            RequestVector[14][i] <= 1;
        end
        else if(Address[i] < 16*`K) begin
            RequestVector[14][i] <= 0;
            targetBank[i] <= 15;
            RequestVector[15][i] <= 1;
        end
        else begin
            RequestVector[15][i] <= 0;
        end
        if(firstReq[targetBank[i]] != 8) begin
            if(Address[i] != Address[firstReq[targetBank[i]]] && MemoryRead[i] == 1) begin
                RequestVector[targetBank[i]][i] <= 0;
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
//                Data[targetBank[i]] <= bank[targetBank[i]][Address[i] - targetBank[i] * `K];
//            end 
        end
        else begin
            if(MemoryRead[i] == 1) begin
                firstReq[targetBank[i]] <= i;
                Data[targetBank[i]] <= bank[targetBank[i]][(Address[i] - targetBank[i] * `K):(Address[i] - targetBank[i] * `K + 3)];
                Return[i] <= 1;
            end
        end
    end
end

//write
always@(posedge clk) begin
    for(i = 0; i < 8; i = i + 1) begin
        if(MemoryWrite[i] == 1) begin
            bank[targetBank[i]] <= WriteData[i];
        end
    end
end

//serial read
always@(posedge clk) begin
    if((tail+1)%`MAX != head) begin
        Data[targetBank[conflicts[head]]] <= bank[targetBank[conflicts[head]]][Address[conflicts[head]] - targetBank[conflicts[head]] * `K:(Address[conflicts[head]] - targetBank[conflicts[head]] * `K + 3)];
        for(i = 0; i < 8; i = i + 1) begin
            if(i == conflicts[head]) begin
                RequestVector[i] <= 1;
            end
            else begin
                RequestVector[i] <= 0;
            end
        end
        Result[conflicts[head]] <= 1;
        head <= (head+1)%`MAX;
    end
end

endmodule


