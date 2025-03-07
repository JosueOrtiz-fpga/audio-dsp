class test_base#(DATA_WIDTH_BYTES);

    string _name;

    int _fd;

    virtual axis_if axis_vif;
    virtual i2s_if i2s_vif;

    function new(string name="test_base");
        _name = name;
    endfunction

    task initDrivers();
        axis_vif.aresetn <= 1'b0;
        axis_vif.tready <= 1'b0;
        i2s_vif.d <= 1'b0;
        i2s_vif.ws <= 1'b1;
    endtask : initDrivers
    
    task applyReset(int numOfRstCycles, int totalCycles);
        openLogFile("w");
        filePrintIfs(_fd);
        repeat(2) @(posedge axis_vif.aclk);
        filePrintIfs(_fd);
        repeat(numOfRstCycles-2) begin
            @(posedge axis_vif.aclk);
        end
        axis_vif.aresetn <= 1'b1;
        repeat(2) @(posedge axis_vif.aclk);
        filePrintIfs(_fd);
        repeat(totalCycles-numOfRstCycles-2) begin
            @(posedge axis_vif.aclk);
        end
        closeLogFile();
    endtask : applyReset

    function void filePrintIfs(int fd);
        axis_vif.filePrint(fd);
        i2s_vif.filePrint(fd);
    endfunction :filePrintIfs

    function void openLogFile(string permission="r");
        _fd = $fopen({_name, ".txt"}, permission);
        if(!_fd) $error("Could not open %s.txt", _name);
    endfunction : openLogFile

    function void closeLogFile();
        $fclose(_fd);
    endfunction : closeLogFile

endclass : test_base
