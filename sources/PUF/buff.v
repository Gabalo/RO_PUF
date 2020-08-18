`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11.07.2020 20:52:55
// Design Name:
// Module Name: buffer
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


module buff #(
    parameter DATA_BITS = 264,
    parameter BITS = 8
    )(
    input clk,
    input start_in,
    input [DATA_BITS-1:0] b_in,
    output reg start_out,
    output  [BITS-1:0] b_out
    );

    reg [3:0] state;
    localparam IDLE=0, STARTS=1;
    localparam COUNT = DATA_BITS/BITS;
    
    reg [7:0] counter;
    reg [DATA_BITS-1:0] temp;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                counter <= 0;
                start_out <= 0;
                if (start_in) begin
                    state <= STARTS;
                    start_out <= 1'b1;
                    temp <= b_in;
                end else
                    state <= IDLE;
            end
            STARTS: begin
                start_out <= 0;
                counter <= counter + 1'b1;
                temp <= temp << 8;
                if (counter == COUNT-1)
                    state <= IDLE;
                else
                    state <= STARTS;
            end
            default: begin
                counter <= 0;
                start_out <= 0;
                temp <= 0;
                state <= IDLE;
            end
        endcase
    end

    assign b_out = temp[DATA_BITS-1:DATA_BITS-BITS];

endmodule
