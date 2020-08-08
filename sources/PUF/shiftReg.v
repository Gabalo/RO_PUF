`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2020 05:11:02 PM
// Design Name: 
// Module Name: shiftReg
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


module shiftReg(
    input clk,
    input s_in,
    input en,
    output reg [255:0] p_out
    );
    
    reg [7:0] counter;
    
    always@(posedge clk) begin
        if (en)
            p_out <= {s_in,p_out[255:1]};
    end
        
endmodule
