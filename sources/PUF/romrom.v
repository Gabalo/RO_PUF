`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.07.2020 20:56:14
// Design Name: 
// Module Name: romrom
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


module romrom (addr, data);
    
    localparam ADDR_SZ=8;
    localparam DATA_SZ=264;

    input [ADDR_SZ-1:0] addr;
    output reg [DATA_SZ-1:0] data;
    
    always @(addr) begin
        case (addr)
            8'h13: data = 264'h12b93ccafe3a24920599e4ce35582cafe443a917206f5759a01b061d81fe1a89af;
            8'h2A: data = 264'h12be4a32e7d1cb0a4c9e2079cc4d07a1d65909ada681bd2da5f517e4d326fbc10f;
            8'h95: data = 264'h12b93d54f23acafe0599e4ce3558238b1443a917206f5759acafe61d81fe1a89af;
            default: data = 264'h12be4a32e7d1cb0a4c9e2079cc4d07a1d65909ada681bd2da5f517e4d326fbc10f;
        endcase
    end
endmodule
