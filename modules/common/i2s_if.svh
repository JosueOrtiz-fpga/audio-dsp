interface i2s_if;

    logic sck;
    logic ws;
    logic d;

    modport receiver (
        input sck, ws, d
    );

    
endinterface : i2s_if
