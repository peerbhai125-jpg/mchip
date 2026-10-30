import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
    dut._log.info("Starting Math Chip Test")

    # Start the clock (10us period)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Apply hardware reset
    dut._log.info("Resetting Chip...")
    dut.rst_n.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 1)

    # Test Case 1: Addition (ui_in[7:6] = 00)
    # A = 12 (0x0C), B = 5 (0x05). Top bits [7:6] = 00 -> Total ui_in = 0x0C
    dut._log.info("Testing Addition: 12 + 5")
    dut.ui_in.value = 0x0C   # 0000_1100 (Bits 7:6 are 00, lower bits are 12)
    dut.uio_in.value = 5
    await ClockCycles(dut.clk, 2)
    assert dut.uo_out.value == 17

    # Test Case 2: Subtraction (ui_in[7:6] = 10)
    # A = 20 (0x14), B = 7 (0x07). Top bits [7:6] = 10 -> Total ui_in = 0x94 (1001_0100)
    dut._log.info("Testing Subtraction: 20 - 7")
    dut.ui_in.value = 0x94   
    dut.uio_in.value = 7
    await ClockCycles(dut.clk, 2)
    assert dut.uo_out.value == 13

    dut._log.info("All math operations passed successfully!")
