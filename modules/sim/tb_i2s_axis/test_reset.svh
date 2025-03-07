class test_reset#(DATA_WIDTH_BYTES=4) extends test_base#(DATA_WIDTH_BYTES);

    function new(string name);
        super.new(name);
    endfunction : new

    task run();
        int sck_count_aresetn_low;
        int sck_count_aresetn_high;
        sck_count_aresetn_low = 0;
        sck_count_aresetn_high = 0;

        initDrivers();
        fork
            begin
                applyReset(24,48);
            end
            begin
                while(1) begin
                    @(posedge i2s_vif.sck && !axis_vif.aresetn) sck_count_aresetn_low ++;
                end
            end
            begin
                while(1) begin
                    @(posedge i2s_vif.sck && axis_vif.aresetn) sck_count_aresetn_high ++;
                end
            end
        join_any

        openResultFile("a");
        $fdisplay(_fd_result,"sck_count while aresetn was low = %0d", sck_count_aresetn_low);
        $fdisplay(_fd_result,"sck_count while aresetn was high = %0d", sck_count_aresetn_high);
        closeResultFile();
        compareFiles();
    endtask : run
endclass : test_reset
