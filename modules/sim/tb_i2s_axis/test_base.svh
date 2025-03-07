class test_base#(DATA_WIDTH_BYTES);

    string _name;

    int _fd_result;
    int _fd_golden;


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
        openResultFile("w");
        filePrintIfs(_fd_result);
        repeat(2) @(posedge axis_vif.aclk);
        filePrintIfs(_fd_result);
        repeat(numOfRstCycles-2) begin
            @(posedge axis_vif.aclk);
        end
        axis_vif.aresetn <= 1'b1;
        repeat(2) @(posedge axis_vif.aclk);
        filePrintIfs(_fd_result);
        repeat(totalCycles-numOfRstCycles-2) begin
            @(posedge axis_vif.aclk);
        end
        closeResultFile();
    endtask : applyReset

    task compareFiles();
        string line0;
        string line1;

        openResultFile("r");
        openGoldenFile();

        while (!$feof(_fd_golden) && !$feof(_fd_result)) begin
            $fgets(line0, _fd_golden);
            $fgets(line1, _fd_result);

            if (line0 != line1) begin
                $display("Golden: %s", line0);
                $display("Result: %s", line1);
                $error("Files differ at line: %s", line0);
            end
        end

        if (!$feof(_fd_golden) || !$feof(_fd_result)) begin
            $display("Files have different lengths");
        end

        closeResultFile();
        closeGoldenFile();
    endtask : compareFiles

    function void filePrintIfs(int fd);
        axis_vif.filePrint(fd);
        i2s_vif.filePrint(fd);
    endfunction :filePrintIfs

    function void openResultFile(string permission="r");
        _fd_result = $fopen({_name, ".txt"}, permission);
        if(!_fd_result) $error("Could not open %s.txt", _name);
    endfunction : openResultFile

    function void openGoldenFile();
        _fd_golden = $fopen({"../../golden/",_name, ".txt"}, "r");
        if(!_fd_golden) $error("Could not open %s.txt", _name);
    endfunction : openGoldenFile

    function void closeResultFile();
        $fclose(_fd_result);
    endfunction : closeResultFile

    function void closeGoldenFile();
        $fclose(_fd_golden);
    endfunction : closeGoldenFile

endclass : test_base
