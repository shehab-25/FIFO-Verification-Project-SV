////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM 
//
// Description: FIFO Design (modified and fixed by Shehab Eldeen Khaled Mabrouk)
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_interface.DUT FIFO_if);
	
	localparam max_fifo_addr = $clog2(FIFO_if.FIFO_DEPTH);

	reg [FIFO_if.FIFO_WIDTH-1:0] mem [FIFO_if.FIFO_DEPTH-1:0];

	reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
	reg [max_fifo_addr:0] count;

	// write operation
	always @(posedge FIFO_if.clk or negedge FIFO_if.rst_n) begin
		if (!FIFO_if.rst_n) begin
			wr_ptr <= 0;
			FIFO_if.overflow <= 0;  //fix: overflow signal should be zero at reset
			FIFO_if.wr_ack <= 0;    //fix: write_ack signal should be zero at reset
		end
		else if (FIFO_if.wr_en && count < FIFO_if.FIFO_DEPTH) begin
			mem[wr_ptr] <= FIFO_if.data_in;
			FIFO_if.wr_ack <= 1;
			wr_ptr <= wr_ptr + 1;
			FIFO_if.overflow <= 0;  //fix: due to FIFO is not full , so overflow should be zero
		end
		else begin 
			FIFO_if.wr_ack <= 0; 
			if (FIFO_if.full && FIFO_if.wr_en)
				FIFO_if.overflow <= 1;
			else
				FIFO_if.overflow <= 0;
		end
	end

	// read operation
	always @(posedge FIFO_if.clk or negedge FIFO_if.rst_n) begin
		if (!FIFO_if.rst_n) begin
			rd_ptr <= 0;
			FIFO_if.underflow <= 0;   //fix: underflow signal should be zero at reset
			FIFO_if.data_out <= 0;    //fix: dataout signal should be zero at reset
		end
		else if (FIFO_if.rd_en && count != 0) begin
			FIFO_if.data_out <= mem[rd_ptr];
			rd_ptr <= rd_ptr + 1;
			FIFO_if.underflow <= 0;    //fix: due to FIFO is not empty , so underflow should be zero
		end

		else begin   //fix : underflow output is sequential output not combinational
			if (FIFO_if.rd_en && FIFO_if.empty) begin
				FIFO_if.underflow <= 1;       //fix
			end
			else begin
				FIFO_if.underflow <= 0;        //fix
			end
		end
	end

	always @(posedge FIFO_if.clk or negedge FIFO_if.rst_n) begin
		if (!FIFO_if.rst_n) begin
			count <= 0;
		end
		else begin
			if (({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b11) && FIFO_if.full) begin 
                    count <= count-1;  //fix: when both wr_en and rd_en are high , and full=1 , only read operation will occur
            end
			else if (({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b11) && FIFO_if.empty) begin  //fix
                    count <= count+1; //fix: when both wr_en and rd_en are high , and empty=1 , only write operation will occur
            end
			else if (({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b11) && !FIFO_if.full && !FIFO_if.empty) begin  //fix
                    count <= count; //fix: when both wr_en and rd_en are high , and both empty=0 and full=0 , both operations (read,write) will occur
            end
			else if ( ({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b10) && !FIFO_if.full) 
				count <= count + 1;
			else if ( ({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b01) && !FIFO_if.empty)
				count <= count - 1;
		end
	end

	assign FIFO_if.full = (count == FIFO_if.FIFO_DEPTH)? 1 : 0;
	assign FIFO_if.empty = (count == 0)? 1 : 0;
	assign FIFO_if.almostfull = (count == FIFO_if.FIFO_DEPTH-1)? 1 : 0; //fix : almostfull signal is high when count=FIFO_DEPTH-1 not FIFO_DEPTH-2
	assign FIFO_if.almostempty = (count == 1)? 1 : 0;


	//FIFO_Assertions
	`ifdef SIM

	//immediate assertions (combinational outputs)
	always_comb begin
		if(!FIFO_if.rst_n) begin
			reset_ass: assert final((!count) && (!rd_ptr) && (!wr_ptr))
			else $display("at time: %t , reset fails",$time);
		end
		full_ass:         assert final(FIFO_if.full == (count == FIFO_if.FIFO_DEPTH)? 1 : 0)       else $display("at time: %t , full fails",$time);
		empty_ass:        assert final(FIFO_if.empty == (count == 0)? 1 : 0)                      else $display("at time: %t , empty fails",$time);
		almostfull_ass:   assert final(FIFO_if.almostfull == (count == FIFO_if.FIFO_DEPTH-1)? 1 : 0)      else $display("at time: %t , almost full fails",$time);
		almost_empty_ass: assert final(FIFO_if.almostempty == (count == 1)? 1 : 0 )               else $display("at time: %t , almost empty fails",$time);
	end

	//concurrent assertions (sequential outputs)
	property overflow_ass;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.full && FIFO_if.wr_en) |=> FIFO_if.overflow;
	endproperty

	property underflow_ass;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.empty && FIFO_if.rd_en) |=> FIFO_if.underflow;
	endproperty

	property wr_ack_ass;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (!FIFO_if.full && FIFO_if.wr_en) |=> FIFO_if.wr_ack;
	endproperty

	property wr_ptr_ass;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (!FIFO_if.full && FIFO_if.wr_en) |=> wr_ptr == $past(wr_ptr) + 1'b1;
	endproperty

	property rd_ptr_ass;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (!FIFO_if.empty && FIFO_if.rd_en) |=> rd_ptr == $past(rd_ptr) + 1'b1;
	endproperty

	property count_inc_ass;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.wr_en && !FIFO_if.full && !FIFO_if.rd_en) |=> count == $past(count) + 1'b1;
	endproperty

	property count_dec_ass;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (!FIFO_if.wr_en && FIFO_if.rd_en && !FIFO_if.empty) |=> count == $past(count) - 1'b1;
	endproperty

	property count_const_ass;
		@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.wr_en && FIFO_if.rd_en && !FIFO_if.empty && !FIFO_if.full) |=> count == $past(count);
	endproperty

	overflow_assert: assert property(overflow_ass) else $display("at time %t : overflow Fails",$time);
	underflow_assert: assert property(underflow_ass) else $display("at time %t : underflow Fails",$time);
	wr_ack_assert: assert property(wr_ack_ass) else $display("at time %t : write ack Fails",$time);
	wr_ptr_assert: assert property(wr_ptr_ass) else $display("at time %t : write pointer Fails",$time);
	rd_ptr_assert: assert property(rd_ptr_ass) else $display("at time %t : read pointer Fails",$time);
	count_inc_assert: assert property(count_inc_ass) else $display("at time %t : counter increment Fails",$time);
	count_dec_assert: assert property(count_dec_ass) else $display("at time %t : counter decrement Fails",$time);
	count_const_assert: assert property(count_const_ass) else $display("at time %t : counter const Fails",$time);

	overflow_cover: cover property (overflow_ass);
	underflow_cover: cover property (underflow_ass);
	wr_ack_cover: cover property (wr_ack_ass);
	wr_ptr_cover: cover property (wr_ptr_ass);
	rd_ptr_cover: cover property (rd_ptr_ass);
	count_inc_cover: cover property (count_inc_ass);
	count_dec_cover: cover property (count_dec_ass);
	count_const_cover: cover property (count_const_ass);
	`endif
endmodule