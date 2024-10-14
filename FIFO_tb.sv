////////////////////////////////////////////////////////////////////////////////
// Name: Shehab Eldeen Khaled
// Course: Digital Verification using SV & UVM 
//
// Description: FIFO Testbench driver 
// 
////////////////////////////////////////////////////////////////////////////////

import shared_pkg::*;
import FIFO_transaction_pkg::*;
import FIFO_coverage_pkg::*;
import FIFO_scoreboard_pkg::*;

module FIFO_tb (FIFO_interface.TEST FIFO_if);
    parameter FIFO_WIDTH = FIFO_if.FIFO_DEPTH;
    parameter FIFO_DEPTH = FIFO_if.FIFO_WIDTH;

    // create object
    FIFO_transaction tr_obj = new();
    

    initial begin
        // initialize design
        FIFO_if.rst_n = 0;
        FIFO_if.wr_en = 1;
        FIFO_if.rd_en = 0;
        FIFO_if.data_in = 5;
        @(negedge FIFO_if.clk);
        #0;

        for (int i = 0;i<1000 ;i++ ) begin
            assert(tr_obj.randomize());
            FIFO_if.rst_n = tr_obj.rst_n;
            FIFO_if.wr_en = tr_obj.wr_en;
            FIFO_if.rd_en = tr_obj.rd_en;
            FIFO_if.data_in = tr_obj.data_in;
            @(negedge FIFO_if.clk);
        end

        // end test
        test_finished = 1;
        #1;
    end
endmodule