`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.07.2020 17:14:22
// Design Name: 
// Module Name: tb_super
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
/////////////////////////////////////////////////////////////////////////////////


module tb_super(
    );
    
    localparam BITS = 8;
    localparam T = 4;
    localparam DATA_BITS = 64;
    localparam PIPELINE_STAGES = 0;
    localparam N = 127;
    
    reg [BITS-1:0] data_in;
    reg clk;
    reg pre_start;
    wire start;
    reg ce;
    wire ready;
    wire [BITS-1:0] data_out;
    wire first;
    wire last;
    wire data_bits;
    wire ecc_bits;
    
    wire [BITS-1:0] err_out;
	wire first_out;
	
	reg [DATA_BITS-1:0] error;
    reg [BITS-1:0] corrected;
    reg [DATA_BITS-1:0] data;
    wire [DATA_BITS-1:0] errored = error ^ data;
  
    reg [3:0] state;
    parameter IDLE=0, STARTS=1;
    reg [2:0] counter;
    
    reg [N-1:0] codeword;
    
    initial begin
        clk = 0;
        pre_start = 0;
        data = 64'hCAFECAFECAFECAFE;
        error = 64'h0000050000001000;
        ce = 1;
        #23 pre_start = 1;
        #10 pre_start = 0;
    end
    
    always #5 clk = !clk;

    always @(posedge clk) begin
        if (first) begin
            corrected <= errored;
        end
        else if (first_out) begin
            corrected <= corrected ^ err_out; 
        end
        else corrected <= corrected;
    end
    
    buff #(DATA_BITS,BITS) B1 (
        .clk(clk),
        .start_in(pre_start),
        .b_in(data),
        .b_out(data_in),
        .start_out(start)
    );
  
    xilinx_encode #(T,DATA_BITS,BITS,PIPELINE_STAGES) encoder (
        .data_in(data_in),
        .clk_in(clk),
        .start(start),
        .ce(ce),
        .ready(ready),
        .data_out(data_out),
        .first(first),
        .last(last),
        .data_bits(data_bits),
        .ecc_bits(ecc_bits)
    );
/*
    buffer B2 #(DATA_BITS,BITS)(
        .clk(clk),
        .start_in(pre_start),
        .b_in(data),
        .b_out(data_in),
        .start_out(start)
    );
 */
    xilinx_decoder #(T,DATA_BITS,BITS,1,1,0,0,1) decoder (
        .data_in(errored),
        .clk_in(clk),
        .start_in(first),
        .err_out(err_out),
        .first_out(first_out)
    );
        
    endmodule
