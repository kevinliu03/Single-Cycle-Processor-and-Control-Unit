module NextPClogic(NextPC, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch); 
    input [63:0] CurrentPC, SignExtImm64; 
    input Branch, ALUZero, Uncondbranch; 
    output reg [63:0] NextPC; 

    always @(*) begin
         // Default to the next sequential instruction
         NextPC = CurrentPC + 4; // Assuming each instruction is 4 bytes or shifting by 1 bits

         // Check for unconditional branch
         if (Uncondbranch) begin
            NextPC = CurrentPC + SignExtImm64*4; // Jump to the target address
         end
         // Check for conditional branch
         else if (Branch && ALUZero) begin
            NextPC = CurrentPC + SignExtImm64*4; // Jump to the target address if condition is met
         end
        // If neither, NextPC remains as CurrentPC + 4
    end
endmodule
