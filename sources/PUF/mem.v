`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.07.2020 20:04:23
// Design Name: 
// Module Name: mem
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


module mem #(
    parameter ADDR_SZ = 8,
    parameter DATA_SZ = 264
    )(
    input clk,
    input write_en,
    input [ADDR_SZ-1:0] addr,
    input [DATA_SZ-1:0] data_in,
    output reg [DATA_SZ-1:0] data_out
    );
    
    reg [DATA_SZ-1:0] data [ADDR_SZ-1:0];
    //reg [ADDR_SZ-1:0] addr_reg;
    
    always @(posedge clk) begin
        data_out <= data[addr];
        if (write_en)
            data[addr] <= data_in;
    end
    
endmodule
