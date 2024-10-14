////////////////////////////////////////////////////////////////////////////////
// Name: Shehab Eldeen Khaled
// Course: Digital Verification using SV & UVM 
//
// Description: FIFO Scorboard 
// 
////////////////////////////////////////////////////////////////////////////////

package FIFO_scoreboard_pkg;
    import FIFO_transaction_pkg::*;
    import shared_pkg::*;

    class FIFO_scoreboard;
        //parameters
        parameter FIFO_WIDTH = 16;
        parameter FIFO_DEPTH = 8;
        localparam max_fifo_addr = $clog2(FIFO_DEPTH);

        //internal signal
        logic [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];
        logic [max_fifo_addr-1:0] wr_ptr, rd_ptr;
        logic [max_fifo_addr:0] count;

        // refernce output
        logic[FIFO_WIDTH-1:0] data_out_ref;
        logic wr_ack_ref, overflow_ref;
        logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;

        function void check_data(FIFO_transaction checked_data_obj);
            reference_model(checked_data_obj);
            if (data_out_ref != checked_data_obj.data_out || wr_ack_ref != checked_data_obj.wr_ack || overflow_ref != checked_data_obj.overflow ||
            full_ref != checked_data_obj.full || empty_ref != checked_data_obj.empty || almostfull_ref != checked_data_obj.almostfull ||
            almostempty_ref != checked_data_obj.almostempty || underflow_ref != checked_data_obj.underflow) begin

                $display("at time: %0t Error, Incorrect FIFO",$time);
                error_count++;
            end
            else begin
                correct_count++;
            end
        endfunction

        function void reference_model(FIFO_transaction golden_model_obj);
            // write operation
            if (!golden_model_obj.rst_n) begin
		        wr_ptr = 0;
		        overflow_ref = 0;
		        wr_ack_ref = 0;
	        end
            else if (golden_model_obj.wr_en && !full_ref) begin
                mem[wr_ptr] = golden_model_obj.data_in;
                wr_ack_ref = 1;
                wr_ptr = wr_ptr + 1;
                overflow_ref = 0;
            end
            else begin 
                wr_ack_ref = 0; 
                if (full_ref && golden_model_obj.wr_en) begin
                    overflow_ref = 1;
                end
                else begin
                    overflow_ref = 0;
                end
            end

            //read operation
            if (!golden_model_obj.rst_n) begin
		        rd_ptr = 0;
		        underflow_ref = 0;
		        data_out_ref = 0; 
	        end
            else if (golden_model_obj.rd_en && !empty_ref) begin
                data_out_ref = mem[rd_ptr];
                rd_ptr = rd_ptr + 1;
                underflow_ref = 0;
            end

            else begin
                if (golden_model_obj.rd_en && empty_ref) begin
                    underflow_ref = 1;
                end
                else begin
                    underflow_ref = 0;
                end
            end

            // count calculation
        if (!golden_model_obj.rst_n) begin
			count = 0;
		end
		else begin
			if (({golden_model_obj.wr_en, golden_model_obj.rd_en} == 2'b11) && full_ref) begin //fix
                    count = count-1;
            end
			else if (({golden_model_obj.wr_en, golden_model_obj.rd_en} == 2'b11) && empty_ref) begin  //fix
                    count = count+1;
            end
			else if (({golden_model_obj.wr_en, golden_model_obj.rd_en} == 2'b11) && !full_ref && !empty_ref) begin  //fix
                    count = count;
            end
			else if ( ({golden_model_obj.wr_en,golden_model_obj.rd_en} == 2'b10) && !full_ref) 
				count = count + 1;
			else if ( ({golden_model_obj.wr_en, golden_model_obj.rd_en} == 2'b01) && !empty_ref)
				count = count - 1;
		end
            // assign combinational signals (full,empty,almostfull,almostempty)
            full_ref = (count == FIFO_DEPTH)? 1 : 0;
            empty_ref = (count == 0)? 1 : 0;
            almostfull_ref = (count == FIFO_DEPTH-1)? 1 : 0; 
            almostempty_ref = (count == 1)? 1 : 0;
            
        endfunction
    endclass 
endpackage