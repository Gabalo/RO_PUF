# RO_PUF
 Ring Oscillator Physically Unclonable Funtion for Secure Key Generation

This code has been tested in a Xilinx Artix-7 FPGA.

- sources/ includes the source code for the PUF, UART tx/rx, Error Correction module, and Hash function.
- Matlab/ includes Matlab scripts for receiving data from the FPGA.
- python/ includes scripts for calculated metrics on said data.

This is an example codeword from the BCH encoder, useful to generate helper data: 
- 123456789abcdef0123456789abcdef0123456789abcdef16fe0bf6e0e61ebfd51

The BCH module used here is from Russ Dill's project [https://github.com/russdill/bch_verilog].
