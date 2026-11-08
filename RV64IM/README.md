# RV64IM Single-Cycle Processor (VHDL)

A 64-bit single-cycle RISC-V processor written in VHDL. It implements **RV64I**, the **M** extension, a 40-instruction **custom** extension (32 custom-0 R-type and 8 custom-1 I-type instructions) and a small set of **Zba / Zbb / Zbs** instructions.

## Datapath architecture

![RV64IM CPU datapath](CPU_Datapath.png)