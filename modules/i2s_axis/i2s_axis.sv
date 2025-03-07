
`include "../common/axis_if.svh"
`include "../common/i2s_if.svh"

module i2s_axis#(P_MCLK_SCLK_RATIO, P_MCLK_LCLK_RATIO) (
    axis_if.transmitter taxis,
    i2s_if.receiver rx_i2s

) ;

endmodule : i2s_axis
