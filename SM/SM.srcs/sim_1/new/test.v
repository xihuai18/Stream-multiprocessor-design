`timescale 1ns / 1ps

module test();

reg clk;
initial clk = 0;
StreamingMultiprocesser SM(.CLK(clk));

always begin
    #100 clk = ~clk;
end

endmodule
