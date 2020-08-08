`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2020 07:42:53 PM
// Design Name: 
// Module Name: count32
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module counter_puf #(parameter SIZE=32)(
    input clk, en, reset,
    output reg [SIZE-1:0] q
    );
    
    always @ (posedge clk, posedge reset )
        if(reset)
            q <= 0;
        else begin
            if(en)
                q <= q + 1;
            else q <= q;
        end
endmodule
