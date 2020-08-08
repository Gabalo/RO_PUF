`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.07.2020 15:28:51
// Design Name: 
// Module Name: rotate_leds
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


module rotate_leds #(parameter N=264)(
    input clk,
    input start,
    input [N-1:0] data_in,
    output [7:0] leds
    );
    
    reg [29:0] counter;
    reg [N-1:0] temp;
    
    always @(posedge clk)
    begin
        if (start) begin
            temp <= data_in;
            counter <= 0;
        end
        else begin
            counter <= counter + 1;
            if(counter == 0)
                temp <= {temp[7:0],temp[N-1:8]};
        end
    end
    
    assign leds = temp[7:0];
        
endmodule
