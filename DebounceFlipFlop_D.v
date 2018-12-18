module DebounceFlipFlop_D(CLK, D, Q);
    input CLK; //Clock do FlipFlop-D
    input D;
    output reg Q;
    always @ (posedge CLK) begin
        Q <= D;
    end
endmodule
 
