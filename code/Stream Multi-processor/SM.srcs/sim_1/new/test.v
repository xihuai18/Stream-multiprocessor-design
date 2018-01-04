`timescale 1ns / 1ps

module test();

reg clk;
//reg rst;
initial begin
//    rst = 1;
    clk = 1;
//    #100 rst = 0;
end
StreamingMultiprocesser SM(.CLK(clk));

always begin
    #100 clk = ~clk;
end

endmodule
//`timescale 1ns / 1ps

//module testAd();

//reg [31:0] a, b, result;

//initial
//begin
//    a = 32'b0011_1111_1100_0000_0000_0000_0000_0000;
//    b = 32'b0;
//end
//FloatAdder FA(.a(a), .b(b), .result(result));

//endmodule
