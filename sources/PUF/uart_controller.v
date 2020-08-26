`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2020 12:42:55 PM
// Design Name: 
// Module Name: uart_controller
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


module uart_controller(
    input clk,
    input reset,
    input [7:0] rx_byte,
    input rx_DV,
    input [255:0] response,
    input response_DV,
    input uart_done,
    input mem_we,
    output reg [7:0] challenge,
    output reg [7:0] tx_byte,
    output reg tx_DV,
    output reg done,
    output reg start,
    output reg [263:0] mem_data,
	/////////////////////////////
	input [255:0] second,
    input second_en  
	
    );
    
    // FSM State variables
    reg [3:0] state;
    parameter SLEEP=4'd0, SENDC=4'd1, SENDR=4'd2, WAITC=4'd3, WAITR=4'd4, SENDC2=4'd5, WAITC2=4'd6, SENDS=4'd7, WAITS=4'd8, END=4'd9, IDLE=4'd10, RECV=4'd11, RECV_MEM=4'd12;
    
    // Counter 0 to 31
    reg [4:0] counter;
    reg [5:0] counter_wm;
    
    reg [263:0] write_data;
    
    // Temp register
    reg [255:0] temp_response;
	reg [255:0] temp_second;
    reg [7:0] temp_challenge ;
    
    always@(posedge clk) begin
        if (reset) begin
            state <=SLEEP;
            tx_byte <= 8'd0;
            tx_DV <= 1'b0;
            done <= 1'b0;
            counter <= 5'b0;
            temp_response <= 256'b0;
            counter_wm <= 6'b0;
            challenge <= 8'b0;
        end
        else begin
            case (state)
                SLEEP: begin
                    tx_byte <= 8'd0;
                    tx_DV <= 1'b0;
                    done <= 1'b0;
                    if (rx_DV) begin
                        state <= IDLE;
                        temp_challenge <= rx_byte;
                        challenge <= rx_byte;
                        start <= 1'b1;
                    end else begin
                        state <= SLEEP;
                        temp_challenge <= 8'b0;
                        start <= 1'b0;
                    end
                end
                IDLE:   begin
                    tx_DV <= 1'b0;
                    counter <= 5'b0;
                    counter_wm <= 6'b0;
                    done <= 1'b0;
                    start <= 1'b0;
                    if (mem_we) begin
                        if (rx_DV) begin
                            state <= RECV_MEM;
                            write_data[7:0] <= rx_byte;
                            counter_wm <= counter_wm + 1;
                        end else begin
                            state <= IDLE;
                            write_data <= 264'b0;
                        end
                    end
                    else begin
                        if (response_DV) begin
                            state <= SENDC;
                            temp_response <= response;
							temp_second <= second;
                        end else begin
                            state <= IDLE;
                            temp_response <= 256'd0;
                        end
                    end
                end
                SENDC: begin
                    state <= WAITC;
                    tx_byte <= temp_challenge;
                    tx_DV <= 1'b1;                        
                end
                WAITC: begin
                    tx_DV <= 1'b0;
                    if (uart_done) begin
                        state <= SENDR;
                    end else begin
                        state <= WAITC;
                    end
                end
                SENDR:  begin
                    state <= WAITR;
                    tx_byte <= temp_response[255:248];
                    temp_response <= {temp_response[247:0],8'd0};
                    tx_DV <= 1'b1;
                    counter <= counter + 1;
                end
                WAITR:  begin
                    tx_DV <= 1'b0;
                    if (uart_done) begin
                        if (counter == 5'b0)
							if (second_en)
								state <= SENDC2;
							else
								state <= END;
                        else
                            state <= SENDR;
                    end else begin
                        state <= WAITR;
                    end
                end
				SENDC2:	begin
                    state <= WAITC2;
                    tx_byte <= temp_challenge;
                    tx_DV <= 1'b1;                        
                end
                WAITC2: begin
                    tx_DV <= 1'b0;
                    if (uart_done) begin
                        state <= SENDS;
						counter <= 0;
                    end else begin
                        state <= WAITC2;
                    end
                end
				SENDS:  begin
                    state <= WAITS;
                    tx_byte <= temp_second[255:248];
                    temp_second <= {temp_second[247:0],8'd0};
                    tx_DV <= 1'b1;
                    counter <= counter + 1;
                end
                WAITS:  begin
                    tx_DV <= 1'b0;
                    if (uart_done) begin
                        if (counter == 5'b0)
							state <= END;
                        else
                            state <= SENDS;
                    end else begin
                        state <= WAITS;
                    end
                end
                END:    begin
                    state <= SLEEP;
                    done <= 1'b1;
                end
                //-----------------------------------
                RECV_MEM: begin
                    if (rx_DV) begin
                        counter_wm <= counter_wm + 1;
                        write_data <= {write_data[255:0],rx_byte};
                    end
                    if (counter_wm == 33) begin
                        mem_data <= write_data;
                        state <= SLEEP;
                        done <= 1'b1;
                    end else 
                        state <= RECV_MEM;            
                end
                //-----------------------------------
                default: begin
                    state <= SLEEP;
                    tx_byte <= 8'd0;
                    tx_DV <= 1'b0;
                    done <= 1'b0;
                    counter <= 5'b0;
                    temp_response <= 256'b0;
					temp_second <= 256'b0;
                    challenge <= 8'b0;
                end
            endcase
        end
    end
	
    
endmodule
