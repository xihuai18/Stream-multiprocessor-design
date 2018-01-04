module MulticastNetwork(
//    input wire [31:0][15:0] DataIn,
//    input wire [7:0][15:0] RequestVector,
    input wire [32*16-1:0] DataIn,
    input wire [8*16-1:0] RequestVector,
    input wire [7:0] ReturnIn,
    output reg [32*8-1:0] DataOut,
//    output reg [31:0][7:0] DataOut,
    output wire [7:0] ReturnOut
);

integer i;
integer j;

assign ReturnOut = ReturnIn;

reg [31:0]DataInReal[15:0];
reg [7:0] RequestVectorReal[15:0];
reg [31:0] DataOutReal[7:0];

always@(DataIn or RequestVector or ReturnIn) begin
    for(i = 0; i < 16; i = i + 1) begin
        for(j = 0; j < 32; j = j + 1) begin
            DataInReal[i][j] <= DataIn[i*32+j];
        end
    end
    for(i = 0; i < 8; i = i + 1) begin
        for(j = 0; j < 16; j = j + 1) begin
            RequestVectorReal[i][j] <= RequestVector[i*8+j];
        end
    end
    for(i = 0; i < 16; i = i + 1) begin
        for(j = 0; j < 8; j = j + 1) begin
            if(RequestVectorReal[j] == 1) begin
                DataOutReal[j] <= DataInReal[i];
            end
        end
    end
    for(i = 0; i < 8; i = i + 1) begin
        for(j = 0; j < 32; j = j + 1) begin
            DataOut[i*8+j] <= DataOutReal[i][j];
        end
    end
end

endmodule