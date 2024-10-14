# FIFO-Verification-Project-SV

## Design Overview
This project presents a class-based testbench to verify the functionality of a First-In-First-Out (FIFO) buffer using SystemVerilog. The verification environment is built using basic object-oriented principles, providing a flexible and modular approach for thoroughly testing the FIFO design.

## Project Structure

The project includes the following components:

1. **Project Reports**:
   - `Shehab_Eldeen_FIFO_Project.pdf`: Contains the verification plan and testbench code.
   - `Project_Description.pdf`: Provides an overview of the FIFO design.

2. **Code Files**:
   - **Pre-Debug Design**:
      - `FIFO_before_debugging.v`: The FIFO design before debugging.
   - **Post-Debug Design**:
      - `FIFO.sv`: The finalized FIFO design under test (DUT).
   - **Shared Package**:
      - `shared_pkg.sv`: Contains shared data types, constants, and utilities used across the testbench.
   - **Interface**:
      - `FIFO_interface.sv`: Defines the interface connecting the testbench to the DUT.
   - **Transaction Package**:
      - `FIFO_transaction_pkg.sv`: Defines the transaction class, modeling data passed between the testbench and the DUT, with input constraints.
   - **Coverage Package**:
      - `FIFO_coverage_pkg.sv`: Manages coverage collection to ensure that key scenarios are adequately tested.
   - **Scoreboard**:
      - `FIFO_scoreboard.sv`: Compares the DUT’s output against expected results (golden model).
   - **Monitor**:
      - `FIFO_monitor.sv`: Monitors DUT behavior, collecting data for analysis and comparison, and tracks error and correct operation counts.
   - **Top-Level Module**:
      - `FIFO_top.sv`: The top-level file that connects all testbench components, the DUT, and the interface.

3. **Reports**:
   - `fifo_coverage_report.txt`: Contains details of code, functional, and assertion coverage for the FIFO design.

4. **Do File**:
   - `run.do`: A script for running the testbench and viewing the waveform in Questasim.

5. **Verification Plan**:
   - `FIFO (verification plan).xlsx`: Outlines the verification plan for the FIFO design.

## How to Run
1. Clone this repository.
2. Open Questasim and load the project.
3. Use the provided Do file (`run.do`) to run the testbench and visualize the waveform.

## Conclusion
This class-based verification setup offers a modular and flexible framework to thoroughly verify the FIFO design. It is structured to facilitate debugging and future improvements.

### This project is part of Eng. Kareem Waseem's diploma.

## Contact Me!
- **Email:** shehabeldeen2004@gmail.com
- **LinkedIn:** [Shehab Eldeen](https://www.linkedin.com/in/shehabeldeen22)
- **GitHub:** [Shehab's GitHub](https://github.com/shehab-25)
