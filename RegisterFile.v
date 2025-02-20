module RegisterFile(BusA, BusB, BusW, RA, RB, RW, RegWr, Clk);
    output [63:0] BusA;
    output [63:0] BusB;
    input [63:0] BusW;
    input RegWr;
    input Clk;
    input [4:0] RA, RB, RW;
    reg [63:0] registers [31:0];
     
    initial registers[31] = 0;

    // assign registers[0] = RA;
    // assign registers[1] = RB;

    assign BusA = registers[RA];
    assign BusB = registers[RB];
     
    always @ (negedge Clk) begin
        if(RegWr && RW != 31)
            registers[RW] <= BusW;
    end
endmodule
