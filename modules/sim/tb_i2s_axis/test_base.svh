class test_base#(DATA_WIDTH_BYTES);

    string _name;

    virtual axis_if axis_vif;
    virtual i2s_if i2s_vif;

    function new(string name="test_base");
        _name = name;
    endfunction

    task applyReset(int numOfRstCycles, int totalCycles);
        axis_vif.aresetn <= 1'b0;
        $display("axis.tvalid=%b axis.tready=%b, axis.tdata=0x%x axis.tlast=%b",
            axis_vif.tvalid, axis_vif.tready, axis_vif.tdata, axis_vif.tlast);
        $display("i2s.sck=%b i2s.ws=%b, i2s.d=%b",
            i2s_vif.sck, i2s_vif.ws, i2s_vif.d);
        repeat(numOfRstCycles) begin
            @(posedge axis_vif.aclk);
            $display("axis.tvalid=%b axis.tready=%b, axis.tdata=0x%x axis.tlast=%b",
                axis_vif.tvalid, axis_vif.tready, axis_vif.tdata, axis_vif.tlast);
            $display("i2s.sck=%b i2s.ws=%b, i2s.d=%b",
                i2s_vif.sck, i2s_vif.ws, i2s_vif.d);
        end
        axis_vif.aresetn <= 1'b0;
        $display("axis.tvalid=%b axis.tready=%b, axis.tdata=0x%x axis.tlast=%b",
            axis_vif.tvalid, axis_vif.tready, axis_vif.tdata, axis_vif.tlast);
        $display("i2s.sck=%b i2s.ws=%b, i2s.d=%b",
            i2s_vif.sck, i2s_vif.ws, i2s_vif.d);
        repeat(numOfRstCycles) begin
            @(posedge axis_vif.aclk);
            $display("axis.tvalid=%b axis.tready=%b, axis.tdata=0x%x axis.tlast=%b",
                axis_vif.tvalid, axis_vif.tready, axis_vif.tdata, axis_vif.tlast);
            $display("i2s.sck=%b i2s.ws=%b, i2s.d=%b",
                i2s_vif.sck, i2s_vif.ws, i2s_vif.d);
        end
    endtask : applyReset


endclass : test_base
