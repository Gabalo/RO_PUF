`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2020 03:48:21 PM
// Design Name: 
// Module Name: uart_tb
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


module uart_tb();
    
    reg clk, reset;
    reg [255:0] response;
    reg response_DV;
    
    wire uart_done, uart_DV;
    wire [7:0] uart_byte;
    wire done, TX, tx_active;
    
    always begin
        #5 clk = !clk;
    end
    
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        #10 reset = 1'b0;
        #10 response = 256'hCAFE1234CAFE1234CAFE1234CAFE1234;
        response_DV = 1'b1;
        #10 response_DV = 1'b0; 
    end
    
    uart_controller MyCNTRL(
        .clk(clk),
        .reset(reset),
        .response(response),
        .response_DV(response_DV),
        .uart_done(uart_done),
        .uart_byte(uart_byte),
        .uart_DV(uart_DV),
        .done(done)         );
        
    uart #(5) MyUART(
        .i_Clock(clk),
        .i_Tx_DV(uart_DV),
        .i_Tx_Byte(uart_byte), 
        .o_Tx_Active(tx_active),
        .o_Tx_Serial(TX),
        .o_Tx_Done(uart_done)    );

endmodule
