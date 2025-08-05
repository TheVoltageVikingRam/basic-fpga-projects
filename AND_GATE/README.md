# 🔌 AND Gate – FPGA Implementation using Vivado (Arty S7-25)

This project demonstrates the design, simulation, synthesis, and implementation of a **2-input AND Gate** using **Verilog HDL** on the **Arty S7-25 FPGA board**. The project was developed and tested using the **Xilinx Vivado Design Suite**.

---

## 🎥 Demo Video

<p align="center">
  <a href="https://youtu.be/cNGiZsKyhAw?si=YAZUrBTNEblmpBHi" target="_blank">
    <img src="https://img.youtube.com/vi/cNGiZsKyhAw/0.jpg" alt="AND Gate FPGA Implementation Video" width="600"/>
  </a>
</p>

---

## 📐 Design Overview

- **Module**: `AND_GATE`
- **Inputs**: `A`, `B`
- **Output**: `Y = A & B`
- **Language**: Verilog HDL
- **Target Device**: Arty S7-25 (Spartan-7)
- **Toolchain**: Vivado Design Suite
- **Simulation**: Vivado XSim

---

## 📁 Source Files

- 🔸 **RTL Code** is located in:  
  `AND_GATE.srcs/sources_1/new/`

- 🔸 **Testbench** is located in:  
  `AND_GATE.srcs/sim_1/new/`

These folders contain the Verilog implementation and the testbench used for simulation.

---

## 🧪 Key Results

| Image | Description |
|-------|-------------|
| ![RTL Schematic](RTL_Schematic.png) | RTL schematic of the AND gate |
| ![Synthesis](synthesis_and_gate.png) | Post-synthesis schematic |
| ![Implementation](Implemented_design_and_gate.png) | Implemented design layout |
| ![Schematic View](Implemented_design_schematic.png) | Schematic view after implementation |
| ![Simulation](Testbench_simulation.png) | Testbench waveform showing correct behavior |

---

## ✅ Features

- Clean and minimal RTL code
- Functional testbench for simulation
- Successful synthesis and implementation
- Ready for hardware deployment on Arty S7-25

---

## 👨‍💻 Author

**Ram Tripathi**

---
