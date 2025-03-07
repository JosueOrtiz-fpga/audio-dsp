
`include "../common/axis_if.svh"
`include "../common/i2s_if.svh"

module i2s_axis#() (
    axis_if.transmitter taxis,
    i2s_if.receiver rx_i2s

);
    localparam MAX_BIT_DETPH = 24;

    enum {E_IDLE, E_DES_CH0, E_DES_CH1} i2s_rx_state;
    enum {E_WAIT, E_TX0, E_TX1} axis_tx_state;

    logic [MAX_BIT_DETPH-1:0] i2s_d_reg0_sck, i2s_d_reg1_sck;
    logic i2s_ws_d_sck;

    // value initialized here to ensure a reset gets applied by default
    // even if rx_i2s.sck comes alive after taxis.aresetn has been asserted
    // and deasserted
    logic[1:0] i2s_aresetn_sync = 2'b00;

    logic i2s_reg0_valid_sck;
    logic i2s_reg1_valid_sck;

    logic sample_valid_sck;

    logic [1:0] sample_valid_sync;

    assign sample_valid_sck = i2s_reg0_valid_sck || i2s_reg1_valid_sck;

    // I2S internal reset
    // aresetn needs to be asserted for a minum of 2 sck cycles
    always_ff @(posedge rx_i2s.sck) begin
        i2s_aresetn_sync <= {i2s_aresetn_sync[0], taxis.aresetn};
    end

    // De-serialize I2S data
    always_ff @(posedge rx_i2s.sck) begin
        if(!i2s_aresetn_sync[1]) begin
            i2s_rx_state <= E_IDLE;
            i2s_ws_d_sck <= 1'b0;
            i2s_reg0_valid_sck <= 1'b0;
            i2s_reg1_valid_sck <= 1'b0;
        end else begin
            case (i2s_rx_state)
                E_IDLE : begin
                    i2s_ws_d_sck <= rx_i2s.ws;
                    // synchronize the start of deserializing to I2S Channel 0 (Left)
                    if(i2s_ws_d_sck && !rx_i2s.ws) i2s_rx_state <= E_DES_CH0;
                end
                E_DES_CH0 : begin
                    i2s_reg1_valid_sck <= 1'b0;
                    i2s_d_reg0_sck <= {i2s_d_reg0_sck[MAX_BIT_DETPH-2:0], rx_i2s.d};
                    // a change in word-select signals a change in channel being serialized
                    if (rx_i2s.ws) begin
                        i2s_rx_state <= E_DES_CH1;
                        i2s_reg0_valid_sck <= 1'b1;
                    end
                end
                E_DES_CH1 : begin
                    i2s_reg0_valid_sck <= 1'b0;
                    i2s_d_reg1_sck <= {i2s_d_reg1_sck[MAX_BIT_DETPH-2:0], rx_i2s.d};
                    // a change in word-select signals a change in channel being serialized
                    if (!rx_i2s.ws) begin
                        i2s_rx_state <= E_DES_CH0;
                        i2s_reg1_valid_sck <= 1'b1;
                    end
                end
                default : i2s_rx_state <= E_IDLE;
            endcase
        end
    end

    // Handle CDC from rx_i2s.sck to taxis.aclk
    always_ff @(posedge taxis.aclk) begin
        if(!taxis.aresetn) begin
            sample_valid_sync <= '0;
        end else begin
            sample_valid_sync <= {sample_valid_sync[0],sample_valid_sck};
        end
    end

    // Transmit axis packet
    always_ff @(posedge taxis.aclk) begin
        if(!taxis.aresetn) begin
            taxis.tvalid <= 1'b0;
            taxis.tlast <= 1'b0;
            axis_tx_state <= E_WAIT;
        end else begin
            case (axis_tx_state)
                E_WAIT : begin
                    taxis.tvalid <= 1'b0;
                    taxis.tlast <= 1'b0;
                    if(sample_valid_sync[1]) axis_tx_state <= E_TX0;
                end
                E_TX0 : begin
                    taxis.tvalid <= 1'b1;
                    taxis.tdata <= i2s_d_reg0_sck;
                    if(sample_valid_sync[1]) axis_tx_state <= E_TX1;
                end
                E_TX1: begin
                    taxis.tdata <= i2s_d_reg1_sck;
                    taxis.tlast <= 1'b1;
                    axis_tx_state <= E_WAIT;
                end
                default : axis_tx_state <= E_WAIT;
            endcase

        end
    end


endmodule : i2s_axis
