# FPGA-Based Low-Pass FIR Filter: CLB vs. DSP Implementation

![Xilinx FPGA](https://img.shields.io/badge/FPGA-Xilinx-FF1010?logo=xilinx) 
![License](https://img.shields.io/badge/License-MIT-blue) 
![Vivado](https://img.shields.io/badge/Synthesis-Vivado-FF1010?logo=xilinx)

A hardware implementation of an 8th-order low-pass FIR filter on Xilinx FPGA, comparing **CLB-based logic** and **DSP slice** approaches. Demonstrates the efficiency of DSP slices for arithmetic-intensive tasks.

## 📌 Overview
- **Filter Specifications**:
  - Type: Low-pass FIR
  - Order: 8 (9 taps)
  - Cut-off Frequency: 1 kHz
  - Sampling Frequency: 10 kHz
- **Key Comparisons**:
  - Resource utilization (LUTs, FFs, DSPs)
  - Throughput and clock frequency
  - Power efficiency

## 🚀 Features
- **Filter Design**:
  - Coefficients generated using a Hamming window.
  - Fixed-point quantization (Q2.14 format).
- **Implementations**:
  - **CLB-Based**: General-purpose logic (LUTs/FFs).
  - **DSP-Based**: Pipelined design with manual DSP48E1 instantiation.
- **Performance Metrics**:
  - Throughput (MSPS), resource usage, and power estimates.

## 📊 Performance Improvement
<table>
  <thead>
    <tr>
      <th>Metric</th>
      <th>CLB-Based</th>
      <th>DSP-Based</th>
      <th>Improvement</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>LUT Utilization</strong></td>
      <td>~500 LUTs</td>
      <td>~20 LUTs</td>
      <td><strong>25x reduction</strong></td>
    </tr>
    <tr>
      <td><strong>FF Utilization</strong></td>
      <td>~200 FFs</td>
      <td>~100 FFs</td>
      <td><strong>2x reduction</strong></td>
    </tr>
    <tr>
      <td><strong>DSP Slice Usage</strong></td>
      <td>0</td>
      <td>9</td>
      <td><strong>N/A</strong></td>
    </tr>
  </tbody>
</table>
