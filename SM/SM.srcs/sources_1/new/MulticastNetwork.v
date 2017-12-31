module MulticastNetwork(
    input wire [31:0] DataIn[15:0],
    input wire [7:0] RequestVector[15:0],
    input wire [7:0] ReturnIn,
    output reg [31:0] DataOut[7:0],
    output wire [7:0] ReturnOut
);

integer i;
integer j;

assign ReturnOut = ReturnIn;

always@(DataIn or RequestVector or Return) begin
    for(i = 0; i < 16; i = i + 1) begin
        for(j = 0; j < 8; j = j + 1) begin
            if(RequestVector[j] == 1) begin
                DataOut[j] <= DataIn[i];
            end
        end
    end
end

endmodule