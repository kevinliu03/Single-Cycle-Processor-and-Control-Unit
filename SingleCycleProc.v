module singlecycle(
		   input 	     resetl,
		   input [63:0]      startpc,
		   output reg [63:0] currentpc,
		   output [63:0]     MemtoRegOut,  // this should be
						   // attached to the
						   // output of the
						   // MemtoReg Mux
		   input 	     CLK
		   );

   // Next PC connections
   wire [63:0] 			     nextpc;       // The next PC, to be updated on clock cycle

   // Instruction Memory connections
   wire [31:0] 			     instruction;  // The current instruction

   // Parts of instruction
   wire [4:0] 			     rd;            // The destination register
   wire [4:0] 			     rm;            // Operand 1
   wire [4:0] 			     rn;            // Operand 2
   wire [10:0] 			     opcode;

   // Control wires
   wire 			     reg2loc;
   wire 			     alusrc;
   wire 			     mem2reg;
   wire 			     regwrite;
   wire 			     memread;
   wire 			     memwrite;
   wire 			     branch;
   wire 			     uncond_branch;
   wire [3:0] 			     aluctrl;
   wire [2:0] 			     signop;

   // Register file connections
   wire [63:0] 			     regoutA;     // Output A
   wire [63:0] 			     regoutB;     // Output B

   // ALU connections
   wire [63:0] 			     aluout;
   wire 			     zero;

   // Sign Extender connections
   wire [63:0] 			     extimm;

   // PC update logic
   always @(negedge CLK)
     begin
        if (resetl)
          currentpc <= #3 nextpc;
        else
          currentpc <= #3 startpc;
     end

   // Parts of instruction
   assign rd = instruction[4:0];
   assign rm = instruction[9:5];
   assign rn = reg2loc ? instruction[4:0] : instruction[20:16];
   assign opcode = instruction[31:21];

   InstructionMemory imem(
			  .Data(instruction),
			  .Address(currentpc)
			  );

   control control(
		   .reg2loc(reg2loc),
		   .alusrc(alusrc),
		   .mem2reg(mem2reg),
		   .regwrite(regwrite),
		   .memread(memread),
		   .memwrite(memwrite),
		   .branch(branch),
		   .uncond_branch(uncond_branch),
		   .aluop(aluctrl),
		   .signop(signop),
		   .opcode(opcode)
		   );

    // Sign extender instantiation
    SignExtender_Example sign(
        .BusImm(extimm),
        .Imm32(instruction[25:0]),
        .Ctrl(signop)
    );

    // ALU operand B selection (based on ALU source)
    wire [63:0] rb;
    assign rb = (alusrc) ? extimm : regoutB;  // Select between immediate and register B

    // ALU instantiation
    ALU alu(
        .BusW(aluout),        // ALU result (write data)
        .BusA(regoutA),       // Operand A
        .BusB(rb),            // Operand B
        .ALUCtrl(aluctrl),    // ALU control signal
        .Zero(zero)           // Zero flag (for branch decisions)
    );

    output [63:0] readDOut;
    // Data Memory instantiation
    DataMemory data(
        .ReadData(readDOut),   // Data read from memory
        .Address(aluout),     // Memory address (ALU result)
        .WriteData(regoutB),  // Data to write to memory
        .MemoryRead(memread), // Memory read enable
        .MemoryWrite(memwrite), // Memory write enable
        .Clock(CLK)           // Clock signal
    );

    // Mux to select between memory data and ALU result
    assign MemtoRegOut = (mem2reg) ? readDOut : aluout;  // Memory or ALU result

    // Register file instantiation
    RegisterFile register(
        .BusA(regoutA),        // Output A
        .BusB(regoutB),        // Output B
        .BusW(MemtoRegOut),    // Write data (MemtoRegOut)
        .RA(rm),               // Read address A
        .RB(rn),               // Read address B
        .RW(rd),               // Write address (destination register)
        .RegWr(regwrite),      // Register write enable
        .Clk(CLK)              // Clock signal
    );

    // Next PC logic instantiation
    NextPClogic next(
        .NextPC(nextpc),
        .CurrentPC(currentpc),
        .SignExtImm64(extimm),
        .Branch(branch),
        .ALUZero(zero),
        .Uncondbranch(uncond_branch)
    );

endmodule
