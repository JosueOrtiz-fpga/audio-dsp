interface i2s_if;

    logic sck;
    logic ws;
    logic d;

    modport receiver (
        input sck, ws, d
    );

    function void filePrint(int fd);
        $fdisplay(fd,"i2s.sck=%b i2s.ws=%b, i2s.d=%b",sck, ws, d);
    endfunction : filePrint

    
endinterface : i2s_if
