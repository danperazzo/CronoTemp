//DIVIDIR O CLOCK PRA MANDAR ESSE NOVO CLOCK PRA FAZER O DEBOUNCING
module DebounceDivideCLK(CLK, Clock);
    input CLK; //Clock que será dividido
    output reg Clock; //Clock dividido
    reg [26:0]counter = 0;
    always @(posedge CLK)
    begin
        counter <= (counter >= 249999)?0:counter+1;
        Clock <= (counter < 125000)?1'b0:1'b1;
    end
endmodule
//