# AHB-Bus-Implementation-and-Verification
Design and Implementation of AHB BUS 

## Project Overview

 The primary goal of this project is to implement a fully functional AHB bus interface module that supports key AHB features such as:

 - Single, incrementing, and wrapping burst transfers
   
 - Read and write transactions

 - Support for different transfer sizes

 - Handling wait states and ready signals

 - Proper burst length and type management

 - The implementation is aimed at achieving a protocol-compliant, synthesizable RTL design suitable for FPGA or ASIC deployment.

## Design Details

- The AHB bus master and slave interfaces have been designed using SystemVerilog.

- Support for standard AHB signals including address, write/read control, data bus, burst type, size, and ready signals.

- Robust state machine design ensures correct timing and sequencing of transfers.

- Special attention to burst transaction types and handling of wait states to maintain bus integrity.

- The design has a single master and multislave architecture thus an interconnection has been added to select one slave out of multiple slaves

## Verification Strategy

- The design is verified using a comprehensive UVM-based testbench environment.

- Functional coverage and assertion checks have been incorporated to ensure protocol compliance and corner case detection.

- The verification environment applies randomized stimuli to the AHB signals, testing various transaction types including single, incrementing, and wrapping bursts.

- Multiple scenarios were executed to validate read/write transactions, bus timing, and response handling under different conditions.

- Simulation waveforms and logs confirm the design’s correctness and robustness across all tested cases.

## 📊 Coverages Checked
<table style="border: 1px solid black; border-collapse: collapse;">
  <tr style="background-color: #cccccc;">
    <th style="border: 1px solid black; padding: 8px;">Covergroup</th>
    <th style="border: 1px solid black; padding: 8px;">Coverpoint/Cross</th>
    <th style="border: 1px solid black; padding: 8px;">Description</th>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 8px;">cvr</td>
    <td style="border: 1px solid black; padding: 8px;">tr.rst, tr.start bins</td>
    <td style="border: 1px solid black; padding: 8px;">Tracks reset and start signals for both active (1) and inactive (0) states</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 8px;">cvr</td>
    <td style="border: 1px solid black; padding: 8px;">tr.i_haddr bins</td>
    <td style="border: 1px solid black; padding: 8px;">Samples address field values in range 0–255</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 8px;">cvr</td>
    <td style="border: 1px solid black; padding: 8px;">tr.i_hwrite bins</td>
    <td style="border: 1px solid black; padding: 8px;">Covers read (0) and write (1) transactions</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 8px;">cvr</td>
    <td style="border: 1px solid black; padding: 8px;">tr.i_hsize bins</td>
    <td style="border: 1px solid black; padding: 8px;">Tracks transfer size: byte, half-word, and word accesses</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 8px;">cvr</td>
    <td style="border: 1px solid black; padding: 8px;">tr.i_hwdata bins</td>
    <td style="border: 1px solid black; padding: 8px;">Data categorized into low (0–63) and high (64–127) bins</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 8px;">cvr</td>
    <td style="border: 1px solid black; padding: 8px;">tr.i_hburst bins</td>
    <td style="border: 1px solid black; padding: 8px;">Samples various burst types including single, incr4, wrap4, incr8, wrap8, incr16, wrap16, and undefined</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 8px;">cvr</td>
    <td style="border: 1px solid black; padding: 8px;">tr.o_hrdata</td>
    <td style="border: 1px solid black; padding: 8px;">Covers all possible output read data values</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 8px;">cvr</td>
    <td style="border: 1px solid black; padding: 8px;">tr.m_hready bins</td>
    <td style="border: 1px solid black; padding: 8px;">Samples HREADY signal for ready (1) and not ready (0) states</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 8px;">cvr</td>
    <td style="border: 1px solid black; padding: 8px;">cross tr.i_hburst, tr.start, tr.m_hready</td>
    <td style="border: 1px solid black; padding: 8px;">Illegal burst transfer combinations are tracked when start is low or slave not ready</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 8px;">cvr</td>
    <td style="border: 1px solid black; padding: 8px;">cross tr.i_haddr, tr.start, tr.m_hready</td>
    <td style="border: 1px solid black; padding: 8px;">Covers illegal transactions with invalid addresses and low start or HREADY low</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 8px;">cvr</td>
    <td style="border: 1px solid black; padding: 8px;">cross tr.i_hburst, tr.start, tr.m_hready</td>
    <td style="border: 1px solid black; padding: 8px;">Tracks legal burst transfers with proper start and ready signal</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 8px;">cvr</td>
    <td style="border: 1px solid black; padding: 8px;">cross tr.i_haddr, tr.start, tr.m_hready</td>
    <td style="border: 1px solid black; padding: 8px;">Tracks legal transactions for valid address range when HREADY is high</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 8px;">cvr</td>
    <td style="border: 1px solid black; padding: 8px;">cross tr.start, tr.m_hready (illegal)</td>
    <td style="border: 1px solid black; padding: 8px;">Illegal cases when start asserted but slave not ready</td>
  </tr>
  <tr>
    <td style="border: 1px solid black; padding: 8px;">cvr</td>
    <td style="border: 1px solid black; padding: 8px;">cross tr.start, tr.m_hready (legal)</td>
    <td style="border: 1px solid black; padding: 8px;">Valid combinations of asserted start and ready handshake</td>
  </tr>
</table>


