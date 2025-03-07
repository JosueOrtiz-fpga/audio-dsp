`include "vunit_defines.svh"

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
        `TEST_CASE("reset_check") begin
            axis_tx_if.aresetn <= 1'b0;
            @(posedge tb_i2s_sck);
            @(posedge tb_i2s_sck);
            @(posedge tb_i2s_sck);
        end
        end
endmodule
