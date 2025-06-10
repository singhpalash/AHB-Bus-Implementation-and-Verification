# AHB-Bus-Implementation-and-Verification
Design and Implementation of AHB BUS 

## 📌 Project Overview
 The primary goal of this project is to implement a fully functional AHB bus interface module that supports key AHB features such as:

 - Single, incrementing, and wrapping burst transfers
   
 - Read and write transactions

 - Support for different transfer sizes

 - Handling wait states and ready signals

 - Proper burst length and type management

 - The implementation is aimed at achieving a protocol-compliant, synthesizable RTL design suitable for FPGA or ASIC deployment.

##  🧩 Design Details

- The AHB bus master and slave interfaces have been designed using SystemVerilog.

- Support for standard AHB signals including address, write/read control, data bus, burst type, size, and ready signals.

- Robust state machine design ensures correct timing and sequencing of transfers.

- Special attention to burst transaction types and handling of wait states to maintain bus integrity.

- The design has a single master and multislave architecture thus an interconnection has been added to select one slave out of multiple slaves

## 🧪 Verification Strategy

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


## 🛡️ Assertion Checks

   <table border="1" cellspacing="0" cellpadding="6">
     <tr>
       <th>Property</th>
       <th>Description</th>
     </tr>
     <tr>
       <td>P1</td>
       <td>When start is low, s_haddr should be zero.</td>
     </tr>
     <tr>
       <td>P2</td>
       <td>When start is low, s_hwdata should be zero.</td>
     </tr>
     <tr>
       <td>P3</td>
       <td>When start is low, o_hrdata should be zero.</td>
     </tr>
     <tr>
       <td>P4</td>
       <td>On rising edge of start, m_haddr should be ≤ 255 throughout the transfer.</td>
     </tr>
     <tr>
       <td>P5</td>
       <td>Only legal burst types (SINGLE or INCR, WRAP, etc.) are allowed.</td>
     </tr>
     <tr>
       <td>P6</td>
       <td>For i_hsize = 1, m_haddr increments by 1.</td>
     </tr>
     <tr>
       <td>P7</td>
       <td>For i_hsize = 2, m_haddr increments by 2.</td>
     </tr>
     <tr>
       <td>P8</td>
       <td>For i_hsize = 3, m_haddr increments by 4.</td>
     </tr>
     <tr>
       <td>P9</td>
       <td>If m_htrans is NONSEQ/SEQ and m_hwdata is valid, i_hwrite should be 1.</td>
     </tr>
     <tr>
       <td>P10</td>
       <td>Read output is stable for 4 cycles if ready and no write occurs.</td>
     </tr>
     <tr>
       <td>P11</td>
       <td>Reset condition sets m_haddr, m_hwdata, and o_hrdata to zero.</td>
     </tr>
     <tr>
       <td>P12</td>
       <td>During wait states, master signals must hold their values.</td>
     </tr>
     <tr>
       <td>P13</td>
       <td>Data read matches previously written data at the same address.</td>
     </tr>
     <tr>
       <td>P14</td>
       <td>For burst type 1, i_hwrite must remain stable during burst.</td>
     </tr>
     <tr>
       <td>P15</td>
       <td>For burst type 2, i_hwrite stable for 4+ cycles.</td>
     </tr>
     <tr>
       <td>P16</td>
       <td>Same as P15, for burst type 3.</td>
     </tr>
     <tr>
       <td>P17</td>
       <td>For burst type 4, i_hwrite stable for 8+ cycles.</td>
     </tr>
     <tr>
       <td>P18</td>
       <td>Same as P17, for burst type 5.</td>
     </tr>
     <tr>
       <td>P19</td>
       <td>For burst type 6, i_hwrite stable for 16+ cycles.</td>
     </tr>
     <tr>
       <td>P20</td>
       <td>Same as P19, for burst type 7.</td>
     </tr>
     <tr>
       <td>P21–P26</td>
       <td>For i_hsize=1 and burst types 1 to 7, m_haddr should increment correctly for each beat.</td>
     </tr>
     <tr>
       <td>P27–P32</td>
       <td>For i_hsize=2 and burst types 1 to 7, m_haddr should increment by 2 each beat.</td>
     </tr>
     <tr>
       <td>P33–P38</td>
       <td>For i_hsize=3 and burst types 1 to 7, m_haddr should increment by 4 each beat.</td>
     </tr>
     <tr>
       <td>P39</td>
       <td>m_haddr and i_hwdata stay stable when invalid burst.</td>
     </tr>
     <tr>
       <td>P40</td>
       <td>If i_hsize > 2, m_haddr becomes 'x' (invalid).</td>
     </tr>
   </table>

##  📈 Functional Coverage Result
![image](https://github.com/user-attachments/assets/c9997b06-5ef7-4f39-bb1e-d6fed441b6ff)

## ✅ Code Coverage Result
<img width="941" alt="image" src="https://github.com/user-attachments/assets/ea0937d3-f54f-419e-af5c-2c3482e7e989" />


## 🛠️ Tools Used

- Simulation: xsim

- Synthesis: Vivado

- Language: SystemVerilog

## ▶️ How to Run

- Run the simulation script provided in the sim folder to execute the testbench.

- Check the waveform files and simulation logs for detailed signal behavior.

- Use the provided testbench for further extension or integration into larger SoC environments.


