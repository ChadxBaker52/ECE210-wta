`default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

  // Dump the signals to a FST file. You can view it with gtkwave or surfer.
  initial begin
    $dumpfile("tb.fst");
    $dumpvars(0, tb);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;
  // Map the Tiny Tapeout-style cocotb signals to the local WTA module ports.
  wire [1:0] wta_out;
  wire       rst = ~rst_n;  // cocotb drives active-low reset, DUT expects active-high

  wta_top user_project (
      .clk(clk),
      .rst(rst),
      .in (ui_in),
      .out(wta_out)
  );

  // Expose DUT output on the expected cocotb-visible bus (LSBs only).
  assign uo_out  = {6'b0, wta_out};
  assign uio_out = 8'b0;
  assign uio_oe  = 8'b0;

  // Unused wrapper-only inputs.
  wire _unused = &{ena, uio_in, 1'b0};

endmodule
