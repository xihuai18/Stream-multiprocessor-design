`timescale 1ns / 1ps


module FloatAdder(
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] result
    );
    wire [7:0] expa;
    wire [7:0] expb;
    wire [22:0] taila;
    wire [22:0] tailb;
    reg [7:0] exp;
    reg [7:0] differ;
    reg [7:0] cnt;
    reg [7:0] i;
    assign expa = a[30:23];
    assign expb = b[30:23];
    assign taila = a[22:0];
    assign tailb = b[22:0];
    //assign differ = expa - expb;
    reg [7:0] expa_after;
    reg [7:0] expb_after;
    reg [23:0] taila_after;
    reg [23:0] tailb_after;
    reg [23:0] tail;
    always@(a or b)
    begin
        cnt = 0;
        i = 0;
        differ = expa - expb;
        if(differ[7] == 1)     // expa < expb   , differ < 0
        begin
            expa_after = expa - differ;
            expb_after = expb;
            taila_after = {1'b1, taila[22:0]} >>  (-differ);
            tailb_after = {1'b1, tailb[22:0]};
        end
        else 
        begin
            expa_after = expa;
            expb_after = expb + differ;
            taila_after = {1'b1, taila[22:0]};
            tailb_after = {1'b1, tailb[22:0]} >> differ;
        end
        
        
        if(a[31] == a[31])   //符号相同
        begin
            tail = taila_after + tailb_after;
            for(i = 0; i < 24 ; i = i +1)   //找最高的1位
            begin
                if(tail[i] == 1'b1) cnt = i;
            end
            tail = tail << (24 - cnt);
            exp = taila_after - (24 - cnt);
            result = {a[31], exp, tail};
        end
        else 
        begin    //符号位不同
            tail = taila_after - tailb_after;
            for(i = 0; i < 24 ; i = i+1)
            begin
                if(tail[i] == 1'b1) cnt = i;
            end
            tail = tail << (24 - cnt);
            exp = taila_after - (24 - cnt);
            if(taila_after > tailb_after)
                result = {1'b1, exp, tail};
            else result = {1'b0, exp, tail};
        end
        
    end
endmodule
