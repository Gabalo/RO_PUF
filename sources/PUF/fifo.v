`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.07.2020 16:21:16
// Design Name: 
// Module Name: fifo
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


module fifo #(
    parameter SZ_IN = 8,
    parameter SZ_OUT = 264
    )(
    input clk,
    input start,
    input [SZ_IN-1:0] data_in,
    output reg [SZ_OUT-1:0] data_out,
    output reg ready
    );
    
    localparam COUNT = SZ_OUT/SZ_IN;
    
    reg [3:0] state;
    localparam IDLE=0, STARTS=1;

    reg [7:0] counter;
    reg [SZ_OUT-1:0] temp;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                counter <= 0;
                ready <= 0;
                if (start) begin
                    state <= STARTS;
                    temp <= {temp[SZ_OUT-1-SZ_IN:0],data_in};
                end else
                    state <= IDLE;
            end
            STARTS: begin
                counter <= counter + 1'b1;
                    temp <= {temp[SZ_OUT-1-SZ_IN:0],data_in};
                if (counter == COUNT-1) begin
                    state <= IDLE;
                    data_out <= temp;
                    ready <= 1'b1;
                end else
                    state <= STARTS;
            end
            default: begin
                counter <= 0;
                temp <= 0;
                state <= IDLE;
                ready <= 1'b0;
            end
        endcase
    end
    
endmodule
