<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project implements a simple winner-take-all (WTA) circuit for four 2-bit inputs.
The 8-bit `ui_in` bus is split into four packed values:

- `ui_in[1:0]` = candidate 0
- `ui_in[3:2]` = candidate 1
- `ui_in[5:4]` = candidate 2
- `ui_in[7:6]` = candidate 3

The design compares the four candidates using a small compare tree (pairwise max, then final max) and outputs the winning 2-bit value on `uo_out[1:0]`. The output is registered on the rising edge of `clk`. `rst_n` is active-low and clears the output to `0`.

Unused outputs (`uo_out[7:2]`) are driven low. All bidirectional pins (`uio[*]`) are unused.

## How to test

Simulation (cocotb):

1. Install Python dependencies in the `test/` folder environment (including `cocotb`).
2. Run `make -C test`.
3. The cocotb test drives several `ui_in` patterns and checks that `uo_out[1:0]` matches the maximum of the four packed 2-bit candidates after a clock edge.

Manual behavior check example:

- If `ui_in = 8'b01_10_11_00`, the four candidates are `0, 3, 2, 1`, so the winner is `3` and `uo_out[1:0] = 2'b11`.

## External hardware

No external hardware is required. The design only uses Tiny Tapeout clock/reset and digital I/O pins.
