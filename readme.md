# FPGA-Based Sigma-Delta DAC Implementation

This repository contains the source code and related files for the **FPGA implementation of a fifth-order, 1-bit Sigma-Delta (SD) DAC**, designed for integration with the SyFaLa toolchain. This implementation enables direct audio playback from SyFaLa-generated signals on an FPGA.

## Overview
- sd_dac_fifth_fixed.vhd: The VHDL implementation of the fifth-order SD DAC
- roundFXP.m: the simulation of fixed point arithmetic in Matlab
- DAC5_fixed.m: the simulation of the fifth-order DAC in Matlab
- QuantisationPareto.m: Generates a pareto front, comparing the bitstream of a 64bit float implementation to fixed point implementations
- bitwidthtest.m: Generates a surf chart for the SNR of many DAC configurations
- test_quantization.m: simulates the FxP DAC and compares the output to a FP DAC
