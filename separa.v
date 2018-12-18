module separa( numero , numero0 , numero1 , numero2 , numero3); //para decompor o número em 4 dígitos
    input [13:0]numero;      
    output reg [3:0]numero0;
    output reg [3:0]numero1;
    output reg [3:0]numero2;
    output reg [3:0]numero3;
    reg [13:0]aux;
    always@(numero)begin
        numero3 = numero/1000;
        aux = numero%1000;
        numero2 = aux/100;
        aux = aux%100;
        numero1 = aux/10;
        aux= aux%10;
        numero0 = aux;
    end
    //divide o número 
endmodule