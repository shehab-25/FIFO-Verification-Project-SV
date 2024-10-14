////////////////////////////////////////////////////////////////////////////////
// Name: Shehab Eldeen Khaled
// Course: Digital Verification using SV & UVM 
//
// Description: FIFO Monitor  
// 
////////////////////////////////////////////////////////////////////////////////

import shared_pkg::*;
import FIFO_transaction_pkg::*;
import FIFO_scoreboard_pkg::*;
import FIFO_coverage_pkg::*;

module FIFO_monitor (FIFO_interface.MONITOR FIFO_if);
    FIFO_transaction tr_monitor = new();
    FIFO_coverage cov_monitor = new();
    FIFO_scoreboard score_monitor = new();

    initial begin
        forever begin
            @(negedge FIFO_if.clk);
            tr_monitor.rst_n = FIFO_if.rst_n;
            tr_monitor.wr_en = FIFO_if.wr_en;
            tr_monitor.rd_en = FIFO_if.rd_en;
            tr_monitor.data_in = FIFO_if.data_in;
            tr_monitor.data_out = FIFO_if.data_out;
            tr_monitor.wr_ack = FIFO_if.wr_ack;
            tr_monitor.overflow = FIFO_if.overflow;
            tr_monitor.full = FIFO_if.full;
            tr_monitor.empty = FIFO_if.empty;
            tr_monitor.almostfull = FIFO_if.almostfull;
            tr_monitor.almostempty = FIFO_if.almostempty;
            tr_monitor.underflow = FIFO_if.underflow;
            
            fork
                begin
                    cov_monitor.sample_data(tr_monitor);
                end
                begin
                    @(posedge FIFO_if.clk);
                    score_monitor.check_data(tr_monitor);
                end
            join

            //ending simulation
            if (test_finished == 1) begin
                $display("****************************************************************");
                $display("****************************************************************");
                $display("************************Test Summary****************************");
                $display("the design passed by %0d correct outputs and %0d errors ",correct_count,error_count);
                $display("****************************************************************");
                $display("****************************************************************");
                $stop;
            end
        end
    end
endmodule