`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2020 12:33:33 PM
// Design Name: 
// Module Name: top
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


module top(
    input CLK100MHZ,
    //input START,
    input CPU_RESETN,
    input [1:0] SW,
    input UART_RXD,
    output UART_TXD,
    output [1:0] LED,
    output reg LED17_R
    );
    
    wire start;
    wire reset;
    wire CLK10MHZ;
    wire uart_done, tx_DV, rx_DV;
    wire [7:0] tx_byte;
    wire [7:0] rx_byte;
    
    wire [7:0] challenge;
    wire [255:0] response;
    reg [255:0] send_response;
    wire [263:0] corrected;
    wire corr_ready;
    
    wire [263:0] RplusC;
    wire [263:0] mem_data;
    
    wire pulse;
    reg response_DV;
    wire PUF_done;
    wire cntrl_done;
    
    wire sha_ready;
    wire sha_digest_valid;
    wire sha_init;
    reg sha_reset;
    wire [255:0] sha_digest;
    wire [255:0] sha_block;
    
    assign reset = !CPU_RESETN;
    
    always@* begin
        case(SW[1:0])
            2'b00: begin
                response_DV = PUF_done;
                send_response = response; 
            end
            2'b01: begin
                response_DV = corr_ready;
                send_response = corrected; 
            end
            2'b10: begin
                response_DV = sha_digest_valid;
                send_response = sha_digest; 
            end
            2'b11: begin
                response_DV = 0;
                send_response = 0; 
            end
            default: begin
                response_DV = 0;
                send_response = 0; 
            end
        endcase
    end

    PUF MyPUF(
        .clk(CLK10MHZ),
        .start(start & !(SW[0]&SW[1])),
        .challenge(challenge),
        .response(response),
        .done(PUF_done)     );
        
    uart_controller MyCNTRL(
        .clk(CLK10MHZ),
        .reset(reset),
        .rx_byte(rx_byte),
        .rx_DV(rx_DV),
        .response(send_response),
        .response_DV(response_DV),
        .uart_done(uart_done),
        .challenge(challenge),
        .tx_byte(tx_byte),
        .tx_DV(tx_DV),
        .done(cntrl_done),
        .start(start),
        .mem_we(SW[0]&SW[1]),
        .mem_data(mem_data),
        .second(),
        .second_en(1'b0)
        );
        
    uart_tx MyTX(
        .i_Clock(CLK10MHZ),
        .i_Tx_DV(tx_DV),
        .i_Tx_Byte(tx_byte), 
        .o_Tx_Active(),
        .o_Tx_Serial(UART_TXD),
        .o_Tx_Done(uart_done)    );
        
    uart_rx MyRX(
        .i_Clock(CLK10MHZ),
        .i_Rx_Serial(UART_RXD),
        .o_Rx_DV(rx_DV),
        .o_Rx_Byte(rx_byte)
    );
    
    clk_wiz MyCLK(
        .clk_in1(CLK100MHZ),
        .clk_out1(CLK10MHZ)
    );
    
    spram MyRAM(
        .clk(CLK10MHZ),
        .a(challenge),
        .d(mem_data),
        .we(cntrl_done & SW[1]),
        .spo(RplusC)
    );
    
    err_correction MyEC (
        .clk(CLK10MHZ),
        .start(PUF_done),
        .RplusC(RplusC),
        .response({8'b0,response}),
        .corrected(corrected),
        .ready(corr_ready)
    );
     
    sha256_core core(
       .clk(CLK10MHZ),
       .reset_n(CPU_RESETN & sha_reset),
       .init(corr_ready),
       .next(),
       .mode(1'b1),    
       .block({256'b0,corrected[255:0]}),
       .ready(sha_ready),
       .digest(sha_digest),
       .digest_valid(sha_digest_valid)
  );
  
    always@(posedge CLK10MHZ)
        sha_reset <= !sha_digest_valid;
       
   assign LED[0] = SW[0];
   assign LED[1] = SW[1];
   
   always @(*) begin
        if (RplusC == 0)
            LED17_R = 1'b1;
        else
            LED17_R = 1'b0;
    end

endmodule
