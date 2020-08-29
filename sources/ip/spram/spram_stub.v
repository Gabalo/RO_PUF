// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Sat Aug 15 13:55:12 2020
// Host        : LAPTOP-UV9LLSN7 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/gabji/Documents/Universitat/Project/PUF_test/PUF_test.srcs/sources_1/ip/spram/spram_stub.v
// Design      : spram
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_13,Vivado 2019.2" *)
module spram(a, d, clk, we, spo)
/* synthesis syn_black_box black_box_pad_pin="a[7:0],d[263:0],clk,we,spo[263:0]" */;
  input [7:0]a;
  input [263:0]d;
  input clk;
  input we;
  output [263:0]spo;
endmodule
