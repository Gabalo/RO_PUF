`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.07.2020 10:46:04
// Design Name: 
// Module Name: tb_ec
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


module tb_ec(
    );
    localparam DATA_BITS = 192;
    localparam BITS = 8;
    localparam T = 8;
    localparam N = 264;
    
    reg clk = 0;
    reg start = 0;
    reg [7:0] challenge;
    reg [N-1:0] response;
    reg [N-1:0] RplusC;
    wire [N-1:0] corrected;
    wire [N-1:0] err_found;
    wire corr_ready;
    
    initial begin
        challenge = 8'h2A;
        response = 256'hB3A617B90E77752A732F39E72F183E7F38F3B53867ED381D73182F07812B0E09;
        RplusC = 264'h1287f06f23b2a985384779417d93c6ca6d0ca5cda2db33c97293a74109e0c0f358;
        #12 start = 1;
        #22 start = 0; 
    end
    
    always #5 clk = !clk;
    
    err_correction MyEC (
        .clk(clk),
        .start(start),
        .RplusC(RplusC),
        .response({8'b0,response}),
        .leds(),
        .err_found_out(err_found),
        .corrected(corrected),
        .ready(corr_ready),
        .errors()
    );
    
endmodule
