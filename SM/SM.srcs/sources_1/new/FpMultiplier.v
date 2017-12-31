
module FpMultiplier(
//    input wire [4:0] ALUOp,
    input wire [31:0] A,
    input wire [31:0] B,
    output reg [31:0] Result
    );

reg [1:0] overflow;

//use this formula£º(1.a)*(1.b) = 1 + (.a + .b) + .a*.b

reg signA, signB, singR;
reg [7:0] expA, expB, expR;
reg [22:0] manA, manB, manR;
reg normalRight; //the bits needed of the normalization to the right    
reg [7:0] tempExpA, tempExpB; //the exponent is in the form of biased code, transformed to complement
reg [8:0] tempExpR; //the additional bit is designed to judge the overflow
reg [23:0] tempMan; //storing the first 23 bits of the product of manA and manB, the additional bit is to judge whether it needs to normalize
reg [45:0] tempProduct; //the product of manA and manB
reg [23:0] tempSum; //storing the sum of manA and manB
reg [1:0] intPart; //the integer part

//extract the parts of a IEEE 754 float point number
always@(A or B) begin
    signA = A[31];
    expA = A[30:23];
    manA = A[22:0];
    
    signB = B[31];
    expB = B[30:23];
    manB = B[22:0];

//multiply the mantissa
    tempProduct = manA * manB;
    tempSum = manA + manB;
    tempMan = tempProduct[45:23] + tempSum[22:0];
    intPart = 1 + tempMan[23] + tempSum[23];

//normal and judge overflow
    if(intPart[1] == 1) begin //the result is bigger than 1 and less than 4, and needs to shift right
        normalRight = 1'b1;
        manR = {intPart[0], tempMan[22:1]}; //shift the mantissa
    end
    else begin
        normalRight = 1'b0;
        manR = tempMan;
    end
//add the exponents
    tempExpR = tempExpA + tempExpB - 127 + normalRight;    
    case(tempExpR[8:7])
    2'b10: overflow = 2'b10; //overflow
    2'b01: overflow = 2'b01; //underflow
    endcase
    expR = tempExpR[7:0];

//sign
    signR = signA ^ signB;

//output
    Result = {signR, expR, mamR};
end

endmodule
