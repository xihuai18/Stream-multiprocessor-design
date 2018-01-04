`timescale 1ns / 1ps

module FloatAdder(
    input [31:0] a,
    input [31:0] b,
   // input start,
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
       reg [24:0] tail;
       always @(a or b)
       begin
       if(a != 32'h00000000 && b != 32'b00000000)
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
           
           
           if(a[31] == b[31])   //???????
           begin
               tail = taila_after + tailb_after;
               for(i = 0; i < 25 ; i = i +1)   //??????1¦Ë
               begin
                   if(tail[i] == 1'b1) cnt = i;
               end
               if(cnt >= 23)
               begin
                    tail = tail >> (cnt - 23);
                    exp = expa_after + cnt - 23;
               
               end
               else 
               begin
                    tail = tail << (23 - cnt);
                    exp = expa_after - (23 - cnt);
               end
               result = {a[31], exp, tail[22:0]};
           end
           else 
           begin    //????¦Ë???
               tail = taila_after - tailb_after;
               for(i = 0; i < 25 ; i = i+1)
               begin
                   if(tail[i] == 1'b1) cnt = i;
               end
               if(cnt >= 23)
               begin
                    tail = tail >> (cnt - 23);
                    exp = expa_after + cnt - 23;
               end
               else 
               begin
                    tail = tail << (23 - cnt);
                    exp = expa_after - (23 - cnt);
                end
               if(taila_after > tailb_after)
                   result = {1'b1, exp, tail[22:0]};
               else result = {1'b0, exp, tail[22:0]};
           end
          
       end
       else 
       begin
            if(a == 32'h00000000) result = b;
            else result = a;
       end
        
       end
    
endmodule
