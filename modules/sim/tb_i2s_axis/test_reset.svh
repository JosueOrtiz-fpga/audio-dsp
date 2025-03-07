class test_reset#(DATA_WIDTH_BYTES=4) extends test_base#(DATA_WIDTH_BYTES);

    function new(string name);
        super.new(name);
    endfunction : new

    task run();
        applyReset(10,20);
    endtask : run
endclass : test_reset
