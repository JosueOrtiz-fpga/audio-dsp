`include "vunit_defines.svh"
`include "test_base.svh"
`include "test_reset.svh"

`timescale 1ns/1ps

module tb_i2s_axis(
);
    bit tb_axis_clk;
    bit tb_i2s_sck;

    parameter AXIS_CLK_FREQ_MHZ = 25; // @ 25 MHZ in Master Mode, I2S2 PMOD MCLK/LRCK: 512
    parameter I2S_SCK_FREQ_MHZ = 25/8; // SCK/LRCLK is a constant 64 -> MCLK/SCK: 8
    
    localparam AXIS_CLK_PERIOD_NS = 1E3/AXIS_CLK_FREQ_MHZ;
    localparam I2S_SCK_PERIOD_NS = 1E3/I2S_SCK_FREQ_MHZ;
    
    always #(AXIS_CLK_PERIOD_NS/2) tb_axis_clk = !tb_axis_clk;
    always #(I2S_SCK_PERIOD_NS/2) tb_i2s_sck = !tb_i2s_sck;

    axis_if #(
    .DATA_WIDTH_BYTES(4)
    ) axis_tx_if ();

    i2s_if i2s_rx_if ();

    i2s_axis i2s_axis_inst (
        .taxis(axis_tx_if.transmitter),
        .rx_i2s(i2s_rx_if.receiver)
    );

    assign axis_tx_if.aclk = tb_axis_clk;
    assign i2s_rx_if.sck = tb_i2s_sck;

    `TEST_SUITE begin
        `TEST_SUITE_SETUP begin
            $timeformat(-9,2,"ns");
        end
        `TEST_CASE("test_reset") begin
            test_reset RstTest;
            RstTest = new("test_reset");
            RstTest.axis_vif = axis_tx_if;
            RstTest.i2s_vif = i2s_rx_if;
            RstTest.run();
        end
        end
endmodule
