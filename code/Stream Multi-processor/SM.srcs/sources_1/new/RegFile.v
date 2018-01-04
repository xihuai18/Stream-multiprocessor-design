`timescale 1ns / 1ps

module RegFile(
    input clk,
    //input rst,
    input RegWre,   //1 for write,
    input [9:0] ReadReg1,ReadReg2,WriteReg,
    input [31:0] WriteData,
    input [31:0] ReadData1,ReadData2 
    );
    
    reg [31:0] regFile [1:1023];
    integer i;
    assign ReadData1 = (ReadReg1 == 0)? 0: regFile[ReadReg1];
    assign ReadData2 = (ReadReg2 == 0)? 0: regFile[ReadReg2];
    always@(posedge clk)
    begin
//        if(rst == 0)
//        begin
//            for(i = 1; i < 1024; i= i+1)
//                regFile[i] <= 0;
//        end
//        else 
        if(RegWre == 1 && WriteReg != 0)
            regFile[WriteReg] <= WriteData;
    end
endmodule
