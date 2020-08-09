`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.07.2020 14:06:34
// Design Name: 
// Module Name: tb_hash
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


module tb_hash;
  
    reg clk;
    reg reset_n;
    reg init_reg;
    reg mode_reg;
    reg [511:0] core_block;
    wire core_ready;
    wire [255:0] core_digest;
    wire core_digest_valid;

    localparam MODE_SHA_256   = 1'h1;
    
    reg [255:0] response;
    
    initial begin
        response = 256'hCAFECAFECAFECAFECAFECAFECAFECAFECAFECAFECAFECAFECAFECAFECAFECAFE;
        clk = 0;
        mode_reg = MODE_SHA_256;
        reset_n = 1;
        #12 reset_n = 0;
        #22 reset_n = 1;
        #12 init_reg = 0;
        #22 init_reg = 1;
    end
    
    always #5 clk = !clk;    
    
    sha256_core core(
       .clk(clk),
       .reset_n(reset_n),
    
       .init(init_reg),
       .next(),
       .mode(mode_reg),
    
       .block({256'b0,response}),
    
       .ready(core_ready),
    
       .digest(core_digest),
       .digest_valid(core_digest_valid)
      );
    
    
    endmodule
