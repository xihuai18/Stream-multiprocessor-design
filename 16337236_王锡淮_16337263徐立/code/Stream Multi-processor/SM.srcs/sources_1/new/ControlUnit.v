`timescale 1ns / 1ps

module ControlUnit(
    input clk,
    input [9:0] insOp,
    input Return,
    output reg WriteRegSrc,
    output reg RegWre,
    output reg ALUSrcB,
    output reg DBDataSrc,
    output reg [4:0] ALUOp,
    output reg MemoryRead,
    output reg MemoryWrite,
    output reg Occupied
    );
    reg [2:0] pst;
    
    initial 
    begin
        pst = 3'b000;
        RegWre = 0;
        MemoryWrite = 0;
        MemoryRead = 0;
        Occupied = 0;
    end
    always@(negedge clk)
    begin
        if(pst == 3'b000)
        begin
            RegWre <= 0;
            MemoryWrite <= 0;
            MemoryRead <= 0;
            if(insOp == 10'b0000000000 || insOp == 10'b1111111111 || 10'bz)
            begin
                Occupied <= 0;
            end
            else 
            begin
                Occupied <= 1;
                pst <= 3'b001;
            end
        end
        case(insOp)
            10'b1000_0000_00:  //add.s32 rd,rs,rt
            begin
                case(pst)
                    3'b001:
                    begin
                        pst <= 3'b010;
                        //ALUOp <= 5'b00000;
                    end
                    3'b010:
                    begin
                        pst <= 3'b011;
                        ALUSrcB <= 0;
                        ALUOp <= 5'b00000;
                    end
                    3'b011:
                    begin
                        pst <= 3'b000;
                        RegWre <= 1;
                        WriteRegSrc <= 1;
                        DBDataSrc <= 0;
                        Occupied <= 0;
                    end
                endcase
            end
            10'b1000_0000_01:  // add.s32 rt,rs,imme
            begin
                case(pst)
                    3'b001:
                    begin
                        pst <= 3'b010;
                    end
                    3'b010:
                    begin
                        pst <= 3'b011;
                        ALUSrcB <= 1;
                        ALUOp <= 5'b00000;
                    end
                    3'b011:
                    begin
                        pst <= 3'b000;
                        RegWre <= 1;
                        WriteRegSrc <= 0;
                        DBDataSrc <= 0;
                        Occupied <= 0;
                    end
                endcase
            end
            10'b1000_0000_10:  //add.f32 rd,rs,rt
            begin
                case(pst)
                    3'b001:
                    begin
                        pst <= 3'b010;
                    end
                    3'b010:
                    begin
                        pst <= 3'b011;
                        ALUSrcB <= 0;
                        ALUOp <= 5'b00001;
                    end
                    3'b011:
                    begin
                        pst <= 3'b000;
                        RegWre <= 1;
                        WriteRegSrc <= 1;
                        DBDataSrc <= 0;
                        Occupied <= 0;
                    end
                endcase
            end
            10'b1000_0000_11:  //add.f32 rt,rs,immediate
            begin
                case(pst)
                    3'b001:
                    begin
                        pst <= 3'b010;
                    end
                    3'b010:
                    begin
                        pst <= 3'b011;
                        ALUSrcB <= 1;
                        ALUOp <= 5'b00001;
                    end
                    3'b011:
                    begin
                        pst <= 3'b000;
                        RegWre <= 1;
                        WriteRegSrc <= 0;
                        DBDataSrc <= 0;
                        Occupied <= 0;
                    end
                endcase
            end
            10'b1100_0000_00:   //sub.s32 rd,rs,rt
            begin
                case(pst)
                    3'b001:
                    begin
                        pst <= 3'b010;
                    end
                     3'b010:
                    begin
                        pst <= 3'b011;
                        ALUSrcB <= 0;
                        ALUOp <= 5'b00010;
                    end
                    3'b011:
                    begin
                        pst <= 3'b000;
                        RegWre <= 1;
                        WriteRegSrc <= 1;
                        DBDataSrc <= 0;
                        Occupied <= 0;
                    end
                endcase
            end             
            10'b1100_0000_01:  //sub.s32 rt,rs,immediate
            begin
                case(pst)
                3'b001:
                begin
                    pst <= 3'b010;
                end
                 3'b010:
                begin
                    pst <= 3'b011;
                    ALUSrcB <= 1;
                    ALUOp <= 5'b00010;
                end
                3'b011:
                begin
                    pst <= 3'b000;
                    RegWre <= 1;
                    WriteRegSrc <= 0;
                    DBDataSrc <= 0;
                    Occupied <= 0;
                end
                endcase            
            end
            10'b1100000010:   //sub.f32 rd,rs,rt
            begin
                case(pst)
                3'b001:
                begin
                    pst <= 3'b010;
                end
                 3'b010:
                begin
                    pst <= 3'b011;
                    ALUSrcB <= 0;
                    ALUOp <= 5'b00011;
                end
                3'b011:
                begin
                    pst <= 3'b000;
                    RegWre <= 1;
                    WriteRegSrc <= 1;
                    DBDataSrc <= 0;
                    Occupied <= 0;
                end
                endcase            
            end    
            10'b1100_0000_11:   //sub.f32,rt,rs,immediate
            begin
                case(pst)
                3'b001:
                begin
                    pst <= 3'b010;
                end
                3'b010:
                begin
                    pst <= 3'b011;
                    ALUSrcB <= 1;
                    ALUOp <= 5'b00011;
                end
                3'b011:
                begin
                    pst <= 3'b000;
                    RegWre <= 1;
                    WriteRegSrc <= 0;
                    DBDataSrc <= 0;
                    Occupied <= 0;
                end
                endcase                
            end
            10'b1110_0000_00:    //mul.s32 rd, rs, rt
            begin
                case(pst)
                    3'b001:
                    begin
                        pst <= 3'b010;
                    end
                    3'b010:
                    begin
                        pst <= 3'b011;
                        ALUSrcB <= 0;
                        ALUOp <= 5'b00100;
                    end
                    3'b011:
                    begin
                        pst <= 3'b000;
                        RegWre <= 1;
                        WriteRegSrc <= 1;
                        DBDataSrc <= 0;
                        Occupied <= 0;
                    end
                endcase
            end
            10'b1110_0000_01:    //mul.s32 rt,rs,immed
            begin
                case(pst)
                    3'b001:
                    begin
                        pst <= 3'b010;
                    end
                    3'b010:
                    begin
                        pst <= 3'b011;
                        ALUSrcB <= 1;
                        ALUOp <= 5'b00100;
                    end
                    3'b011:
                    begin
                        pst <= 3'b000;
                        RegWre <= 1;
                        WriteRegSrc <= 0;
                        DBDataSrc <= 0;
                        Occupied <= 0;
                    end
                endcase
            end
            10'b1110_0000_10:   //mul.f32 rd, rs, rt
            begin
                case(pst)
                    3'b001:
                    begin
                        pst <= 3'b010;
                    end
                    3'b010:
                    begin
                        pst <= 3'b011;
                        ALUSrcB <= 0;
                        ALUOp <= 5'b00101;
                    end
                    3'b011:
                    begin
                        pst <= 3'b000;
                        RegWre <= 1;
                        WriteRegSrc <= 1;
                        DBDataSrc <= 0;
                        Occupied <= 0;
                    end
                endcase
            end
            10'b1110_0000_11:   //mul.f32 rt, rs, immediate
            begin
                case(pst)
                    3'b001:
                    begin
                        pst <= 3'b010;
                    end
                    3'b010:
                    begin
                        pst <= 3'b011;
                        ALUSrcB <= 1;
                        ALUOp <= 5'b00101;
                    end
                    3'b011:
                    begin
                        pst <= 3'b000;
                        RegWre <= 1;
                        WriteRegSrc <= 0;
                        DBDataSrc <= 0;
                        Occupied <= 0;
                    end
               endcase
            end
            10'b1111_0000_00:   //abs rt,rs
            begin
                case(pst)
                    3'b001:
                    begin
                        pst <= 3'b010;
                    end
                    3'b010:
                    begin
                        pst <= 3'b011;
                        ALUOp <= 5'b00110;
                    end
                    3'b011:
                    begin
                        pst <= 3'b000;
                        RegWre <= 1;
                        WriteRegSrc <= 0;
                        DBDataSrc <= 0;
                        Occupied <= 0;
                    end
                endcase
            end
            10'b1111_0000_01:   // fabs.f32  rt, rs
            begin
                case(pst)
                    3'b001:
                    begin
                        pst <= 3'b010;
                    end
                    3'b010:
                    begin
                        pst <= 3'b011;
                        ALUOp <= 5'b00111; 
                    end
                    3'b011:
                    begin
                        pst <= 3'b000;
                        RegWre <= 1;
                        WriteRegSrc <= 0;
                        DBDataSrc <= 0;
                        Occupied <= 0;
                    end
                endcase
            end
            10'b1111_1000_00:    //neg.s32 rt,rs
            begin
                case(pst)
                    3'b001:
                    begin
                        pst <= 3'b010;
                    end
                    3'b010:
                    begin
                        pst <= 3'b011;
                        ALUOp <= 5'b01000;
                    end
                    3'b011:
                    begin
                        pst <= 3'b000;
                        RegWre <= 1;
                        WriteRegSrc <= 0;
                        DBDataSrc <= 0;
                        Occupied <= 0;
                    end
                endcase
            end
            10'b1111_1000_01:   //neg.f32 rt,rs
            begin
                case(pst)
                    3'b001:
                    begin
                        pst <= 3'b010;
                    end
                    3'b010:
                    begin
                        pst <= 3'b011;
                        ALUOp <= 5'b01001;
                    end
                    3'b011:
                    begin
                        pst <= 3'b000;
                        RegWre <= 1;
                        WriteRegSrc <= 0;
                        DBDataSrc <= 0;
                        Occupied <= 0;
                    end
                endcase
            end
            10'b1111_1110_00:    //max.s32 rd, rs, rt
            begin
                case(pst)
                    3'b001:
                    begin
                        pst <= 3'b010;
                    end
                    3'b010:
                    begin
                        pst <= 3'b011;
                        ALUOp <= 5'b01010;
                        ALUSrcB <= 0;
                    end
                    3'b011:
                    begin
                        pst <= 3'b000;
                        RegWre <= 1;
                        WriteRegSrc <= 1;
                        DBDataSrc <= 0;
                        Occupied <= 0;
                    end
                endcase
            end
            10'b1111_1110_01:   //max.f32 rd, rs, rt
            begin
                case(pst)
                    3'b001:
                    begin
                        pst <= 3'b010;
                    end
                    3'b010:
                    begin
                        pst <= 3'b011;
                        ALUOp <= 5'b01011;
                        ALUSrcB <= 0;
                    end
                    3'b011:
                    begin
                        pst <= 3'b000;
                        RegWre <= 1;
                        WriteRegSrc <= 1;
                        DBDataSrc <= 0;
                        Occupied <= 0;
                    end
                endcase
            end
            10'b1111_1100_00:   //min.s32 rd, rs, rt
            begin
                case(pst)
                    3'b001:
                    begin
                        pst <= 3'b010;
                    end
                    3'b010:
                    begin
                        pst <= 3'b011;
                        ALUOp <= 5'b01100;
                        ALUSrcB <= 0;
                    end
                    3'b011:
                    begin
                        pst <= 3'b000;
                        RegWre <= 1;
                        WriteRegSrc <= 1;
                        DBDataSrc <= 0;
                        Occupied <= 0;
                    end
                endcase
            end
            10'b1111_1100_01:   //min.f32 rd, rs, rt
            begin
                case(pst)
                    3'b001:
                    begin
                        pst <= 3'b010;
                    end
                    3'b010:
                    begin
                        pst <= 3'b011;
                        ALUOp <= 5'b01101;
                        ALUSrcB <= 0;
                    end
                    3'b011:
                    begin
                        pst <= 3'b000;
                        RegWre <= 1;
                        WriteRegSrc <= 1;
                        DBDataSrc <= 0;
                        Occupied <= 0;
                    end
                endcase
                
            end
            10'b1000_0001_00:   //not.b32 rt, rs
            begin
                case(pst)
                    3'b001:
                    begin
                        pst <= 3'b010;
                    end
                    3'b010:
                    begin
                        pst <= 3'b011;
                        ALUOp <= 5'b10000;
                    end
                    3'b011:
                    begin
                        pst <= 3'b000;
                        RegWre <=  1;
                        WriteRegSrc <= 0;
                        DBDataSrc <= 0;
                        Occupied <= 0;
                    end
                endcase
            end
            10'b1000_0010_00:    //and rd rs rt
            begin
                case(pst)
                    3'b001:
                    begin
                        pst <= 3'b010;
                    end
                    3'b010:
                    begin
                        pst <= 3'b011;
                        ALUOp <= 5'b10001;
                        ALUSrcB <= 0;
                    end
                    3'b011:
                    begin
                        pst <= 3'b000;
                        RegWre <= 1;
                        WriteRegSrc <= 1;
                        DBDataSrc <= 0;
                        Occupied <= 0;
                    end
                endcase
            end
            10'b1000_0011_00:  //or rd, rs, rt
            begin
                case(pst)
                    3'b001:
                    begin
                        pst <= 3'b010;
                    end
                    3'b010:
                    begin
                        pst <= 3'b011;
                        ALUOp <= 5'b10010;
                        ALUSrcB <= 0;
                    end
                    3'b011:
                    begin
                        pst <= 3'b000;
                        RegWre <= 1;
                        WriteRegSrc <= 1;
                        DBDataSrc <= 0;
                        Occupied <= 0;
                    end
                endcase
            end
            10'b1000_0100_00:    //sll rd rs<<rt
            begin
                case(pst)
                    3'b001:
                    begin
                        pst <= 3'b010;
                    end
                    3'b010:
                    begin
                        pst <= 3'b011;
                        ALUOp <= 5'b10011;
                        ALUSrcB <= 0;
                    end
                    3'b011:
                    begin
                        pst <= 3'b000;
                        RegWre <= 1;
                        WriteRegSrc <= 1;
                        DBDataSrc <= 0;
                        Occupied <= 0;
                    end
                endcase
            end
            10'b1010_0000_00:   //sw rt, rs ,immediate
            begin
                case(pst)
                    3'b001:
                    begin
                        pst <= 3'b010;
                    end
                    3'b010:
                    begin
                        pst <= 3'b100;
                        ALUOp <= 5'b00000;
                        ALUSrcB <= 1;
                    end
                    3'b100:
                    begin
                        pst <= 3'b000;
                        MemoryWrite <= 1;
                        Occupied <= 0;
                        //MemoryAddress <= 
                    end
                endcase
            end
            10'b1010_0000_01:    //lw rt rs,immediate
            begin
                case(pst)
                    3'b001:
                    begin
                        pst <= 3'b010;
                    end
                    3'b010:
                    begin
                        pst <= 3'b100;
                        ALUOp <= 5'b00000;
                        ALUSrcB <= 1;
                    end
                    3'b100:
                    begin
                        pst <= 3'b011;
                        MemoryRead <= 1;
                        
                    end
                    3'b011:
                    begin
                        if(Return == 1)
                        begin
                            pst <= 3'b000;
                            Occupied <= 0;
                            RegWre <= 1;
                            DBDataSrc <= 1;
                            WriteRegSrc <= 0;
                            MemoryRead <= 0;
                        end
                    end
                endcase
            end
        endcase    
    end
endmodule
