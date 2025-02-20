`define I 4'b000
`define D 4'b001
`define B 4'b010
`define CB 4'b011
`define MZ 4'b100

module SignExtender_Example(BusImm, Imm32, Ctrl); 
   output [63:0] BusImm; 
   input [31:0] Imm32; 
   input [2:0] Ctrl; 
   
   reg  [63:0] res;
   
   wire extBit; 
   always @(Ctrl or BusImm or Imm32) begin
      case(Ctrl)
         `I: begin
               res = {52'b0, Imm32[21:10]};
         end
         `D: begin
               res = {{55{Imm32[20]}}, Imm32[20:12]};
         end
         `B: begin
               res = {{38{Imm32[25]}}, Imm32[25:0]};
         end
         `CB: begin
               res = {{45{Imm32[23]}}, Imm32[23:5]};
         end
         `MZ: begin
            case (Imm32[22:21])
               2'b00: res = {48'b0, Imm32[20:5]};
               2'b01: res = {32'b0, Imm32[20:5], 16'b0};
               2'b10: res = {16'b0, Imm32[20:5], 32'b0};
               2'b11: res = {Imm32[20:5], 48'b0};
            endcase
         end
      endcase
   end
   assign BusImm = res; 
endmodule
