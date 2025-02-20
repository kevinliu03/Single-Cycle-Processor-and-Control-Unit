# CPU II Project

## Overview
This project implements a single-cycle CPU architecture using Verilog. The CPU is designed to execute a set of R-type and I-type instructions, including arithmetic operations, logical operations, and immediate value handling. The architecture features a control unit that manages instruction decoding and execution flow, along with a comprehensive testbench to validate functionality.

## Features
- **R-type Instructions**: Supports operations such as ADD, AND, ORR, and SUB.
- **I-type Instructions**: Implements immediate value operations, including ADDIMM and SUBIMM.
- **Branch Instructions**: Includes unconditional (B) and conditional (CBZ) branching.
- **Memory Operations**: Supports load (LDUR) and store (STUR) operations.
- **MOVZ Instruction**: Implements the MOVZ instruction for moving wide values with zero extension.
- **Testbench**: A dedicated testbench to validate the functionality of the CPU and its components.

## Components
- **DataMemory**: Handles read and write operations to memory.
- **InstructionMemory**: Stores and retrieves instructions for execution.
- **ALU**: Performs arithmetic and logical operations.
- **RegisterFile**: Manages the CPU's registers for data storage and retrieval.
- **Control Unit**: Generates control signals based on the instruction opcode.
- **Sign Extender**: Extends immediate values for use in operations.

## Getting Started

### Prerequisites
- A Verilog simulator (e.g., ModelSim, Vivado, or any compatible simulator).
- Basic understanding of digital design and Verilog syntax.

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/cpu-project.git
   cd cpu-project
