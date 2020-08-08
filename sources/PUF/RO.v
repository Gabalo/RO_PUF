`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2020 06:32:14 PM
// Design Name: 
// Module Name: RO
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


module RO (
    input en,
    input [3:0] c,  
    output o
    );
    
    //DELAY FOR SIMULATION
    wire #(1) t0;
    wire #(1) t1;
    wire #(1) t2;
    wire #(1) t3;

    //SIMULATION 
    /*
    reg temp;
    wire tt;
    initial begin
        temp = 0;
        #15 temp = 1; 
    end
*/

    // LUT6_L: 6-input Look-Up Table with local output
    LUT6_L #(
     .INIT(64'h8888888888888888) // NAND - O = I0 & I1
    ) LUT6_NAND0 (
     .LO(t0), 
     .I0(en), 
     .I1(t3),
     //.I1(tt), 
     .I2(c[0]), 
     .I3(1'b0), 
     .I4(1'b0), 
     .I5(1'b0) 
    );
    
    // LUT6_L: 6-input Look-Up Table with local output
    LUT6_L #(
     .INIT(64'h5555555555555555) // INV - O = ~I0
    ) LUT6_INV0 (
     .LO(t1), 
     .I0(t0), 
     .I1(c[1]), 
     .I2(1'b0), 
     .I3(1'b0), 
     .I4(1'b0), 
     .I5(1'b0) 
    );

    // LUT6_L: 6-input Look-Up Table with local output
    LUT6_L #(
     .INIT(64'h5555555555555555) // INV - O = ~I0
    ) LUT6_INV1 (
     .LO(t2), 
     .I0(t1), 
     .I1(c[2]), 
     .I2(1'b0), 
     .I3(1'b0), 
     .I4(1'b0), 
     .I5(1'b0) 
    );
    
    // LUT6_L: 6-input Look-Up Table with local output
    LUT6_L #(
     .INIT(64'h5555555555555555) // INV - O = ~I0
    ) LUT6_INV2 (
     .LO(t3), 
     .I0(t2), 
     .I1(c[3]), 
     .I2(1'b0), 
     .I3(1'b0), 
     .I4(1'b0), 
     .I5(1'b0) 
    );
    
    //SIMULATION
    //assign tt = t3 && temp;
    assign o = t3;
    
endmodule
