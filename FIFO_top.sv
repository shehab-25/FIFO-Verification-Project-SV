////////////////////////////////////////////////////////////////////////////////
// Name: Shehab Eldeen Khaled
// Course: Digital Verification using SV & UVM 
//
// Description: FIFO top testbench
// 
////////////////////////////////////////////////////////////////////////////////

module FIFO_top ();
    bit clk;
    initial begin
        clk = 1;
        forever begin
           #1 clk = ~clk;

        end
    end

    FIFO_interface FIFO_if(clk);
    FIFO_tb tb(FIFO_if);
    FIFO DUT(FIFO_if);
    FIFO_monitor MONITOR(FIFO_if);
endmodule