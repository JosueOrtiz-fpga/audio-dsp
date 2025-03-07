
`include "../common/axis_if.svh"
`include "../common/i2s_if.svh"

module i2s_axis#() (
    axis_if.transmitter taxis,
    i2s_if.receiver rx_i2s

);
    localparam MAX_BIT_DETPH = 24;

    enum {E_IDLE, E_DES_CH0, E_DES_CH1} i2s_rx_state;

    logic [MAX_BIT_DETPH-1:0] i2s_d_reg0, i2s_d_reg1;
    logic i2s_ws_d;
    logic[2:0] i2s_rstn_sync;
    logic i2s_sample_valid;

    // I2S internal reset
    always_ff @(posedge rx_i2s.sck) begin
        i2s_rstn_sync <= {i2s_rstn_sync[1:0], taxis.aresetn};
    end

    // De-serialize I2S data
    always_ff @(posedge rx_i2s.sck) begin
        if(!i2s_rstn_sync[2]) begin
            i2s_rx_state <= E_IDLE;
            i2s_ws_d <= 1'b0;
            i2s_sample_valid <= 1'b0;
        end else begin
            case (i2s_rx_state)
                E_IDLE : begin
                    i2s_ws_d <= rx_i2s.ws;
                    // synchronize the start of deserializing to I2S Channel 0 (Left)
                    if(i2s_ws_d && !rx_i2s.ws) i2s_rx_state <= E_DES_CH0;
                end
                E_DES_CH0 : begin
                    i2s_d_reg0 <= {i2s_d_reg0[MAX_BIT_DETPH-2:0], rx_i2s.d};
                    if (rx_i2s.ws) i2s_rx_state <= E_DES_CH1;
                end
                E_DES_CH1 : begin
                    i2s_d_reg1 <= {i2s_d_reg1[MAX_BIT_DETPH-2:0], rx_i2s.d};
                    if (!rx_i2s.ws) begin 
                        i2s_rx_state <= E_DES_CH0;
                        // signal 'valid' after collecting CH0 and CH1 sample
                        i2s_sample_valid <= 1'b1;
                    end
                end
                default : i2s_rx_state <= E_IDLE;
            endcase
        end
    end

    // !!! Handle CDC from rx_i2s.sck to taxis.aclk
    // !!! Transmit axis packet

endmodule : i2s_axis
