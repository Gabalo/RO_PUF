`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.07.2020 21:41:38
// Design Name: 
// Module Name: encoder_tb
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


module encoder_tb #(
	parameter OPTION = "SERIAL",
	parameter BITS = 64,
	parameter REG_RATIO = 1
	);

    `include "bch_params.vh"

    localparam T = 8;
    localparam [`BCH_PARAM_SZ-1:0] P = bch_params(BITS, T);
	
	localparam M = `BCH_M(P);
    localparam N = `BCH_N(P);
    localparam K = `BCH_K(P);
    localparam Te = `BCH_T(P);
    localparam DB = `BCH_DATA_BITS(P);
	localparam EB = `BCH_ECC_BITS(P);

	reg clk;

    // ENCODER +
	reg start;
	reg encode_ce;
	reg [BITS-1:0] encoder_in;	
	wire [BITS-1:0] encoder_out;
	wire data_bits;
	wire ecc_bits;
	wire encoded_first;
	wire encoded_last;
	wire encode_ready;
	// ENCODER -
	
	// BLANK ECC +
	reg blank_start;
	wire [BITS-1:0] xor_out;
    // BLANK ECC -
    
    // ERRORS PRESENT +
    wire errors_present;
    wire errors_present_done;
    // ERRORS PRESENT -
    
    // KEY SOLVER +
    wire ch_start;
    wire [`BCH_SIGMA_SZ(P)-1:0] sigma;
    wire err_count;
    wire key_ready;
    wire [BITS-1:0] err;
    wire [BITS-1:0] err1;
	wire err_first1;
	wire err_last;
    wire err_valid;
    // KEY SOLVER -
    
    initial begin
        clk = 1'b0;
        start = 1'b0;
        encode_ce = 1'b1;
        encoder_in = 5'd3;
        #10 start = 1'b1;
        #10 start = 1'b0;
    end
    
    always #5 clk = !clk;
    
    always @(posedge clk) 
        if (encode_ce)
            blank_start <= #1 ecc_bits;
    
    bch_encode #(P, BITS) u_bch_encode(
        .clk(clk),
        .start(start),
        .ce(encode_ce),
        .data_in(encoder_in),
        .data_out(encoder_out),
        .data_bits(data_bits),
        .ecc_bits(ecc_bits),
        .first(encoded_first),
        .last(encoded_last),
        .ready(encode_ready)
    );
    
    bch_blank_ecc #(P, BITS) u_encode_blank(
        .clk(clk),
        .start(!blank_start && ecc_bits),
        .ce(encode_ce),
        .xor_out(xor_out),
        .first(),
        .last()
    );
    
    /* Don't assert start until we get the ready signal */
    wire syndrome_ready;
    wire syn_done;
    wire syndrome_start = encoded_first && syndrome_ready;
    /* Keep adding data until the next stage is busy */
    wire syndrome_ce = !syn_done || key_ready;
    wire syndrome_accepted = syndrome_start && syndrome_ce;
    wire [`BCH_SYNDROMES_SZ(P)-1:0] syndromes;
    
    bch_syndrome #(P, BITS, REG_RATIO) u_bch_syndrome(
        .clk(clk),
        .start(syndrome_start),
        .ready(syndrome_ready),
        .ce(syndrome_ce),
        .data_in(encoder_out),
        .syndromes(syndromes),
        .done(syn_done)
    );
    
    /* Test for errors */
    
    bch_errors_present #(P) u_errors(
        .clk(clk),
        .start(syn_done && key_ready),
        .syndromes(syndromes),
        .done(errors_present_done),
        .errors_present(errors_present)
    );
    
    if (T > 1 && (OPTION == "SERIAL" || OPTION == "PARALLEL" || OPTION == "NOINV")) begin : TMEC 
        /* Solve key equation */
        if (OPTION == "SERIAL") begin : BMA_SERIAL
            bch_sigma_bma_serial #(P) u_bma (
                .clk(clk),
                .start(syn_done && key_ready),
                .ready(key_ready),
                .syndromes(syndromes),
                .sigma(sigma),
                .done(ch_start),
                .ack_done(1'b1),
                .err_count(err_count)
            );
        end
       
        /* Locate errors */
        bch_error_tmec #(P, BITS, REG_RATIO) u_error_tmec(
            .clk(clk),
            .start(ch_start),
            .sigma(sigma),
            .first(err_first),
            .err(err)
        );
    
        bch_error_one #(P, BITS) u_error_one(
            .clk(clk),
            .start(ch_start),
            .sigma(sigma[0+:2*M]),
            .first(err_first1),
            .err(err1)
        );
        
    end
     
     bch_chien_counter #(P, BITS) u_chien_counter(
        .clk(clk),
        .first(err_first),
        .last(err_last),
        .valid(err_valid)
    );
        
endmodule
