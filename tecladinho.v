
module tecladinho(clk,memlinha,memcoluna,num2,num);
    output reg [1:4]memcoluna;
    wire [1:4]deb;
    input [1:4]memlinha;
    output reg [13:0]num;
    output reg [13:0]num2;
    input clk;
    reg clk2;
    integer count; 
   
    debounce D0(clk, memlinha[1], deb[1]);
    debounce D1(clk, memlinha[2], deb[2]);
    debounce D2(clk, memlinha[3], deb[3]);
    debounce D3(clk, memlinha[4], deb[4]);
   
    //module pra clock auxiliar
   
    initial begin
        num<=0;
        memcoluna<=4'b0111;
        num <= 0;
    end
    
    always@(posedge clk)begin
		if(count==1000000)begin
			clk2<=~clk2;
			count<=0;
		end
		else begin
			count<=count+1;
		end
	end
	
	
	always@(posedge clk2)begin
		if(memcoluna==4'b0111)
			memcoluna<=4'b1011;
		else if(memcoluna==4'b1011)
			memcoluna<=4'b1101;
		else if(memcoluna==4'b1101)
			memcoluna<=4'b0111;
	end
	
	
	
	always@(posedge clk2)begin    
		if(memcoluna==4'b0111)begin
			if(memlinha==4'b0111)begin
				num<=(num*10+1)%10000;
			end
			else if(memlinha==4'b1011)begin
				num<=(num*10+4)%10000;
			end
			else if(memlinha==4'b1101)begin
				num<=(num*10+7)%10000;
			end
		end
		else if(memcoluna==4'b1011)begin
			if(memlinha==4'b0111)begin
				num<=(num*10+2)%10000;
			end
			else if(memlinha==4'b1011)begin
				num<=(num*10+5)%10000;
			end
			else if(memlinha==4'b1101)begin
				num<=(num*10+8)%10000;
			end
			else if(memlinha==4'b1110)begin
				num<=(num*10)%10000;
			end
		end
		else if(memcoluna==4'b1101)begin
		//else begin
			if(memlinha==4'b0111)begin
				num<=(num*10+3)%10000;
			end
			else if(memlinha==4'b1011)begin
				num<=(num*10+6)%10000;
			end
			else if(memlinha==4'b1101)begin
				num<=(num*10+9)%10000;
			end
			else if(memlinha==4'b1110)begin
				num2<=num;
			end
		end
    end/*
	always@(posedge clk2)begin    
		if(memcoluna==4'b0111)begin
			if(memlinha==4'b0111)begin
				num<=(num*10+1)%10000;
			end
			else if(memlinha==4'b1011)begin
				num<=(num*10+4)%10000;
			end
			else if(memlinha==4'b1101)begin
				num<=(num*10+7)%10000;
			end
		end
    end
    always@(posedge clk2)begin    
		if(memcoluna==4'b1011)begin
			if(memlinha==4'b0111)begin
				num<=(num*10+2)%10000;
			end
			else if(memlinha==4'b1011)begin
				num<=(num*10+5)%10000;
			end
			else if(memlinha==4'b1101)begin
				num<=(num*10+8)%10000;
			end
			else if(memlinha==4'b1110)begin
				num<=(num*10)%10000;
			end
		end
    end
    always@(posedge clk2)begin    
		if(memcoluna==4'b1101)begin
			if(memlinha==4'b0111)begin
				num<=(num*10+3)%10000;
			end
			else if(memlinha==4'b1011)begin
				num<=(num*10+6)%10000;
			end
			else if(memlinha==4'b1101)begin
				num<=(num*10+9)%10000;
			end
			else if(memlinha==4'b1110)begin
				num2<=num;
			end
		end
    end*/
   
endmodule
