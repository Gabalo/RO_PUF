`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.07.2020 20:44:06
// Design Name: 
// Module Name: ec
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


module err_correction (clk,start,RplusC,response,corrected,ready
    );
    
    localparam DATA_BITS = 192;
    localparam BITS = 8;
    localparam T = 8;
    localparam N = 264;
    
    input clk;
    input start;
    input [N-1:0] RplusC;
    input [N-1:0] response;
    output [N-1:0] corrected;
    output ready;
    
    wire [N-1:0] EplusC;
    
    wire [BITS-1:0] dec_in;
    wire dec_start;
    wire [BITS-1:0] err_out;
    wire first_out;
    wire [N-1:0] err_found;
    wire err_ready;
    
    reg [N-1:0] reg_response;
    reg [N-1:0] reg_RplusC;
    reg buff_start;
    
     always @(posedge clk) begin
        buff_start <= start;
        if (start) begin
            reg_response <= response;
            reg_RplusC <= RplusC;
        end
    end
            
    assign EplusC = reg_RplusC ^ reg_response;
    
    buff #(N,BITS) buff_dec_in (
        .clk(clk),
        .start_in(buff_start),
        .b_in(EplusC),
        .b_out(dec_in),
        .start_out(dec_start)
    );

    xilinx_decoder #(T,DATA_BITS,BITS,1,1,0,0,1) decoder (
        .data_in(dec_in),
        .clk_in(clk),
        .start_in(dec_start),
        .err_out(err_out),
        .first_out(first_out)
    );
    
    fifo #(BITS,N) fill_err (
        .clk(clk),
        .start(first_out),
        .data_in(err_out),
        .data_out(err_found),
        .ready(ready)
    );
    
    assign corrected = reg_response ^ err_found;
	 
endmodule
