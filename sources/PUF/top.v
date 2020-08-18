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
    input SW0,
    input SW1,
    input UART_RXD,
    output UART_TXD,
    output [15:0] LED,
    output LED16_B,
    output LED16_R,
    output LED16_G,
    output reg LED17_R,
    output LED17_G
    );
    
    wire start;
    wire reset;
    wire CLK10MHZ;
    wire uart_done, tx_DV, rx_DV;
    wire [7:0] tx_byte;
    wire [7:0] rx_byte;
    
    wire [7:0] challenge;
    wire [255:0] response;
    wire [255:0] send_response;
    wire [263:0] corrected;
	wire [263:0] err_found;
    wire corr_ready;
    
    wire [263:0] RplusC;
    wire [263:0] mem_data;
    
    wire pulse;
    wire response_DV;
    wire PUF_done;
    wire cntrl_done;
    
    wire sha_ready;
    wire sha_digest_valid;
    wire sha_init;
    wire [255:0] sha_digest;
    wire [255:0] sha_block;
    
    assign reset = !CPU_RESETN;
    
    assign response_DV = SW0 ? sha_digest_valid : PUF_done ;
    assign send_response = SW0 ? corrected : response;
    
    PUF MyPUF(
        .clk(CLK10MHZ),
        .start(start & !SW1),
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
        .led(LED16_G),
        .mem_we(SW1),
        .mem_data(mem_data),
        .second(sha_digest),
        .second_en(SW0)
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
        
    //pulse_scaler MyPS(
    //    .clk(CLK100MHZ),
    //    .in(pulse),
    //    .out(response_DV)      );
        
    //pulse_scaler MyPS2(
    //    .clk(CLK100MHZ),
    //    .in(corr_ready),
    //    .out(sha_init)      );

    /*
    (*DONT_TOUCH = "yes"*)
    mem MyMEM (
        .clk(CLK10MHZ),
        .write_en(cntrl_done & SW1),
        .addr(challenge),
        .data_in(mem_data),
        .data_out(RplusC)
    );
    */
    
    spram MyRAM(
        .clk(CLK10MHZ),
        .a(challenge),
        .d(mem_data),
        .we(cntrl_done & SW1),
        .spo(RplusC)
    );
    
    err_correction MyEC (
        .clk(CLK10MHZ),
        .start(PUF_done),
        .RplusC(RplusC),
        .response({8'b0,response}),
        .leds(LED),
        .corrected(corrected),
		.err_found_out(err_found),
        .ready(corr_ready),
        .errors(LED17_G)
    );
     
    sha256_core core(
       .clk(CLK10MHZ),
       .reset_n(CPU_RESETN),
       .init(corr_ready),
       .next(),
       .mode(1'b1),    
       .block({256'b0,corrected[255:0]}),
       .ready(sha_ready),
       .digest(sha_digest),
       .digest_valid(sha_digest_valid)
  );
       
   assign LED16_B = SW0;
   assign LED16_R = SW1;
   
   always @(*) begin
        if (RplusC == 0)
            LED17_R = 1'b1;
        else
            LED17_R = 1'b0;
    end

endmodule
