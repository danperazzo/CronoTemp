module main( clk , enable , funcao , reset , para , filete1 , filete2 , filete3 , filete4 , membpeg ,membsai);
   
    
    /* Definição dos inputs*/
    input clk; //clock
    input funcao; //funcao: se esta em temporizador ou cronometro
    input enable; //se esta rodando ou em config
    input reset; //reiniciar
    input para; //parar
    input [3:0]membpeg; //registra a membrana de deslocamento
   
    
    //parametors e constantes, definições de estados
    parameter CONF = 4'b0000, CRON = 4'b0001, TEMP = 4'b0010, PARAR = 4'b0011;
       
    //Outputs, o que aparecerá no display de 7 segmentos
    output  [6:0]filete1;
    output  [6:0]filete2;
    output  [6:0]filete3;
    output  [6:0]filete4;
    output  [3:0]membsai;
    
    
    //definição de quem é o registrador, os tipos
    reg [3:0]estado;
    reg [13:0]counter,counterAux;
    reg [26:0] pulsos,pulsosAux;
    reg [13:0]numero;
    reg [13:0]pegui;
    wire [3:0]n0;
    wire [3:0]n1;
    wire [3:0]n2;
    wire [3:0]n3;
    wire mempegfilt[3:0];
	
	
	Debounce D0(membpeg[0], clk, mempegfilt[0]);
	Debounce D1(membpeg[1], clk, mempegfilt[1]);
	Debounce D2(membpeg[2], clk, mempegfilt[2]);
	Debounce D3(membpeg[3], clk, mempegfilt[3]);
	
	
	
	//aq q sao os fillet sacou representante?
	separa princ(counter,n0,n1,n2,n3);
	
	decot dig0(n0,filete1);
	decot dig1(n1,filete2);
	decot dig2(n2,filete3);
	decot dig3(n3,filete4);
	
    //inicialização
    initial begin
        estado <= CONF;
        counter <= 14'd0;
        pulsos <= 27'd0;
        counterAux <= 14'd0;
        pulsosAux <= 27'd0;
        pegui<=1234;
 
    end
   
    /*---------------------Parte sequencial, MUDANÇA DE ESTADOS---------------*/
    always@ (posedge clk or negedge para or negedge reset) begin
   
       /* if(!reset)begin
            if( (estado == CRON) || (estado == PARAR && funcao == 0))begin
                if(estado == PARAR)
                    estado <= CRON;
                                   
            end
            else if( (estado == TEMP) || (estado == PARAR && funcao == 1))begin
                if(estado == PARAR)
                    estado <= TEMP;              
            end  
        end
        */ //que porra eh essa albuquero?
        
        if (!para) begin //checar se quando aperto o botao vai pra 1 ou pra 0
			if(
            if(  (estado == CRON) || (estado == TEMP) )begin
                estado <= PARAR;
            end
            else if(estado == PARAR) begin
                estado <= funcao + 1'd1; //funcao deve ser uma reg input
            end			
        end
       
        case(estado)
       
            //se estiver no estagio de configuração, para trocar
            CONF: begin
            
                if(enable==1'd1 && funcao==1'd1)begin
                    estado <= TEMP;
                end
               
                else if(enable==1'd1 && funcao==1'd0)begin
                    estado <= CRON;
                end
                
                
            end
           
            //se estiver no estágio de temporizador
            TEMP:begin
                if(enable==1'd0) begin
                    estado <= CONF;
                end
                else if(counter<=0) begin
                        estado <= CONF;
                end
            end
           
            //se estiver no estado de cronometro
            CRON:begin
                if(enable==1'd0)begin
                    estado<=CONF;
                end
                else if (counter >= numero) begin
                    estado <= CONF;
                end
            end
           
            //se estiver parado
            PARAR:begin
                if(enable==1'd0)begin
                    estado<=CONF;
                end
                else if(funcao==0 && counterAux == numero) begin
                    estado <= CONF;
                end
                else if(funcao==1 && counterAux == 0) begin
                    estado <= CONF;
                end
               
            end//falta botao parar
           
        endcase
    end
   
    //PARTE COMBINACIONAL, AQUI EH ONDE A MAGICA ACONTECE
    always@ (posedge clk or negedge reset or negedge para) begin
   
        if(!reset)begin
            if( (estado == CRON) || (estado == PARAR && funcao == 0))begin
                pulsos <= 27'd0;
                counter <= 14'd0;
                pulsosAux <= 27'd0;
                counterAux <= 14'd0;
               
            end
            else if( (estado == TEMP) || (estado == PARAR && funcao == 1))begin        
                pulsos <= 27'd0;
                counter <= numero;
                pulsosAux <= 27'd0;
                counterAux <= 14'd0;      
               
            end  
        end
        if (!para) begin
            if(  (estado == CRON) || (estado == TEMP) )begin
           
                counterAux <= counter;
                pulsosAux <= pulsos;
           
            end
            else if(estado == PARAR) begin
                counter <= counterAux;
                pulsos <= pulsosAux;
            end
           
        end
   
        case(estado)
       
            CONF: begin
               
				counter <=pegui;
             
                
                if(enable==1'd1 && funcao==1'd1)begin
                    counter <= pegui;
                    pulsos <= 27'd0;
                end
               
                else if(enable==1'd1 && funcao==1'd0)begin
                    counter <= 14'd0;
                    pulsos <= 27'd0;
                end
                
            end
       
            //Subtrair
            TEMP:begin
                if(pulsos == 27'd50000000) begin
                    pulsos <= 27'd0;
                    if(counter > 0)begin
                        counter <= counter - 1'd1;
                    end
                   
                end
                else
                    pulsos <= pulsos + 1'd1;
            end
           
            //somar
            CRON: begin
           
                if(pulsos == 27'd50000000) begin
                        pulsos <= 27'd0;
                        if(counter < numero)begin
                            counter <= counter+1'd1;
                        end
                end
                else
                    pulsos <= pulsos + 1'd1;
               
             
            end
           
            //Ação de parar
            PARAR:begin
                if(funcao == 0) begin
                    if(pulsosAux == 27'd50000000) begin
                        pulsosAux <= 27'd0;
                        if(counterAux < numero)begin
                            counterAux <= counterAux +1'd1;
                        end
                    end
                    else
                        pulsosAux <= pulsosAux + 1'd1;
                end
               
                if(funcao == 1) begin  
                    if(pulsosAux == 27'd50000000) begin
                        pulsosAux <= 27'd0;
                        if(counterAux > 0)begin
                            counterAux <= counterAux - 1'd1;
                        end
                    end
                        else
                            pulsosAux <= pulsosAux + 1'd1;    
                end
            end
       
        endcase
    end
   
   
    endmodule
    //heeeh