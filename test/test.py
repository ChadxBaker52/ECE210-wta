# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, FallingEdge, RisingEdge, ReadOnly


def expected_wta(value: int) -> int:
    x1 = (value >> 0) & 0b11
    x2 = (value >> 2) & 0b11
    x3 = (value >> 4) & 0b11
    x4 = (value >> 6) & 0b11
    return max(x1, x2, x3, x4)


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await FallingEdge(dut.clk)

    dut._log.info("Test WTA behavior")

    test_vectors = [
        0b00_00_00_00,
        0b01_10_11_00,
        0b11_10_01_00,
        0b10_10_10_10,
        0b00_01_10_11,
        0b11_11_00_01,
    ]

    for vector in test_vectors:
        dut.ui_in.value = vector
        dut.uio_in.value = 0
        await RisingEdge(dut.clk)
        # Gate-level simulations include propagation delays, so sample later in the cycle.
        await FallingEdge(dut.clk)
        await ReadOnly()

        expected = expected_wta(vector)
        observed = int(dut.uo_out.value) & 0b11
        assert observed == expected, (
            f"ui_in=0x{vector:02x}: expected max {expected}, got {observed}"
        )
        # Leave the read-only phase before the next iteration drives inputs.
        await RisingEdge(dut.clk)
