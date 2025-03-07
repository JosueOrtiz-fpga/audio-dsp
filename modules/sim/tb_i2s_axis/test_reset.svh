class test_reset#(DATA_WIDTH_BYTES=4) extends test_base#(DATA_WIDTH_BYTES);

    function new(string name);
        super.new(name);
    endfunction : new

    task run();
        int sck_count;
        sck_count = 0;
        initDrivers();
        fork
            begin
                applyReset(24,48);
            end
            begin
                while(1) begin
                    @(posedge i2s_vif.sck && !axis_vif.aresetn) sck_count ++;
                end
            end
        join_any

        $display("sck_count = %0d", sck_count);
    endtask : run
endclass : test_reset
