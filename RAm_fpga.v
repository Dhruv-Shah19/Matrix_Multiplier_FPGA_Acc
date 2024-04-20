module RAm_fpga(input reset,read,read4mat,read4c,write,cs,clk,trig,utrig,input [31:0] X, Y, output reg [31:0] A, B, Res_to_c,Res); //output reg [127:0] out);

reg [31:0]mem[0:3];
integer i;

always @(posedge clk) 
begin
	if(cs)
		begin
			if(reset)
				begin
					for(i=0;i<4;i=i+1)
						mem[i] <= 32'b0;
				end
			else 
				begin
					if(read) /// matmul wants to read a and b from it
						begin
							if(read4mat)
							begin
								A <= mem[0];
								B <= mem[1];
							end
							if(read4c)
								Res_to_c <= mem[2];
						end
					else if(write) /// write 
						begin
							if(trig)  // res of matmul to ram
								mem[2] <=  Res;
							if(utrig) // cpu to ram ( feed a and b )
								begin
									mem[0] <= X; // uart will send value
									mem[1] <= Y; // uart will send value
								end
						end
				end
		end
end

endmodule
