import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
    dut._log.info("Starting Safe Math Chip Test")

    # Start the clock (10us period)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Turn on the chip enable bit
    dut.ena.value = 1

    # Apply hardware reset
    dut._log.info("Resetting Chip...")
    dut.rst_n.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)

    # Test Case 1: Simple Addition (4 + 3 = 7)
    dut._log.info("Testing Addition: 4 + 3")
    dut.ui_in.value = 4   
    dut.uio_in.value = 3
    await ClockCycles(dut.clk, 2)
    assert int(dut.uo_out.value) == 7

    # Test Case 2: Simple Subtraction (10 - 4 = 6)
    # Bits [7:6] = 10 -> ui_in is 0x8A (1000_1010)
    dut._log.info("Testing Subtraction: 10 - 4")
    dut.ui_in.value = 0x8A   
    dut.uio_in.value = 4
    await ClockCycles(dut.clk, 2)
    assert int(dut.uo_out.value) == 6
