`timescale 1ns / 1ps

module ALU(
    input [4:0] ALUOp,
    input [31:0] rega,
    input [31:0] regb,
    output reg [31:0] result
    );
    
    wire [7:0] expa;
    wire [7:0] expb;
    wire [22:0] taila;
    wire [22:0] tailb;
    wire [31:0] minus_regb;
    
    wire [31:0] FloatAdder_result;
    wire [31:0] FloatSub_result;
    wire [31:0] FloatMul_result;
    assign minus_regb[31] = ~regb[31];
    assign minus_regb[30:0] = regb[30:0];
    assign expa = rega[30:23];
    assign expb = regb[30:23];
    assign taila = rega[22:0];
    assign tailb = regb[22:0];
    FloatAdder FA(
        .a(rega) , .b(regb), .result(FloatAdder_result)  
    );
    FloatAdder FS(
        .a(rega) ,  .b(minus_regb),   .result(FloatSub_result)
    );
    FpMultiplier FM(
        .A(rega), .B(regb), .Result(FloatMul_result)
    );
    always@(ALUOp or rega or regb)
    begin
        case(ALUOp)
            5'b00000:  //s32 +
            begin
                result <= rega + regb;
            end
            5'b00001:  //f32 + 
            begin
                result <= FloatAdder_result;
            end
            5'b00010:
            begin
                result <= rega - regb;
            end
            5'b00011:   //f32 -
            begin
                result <= FloatSub_result;
            end
            5'b00100:
            begin
                result <= rega * regb;
            end
            5'b00101:    //f32 *
            begin
                result <= FloatMul_result; 
            end
            5'b00110:  //abs
            begin
                if(rega[31] == 1)
                    result <= ~rega + 1;
            end
            5'b00111:  //fabs
            begin
                result[31] <= 0;
                result[30:0] <= rega[30:0];
            end
            5'b01000:   //s32取反
            begin
                result <= ~rega + 1;
            end
            5'b01001:  //f32取反
            begin
                result[31] <= ~rega[31];
                result[30:0] <= ~rega[30:0];
            end
            5'b01010:   //max A B  S32
            begin
                if(rega[31] == regb[31])
                begin
                    if(rega > regb)
                        result <= rega;
                    else result <= regb;
                end
                else 
                begin
                    if(rega[31] == 1'b1)
                        result <= regb;
                    else result <= rega;
                end
            end
            5'b01011:     //max A B F32
            begin
                if(rega[31] == regb[31])
                begin
                    if(rega[31] == 1'b1)
                    begin
                        if(expa < expb)
                            result <= rega;
                        else 
                        begin
                            if(expa > expb)
                                result <= regb;
                             else 
                             begin
                                if(taila < tailb)
                                    result <= taila;
                                else result <= tailb;
                             end
                        end
                    end
                    else 
                    begin
                        if(expa < expb)
                            result <= regb;
                        else 
                        begin
                            if(expa > expb)
                                result <= rega;
                            else
                            begin
                                if(taila < tailb)
                                    result <= tailb;
                                else result <= taila;
                            end
                        end
                    end
                end
                else 
                begin
                    if(rega[31] == 1'b1)
                        result <= regb;
                    else result <= rega;
                end
                
            end
            5'b01100:   //min A B S32
            begin
                if(rega[31] == regb[31])
                begin
                    if(rega < regb)
                        result <= rega;
                    else result <= regb;
                end
                else 
                    if(rega[31] == 1'b1)
                        result <= rega;
                    else result <= regb;
            end
            5'b01101:   // min A B F32
            begin
                if(rega[31] == regb[31])
                begin
                    if(rega[31] == 1'b1)
                    begin
                        if(expa < expb)
                            result <= regb;
                        else
                        begin
                            if(expa > expb)
                                result <= expa;
                            else 
                            begin
                                if(taila < tailb)
                                    result <= tailb;
                                else result <= taila;
                            end
                        end
                    end
                    else
                    begin
                        if(expa < expb)
                        begin
                            result <= rega;
                        end
                        else 
                        begin
                            if(expa > expb)
                                result <= regb;
                             else 
                             begin
                                if(taila < tailb)
                                    result <= taila;
                                else result <= tailb;
                             end
                        end
                    end
                end
                else
                begin
                    if(rega[31] == 1'b1)
                        result <= rega;
                    else result <= regb;
                end
            end
            5'b10000:     //逻辑非
            begin
                result <= ~rega;
            end
            5'b10001:
            begin
                result <= rega & regb;
            end
            5'b10010:
            begin
                result <= rega | regb;
            end
            5'b10011:
            begin
                result <= rega << regb;
            end
            
           
        endcase
    end
    
  
endmodule
