module MultithreadInstructionUnit(
    input wire clk,
    input wire [7:0] validVectorOri,
//    input wire [3:0] BarrierNum,
    input wire [63:0] Ins[7:0],
    output reg  [63:0] instructions[7:0],
    output reg [7:0] validVectorTo
);

integer i;

always @(posedge clk) begin
    for(i = 0; i < 8; i = i + 1) begin
        instructions[i] <= Ins[i];
    end
end

always @(negedge clk) begin
    validVectorTo = validVectorOri;
end

endmodule