////////////////////////////////////////////////////////////////////////////////
// Name: Shehab Eldeen Khaled
// Course: Digital Verification using SV & UVM 
//
// Description: FIFO Coverage 
// 
////////////////////////////////////////////////////////////////////////////////

package FIFO_coverage_pkg;
    import FIFO_transaction_pkg::*;
    class FIFO_coverage;
        FIFO_transaction F_cvg_txn = new();

        covergroup write_read_cover;
            write_enable_cvg: coverpoint F_cvg_txn.wr_en;          //coverpoint for write_en signal
            read_enable_cvg : coverpoint F_cvg_txn.rd_en;          //coverpoint for read_en signal
            full_cvg:         coverpoint F_cvg_txn.full;           //coverpoint for full flag output
            empty_cvg:        coverpoint F_cvg_txn.empty;          //coverpoint for empty flag output
            almost_full_cvg:  coverpoint F_cvg_txn.almostfull;     //coverpoint for almostfull flag output
            almost_empty_cvg: coverpoint F_cvg_txn.almostempty;    //coverpoint for almostempty flag output
            write_ack_cvg:    coverpoint F_cvg_txn.wr_ack;         //coverpoint for write_ack flag output
            overflow_cvg:     coverpoint F_cvg_txn.overflow;       //coverpoint for overflow flag output
            underflow_cvg:    coverpoint F_cvg_txn.underflow;      //coverpoint for underflow flag output

            write_read_full:        cross write_enable_cvg,read_enable_cvg,full_cvg{                     // cross between wr_en , rd_en , full
                //not important for full output if read_en = 1 (as full=1 may only when wr_en=1)
                ignore_bins full_read_en00 = binsof(read_enable_cvg) intersect {1} && binsof(full_cvg) intersect {1};
            }

            write_read_empty:       cross write_enable_cvg,read_enable_cvg,empty_cvg;               // cross between wr_en , rd_en , empty
            write_read_almost_full: cross write_enable_cvg,read_enable_cvg,almost_full_cvg;         // cross between wr_en , rd_en , almostfull
            write_read_almostempty: cross write_enable_cvg,read_enable_cvg,almost_empty_cvg;        // cross between wr_en , rd_en , almostempty

            write_read_wr_ack:      cross write_enable_cvg,read_enable_cvg,write_ack_cvg{            // cross between wr_en , rd_en , wr_ack
                //not important for wr_ack output if write_en = 0 (as wr_ack=1 only when wr_en=1)
                ignore_bins wr_ack_wr_en00 = binsof(write_enable_cvg) intersect {0} && binsof(write_ack_cvg) intersect {1};  
            }

            write_read_overflow:    cross write_enable_cvg,read_enable_cvg,overflow_cvg{             // cross between wr_en , rd_en , overflow
                //not important for overflow output if write_en = 0 (as overflow occurs only when wr_en=1)
                ignore_bins write_overflow00 = binsof(write_enable_cvg) intersect {0} && binsof(overflow_cvg) intersect {1};  
            }

            write_read_underflow:   cross write_enable_cvg,read_enable_cvg,underflow_cvg{            // cross between wr_en , rd_en , underflow
                //not important for underflow output if read_en = 0 (as underflow occurs only when rd_en=1)
                ignore_bins read_underflow00 = binsof(read_enable_cvg) intersect {0} && binsof(underflow_cvg) intersect {1};  
            }
        endgroup

        function void sample_data(input FIFO_transaction F_txn);
            this.F_cvg_txn = F_txn;
            this.write_read_cover.sample();    //sampling the covergroup
        endfunction

        function new();
            write_read_cover = new();
        endfunction 
    endclass 
endpackage