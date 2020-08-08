`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2020 05:49:05 PM
// Design Name: 
// Module Name: pulse_scaler
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


module pulse_scaler #(parameter SCALE=10)(
    input clk,
    input in,
    output reg out
    );
    
    reg [7:0] counter;
    reg [2:0] state;
    localparam START=3'd0, HIGH=3'd1;
    
    always@(posedge clk) begin
        case(state)
            START: begin
                counter <= 8'd0;
                if (in) begin
                    state <= HIGH;
                    out <= 1'b1;
                end else begin
                    state <= START;
                    out <= 1'b0;
                end
            end
            HIGH: begin
                out <= 1'b1;
                counter <= counter + 1;
                if (counter == SCALE) begin
                    state <= START;
                    out <= 1'b0;
                end else begin
                    state <= HIGH;
                    out <= 1'b1;
                end
            end
        endcase
    end
endmodule
