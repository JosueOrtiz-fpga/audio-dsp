interface axis_if#(DATA_WIDTH_BYTES=4);

    logic aclk;
    logic aresetn;
    logic tvalid;
    logic[(8*DATA_WIDTH_BYTES-1):0] tdata;
    logic tready;
    logic tlast;

    modport receiver (
        input aclk, aresetn, tvalid, tdata, tlast,
        output tready
    );

    modport transmitter(
        input aclk, aresetn, tready,
        output tvalid, tdata, tlast
    );

    function void filePrint(int fd);
        $fdisplay(fd,"[%0t] axis.tvalid=%b axis.tready=%b, axis.tdata=0x%0x axis.tlast=%b",
            $time, tvalid, tready, tdata, tlast);
    endfunction : filePrint

endinterface : axis_if
