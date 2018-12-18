//NA NOSSA PLACA DE FPGA
//CLOCK = 50MHz (50.10ˆ6 voltas por segundo)
//PERÍODO = 20ns (1 "volta" a cada 20.10ˆ-9 segundos)
//1 milhão de "voltas" fica 20ms (20.10ˆ-3 segundos) //eu vi na internet que 1milhão de "voltas" era o melhor tempo pra botar no count
 
 
module debounce(CLK,  B,ApertaB);
 
    input CLK;
    input B;            //o botão
    output reg ApertaB; //Apertou o botão
 
 
    //DEFINIR OS 4 ESTADOS DO BOTÃO
 
    parameter PARADO   = 4'b0001;  //ta parado (o botão ta no 1)
    parameter FILTRO1  = 4'b0010;  //o debounce de descida (quando aperta o botão)
    parameter APERTADO = 4'b0100;  //foi apertado (ta no 0)
    parameter FILTRO2  = 4'b1000;  //o debounce de subida (quando solta o botão)
 
    reg [19:0] Count; //isso vai contar ate 20ms
 
    reg EnableCount;
 
    reg B_1;
    reg B_2;
 
    always@(posedge CLK) begin
		B_1 <= B;
        B_2 <= B_1;
    end
 
 
    //VALORES TEMPORÁRIOS PRA CALCULAR O POSEDGE E NEGEDGE
 
    reg BTemp1;
    reg BTemp2;
 
    always@(posedge CLK ) begin
		BTemp1 <= B_2;
        BTemp2 <= BTemp1;
    end
 
 
    //CALCULANDO O POSEDGE E NEGEDGE
 
    wire Pedge; //posedge
    wire Nedge; //negedge
 
    assign Nedge = (!BTemp1) & BTemp2;
    assign Pedge = BTemp1 & (!BTemp2);
 
 
    //A MÁQUINA DE ESTADOS
 
    reg[3:0] estado;
    reg CountFull; //dizer se o count chegou nos 20ms
 
    always@(posedge CLK) begin
    
            case(estado)
                PARADO: begin //estado PARADO = não apertou nem soltou
                    ApertaB <= 1'b1;
                    if(Nedge) begin //se tiver negedge vai pro FILTRO1
                        estado <= FILTRO1;
                        EnableCount <= 1'b1;
                    end
                    else begin
                        estado <= PARADO;
                    end
                end
 
                FILTRO1: begin
                    if(CountFull) begin //se no FILTRO1, o count ficar full, significa que o Botão foi apertado
                        ApertaB <= 1'b0; //o botão foi apertado
                        EnableCount <= 1'b0;
                        estado <= APERTADO; //vai pra APERTADO
                    end
                    else if(Pedge) begin //se rolar um posedge, vai pra PARADO
                        estado <= PARADO;
                        EnableCount <= 1'b0;
                    end
                    else begin
                        estado <= FILTRO1;
                    end
                end
 
                APERTADO: begin
                    ApertaB <= 1'b1;
                    if(Pedge) begin //no estado APERTADO, se tiver posedge, é pra ir pro FILTRO2
                        estado <= FILTRO2;
                        EnableCount <= 1'b1;
                    end
                    else begin
                        estado <= APERTADO;
                    end
                end
 
                FILTRO2: begin
                    if(CountFull) begin //no FILTRO2, se o count chegar em 20ms, significa q o botão foi solto
                        EnableCount <= 1'b0;
                        estado <= PARADO; //soltou o botão, vai pra PARADO
                    end
                    else if(Nedge) begin
                        EnableCount <= 1'b0;
                        estado <= APERTADO;
                    end
                    else begin
                        estado <= FILTRO2;
                    end
                end
 
                default: begin
                    estado <= PARADO; //no default, vai pra PARADO
                    EnableCount <= 1'b0;
                    ApertaB <= 1'b1;
                end
            endcase
            
    end
 
    always@(posedge CLK) begin
        if(EnableCount) begin
            Count <= Count + 1'b1;
        end
        else begin
            Count <= 20'd0;
        end
    end
 
    always@(posedge CLK) begin
        if(Count == 999999) begin //Se o count chegar em 1milhão (20ms) fica full
            CountFull <= 1'b1;
        end
        else begin
            CountFull <= 1'b0;
        end
    end
endmodule
