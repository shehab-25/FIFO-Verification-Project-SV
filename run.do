vlib work
vlog +define+SIM +cover -covercells FIFO.sv FIFO_tb.sv FIFO_transaction_pkg.sv FIFO_coverage_pkg.sv FIFO_scoreboard.sv FIFO_monitor.sv FIFO_interface.sv shared_pkg.sv FIFO_top.sv
vsim -voptargs=+acc work.FIFO_top -cover 
add wave *
add wave -position insertpoint sim:/FIFO_top/FIFO_if/*
add wave -position insertpoint  \
sim:/FIFO_top/DUT/mem \
sim:/FIFO_top/DUT/wr_ptr \
sim:/FIFO_top/DUT/rd_ptr \
sim:/FIFO_top/DUT/count
add wave -position insertpoint  \
sim:/shared_pkg::error_count \
sim:/shared_pkg::correct_count \
sim:/shared_pkg::test_finished
coverage save FIFO_tb.ucdb -onexit
run -all