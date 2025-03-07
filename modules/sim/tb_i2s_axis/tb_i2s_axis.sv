`include "vunit_defines.svh"
`include "test_base.svh"
`include "test_reset.svh"

module tb_i2s_axis(
);
    bit tb_axis_clk;
    bit tb_i2s_sck;

    always #20 tb_axis_clk = !tb_axis_clk;
    always #200 tb_i2s_sck = !tb_i2s_sck;

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
        `TEST_CASE("test_reset") begin
            test_reset RstTest;
            RstTest = new("test_reset");
            RstTest.axis_vif = axis_tx_if;
            RstTest.i2s_vif = i2s_rx_if;
            RstTest.run();
        end
        end
endmodule
