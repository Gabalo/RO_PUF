`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2020 09:34:15 PM
// Design Name: 
// Module Name: testbench
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


module testbench();

    reg clk;
    wire start; 
    wire [255:0] response; 
    wire [7:0] challenge;
    
    PUF RO_PUF(
        .clk(clk),
        .challenge(challenge),
        .start(start),
        .response(response)
    );
    
    stimulus s1(
        .start(start),
        .challenge(challenge)
    );
      
    initial 
        begin 
        clk = 0;
    end 
    
    always begin
        #1 clk = !clk;
    end

endmodule

module stimulus (
        output reg start,
        output reg [7:0] challenge );
            
    initial begin
        challenge = 8'h3C;
        #3 start = 1'b1;
        #5 start = 1'b0;
    end

endmodule