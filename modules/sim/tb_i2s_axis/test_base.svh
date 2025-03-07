class test_base#(DATA_WIDTH_BYTES);

    string _name;

    int _fd;

    virtual axis_if axis_vif;
    virtual i2s_if i2s_vif;

    function new(string name="test_base");
        _name = name;
    endfunction

    task applyReset(int numOfRstCycles, int totalCycles);
        openLogFile();
        axis_vif.aresetn <= 1'b0;
        filePrintIfs(_fd);
        repeat(numOfRstCycles) begin
            @(posedge axis_vif.aclk);
            filePrintIfs(_fd);
        end
        axis_vif.aresetn <= 1'b0;
        filePrintIfs(_fd);
        repeat(numOfRstCycles) begin
            @(posedge axis_vif.aclk);
            filePrintIfs(_fd);
        end
        closeLogFile();
    endtask : applyReset

    function void filePrintIfs(int fd);
        axis_vif.filePrint(fd);
        i2s_vif.filePrint(fd);
    endfunction :filePrintIfs

    function void openLogFile();
        _fd = $fopen({_name, ".txt"});
        if(!_fd) $error("Could not open %s.txt", _name);
    endfunction : openLogFile

    function void closeLogFile();
        $fclose(_fd);
    endfunction : closeLogFile

endclass : test_base
