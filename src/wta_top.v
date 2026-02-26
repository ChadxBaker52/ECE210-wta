`default_nettype none

module wta_top (
    input  wire       clk,
    input  wire       rst,      // Active-high reset
    input  wire [7:0]  in,
    output wire [1:0] out
);
  reg [1:0] out_r;
  wire [1:0] x1,x2,x3,x4;
  wire [1:0] x12,x34;
  wire [1:0] x1234;

  assign x1 = in[1:0];
  assign x2 = in[3:2];
  assign x3 = in[5:4];
  assign x4 = in[7:6];

  assign x12 = (x2 > x1) ? x2 : x1;
  assign x34 = (x4 > x3) ? x4 : x3;
  assign x1234 = (x34 > x12) ? x34 : x12;

  always @(posedge clk) begin
    if (rst) begin
      out_r <= 2'd0;
    end else begin
      out_r <= x1234;
    end
  end

  assign out = out_r;

endmodule
