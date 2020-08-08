`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2020 09:30:14 PM
// Design Name: 
// Module Name: control
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


module control(
    input clk,
    input start,
    input [7:0] refcount,
    output reg  lfsrDV, countEN, refEN, lfsrEN, srEN, roEN, countReset, done
    );
    
    reg [2:0] state;
    reg [7:0] bitscount;
    
    parameter IDLE=3'b000, DVALID=3'b001, INNER=3'b010, PRE=3'b011, OUTER=3'b100, TEMP=3'b101;
    
    always@(posedge clk) begin  
        case(state)
            IDLE: begin
                done <= 1'b0;
                bitscount <= 8'b0;
                if (!start)
                    state <= IDLE;
                else
                    state <= DVALID;
            end
            DVALID: state <= INNER;
            INNER: begin
                if (refcount == 8'hFF)
                    state <= PRE;
                else 
                    state <= INNER;
            end
            PRE: begin
                state <= OUTER;
            end
            OUTER: begin
                bitscount <= bitscount + 1;
                if (bitscount == 8'hFF) begin
                    state <= TEMP;
                    done <= 1'b1;
                end else begin 
                    state <= INNER;
                    done <= 1'b0;
                end            
            end
            TEMP: begin
                done <= 1'b0;
                if (start)
                    state <= TEMP;
                else
                    state <= IDLE;
            end
            default: begin
                state <= IDLE;
                bitscount <= 8'b0;
                done <= 1'b0;
            end
        endcase
    end

    always@(*) begin 
        case(state)
            IDLE: begin
                lfsrDV <= 1'b0;
                countEN <= 1'b0;
                refEN <= 1'b0;
                lfsrEN <= 1'b0;
                srEN <= 1'b0;
                roEN <= 1'b0;
                countReset <= 1'b1;
            end
            DVALID: begin
                lfsrDV <= 1'b1;
                countEN <= 1'b0;
                refEN <= 1'b0;
                lfsrEN <= 1'b1;
                srEN <= 1'b0;
                roEN <= 1'b0;
                countReset <= 1'b1;
            end
            INNER: begin
                lfsrDV <= 1'b0;
                countEN <= 1'b1;
                refEN <= 1'b1;
                lfsrEN <= 1'b0;
                srEN <= 1'b0;
                roEN <= 1'b1;
                countReset <= 1'b0;
            end 
            PRE: begin
                lfsrDV <= 1'b0;
                countEN <= 1'b1;
                refEN <= 1'b0;
                lfsrEN <= 1'b1;
                srEN <= 1'b1;
                roEN <= 1'b0;
                countReset <= 1'b0;
            end
            OUTER: begin
                lfsrDV <= 1'b0;
                countEN <= 1'b1;
                refEN <= 1'b0;
                lfsrEN <= 1'b0;
                srEN <= 1'b0;
                roEN <= 1'b0;
                countReset <= 1'b1;
            end
            default: begin
                lfsrDV <= 1'b0;
                countEN <= 1'b0;
                refEN <= 1'b0;
                lfsrEN <= 1'b0;
                srEN <= 1'b0;
                roEN <= 1'b0;
                countReset <= 1'b1;
            end
        endcase
    end
endmodule
