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
    wire corr_ready;
    
    initial begin
        challenge = 8'h2A;
        response = 256'h26f085408400280228055a740ba640011740016f403577a8b17fa085400ac185;
        RplusC = 264'h1212a6fdda38ded8101c5322eeb778b013231679f5fceb86c751c0ce8b21e13cd1;
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
        .corrected(corrected),
        .ready(corr_ready),
        .errors()
    );
    
endmodule
