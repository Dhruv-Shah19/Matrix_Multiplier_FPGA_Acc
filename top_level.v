module top_level(
   input [31:0] X, Y,
   output [31:0] Res_to_c,
   input clk
); 

   wire [31:0]A,B,Res;
    reg read, read4mat, read4c, write, cs, trig, utrig,reset,trigmult;

    // Parameter definition
    parameter N = 2; // Define N here

    // Instantiate RAM module
    RAm_fpga ram_inst (
        .reset(reset),
        .read(read),
      .read4mat(read4mat),
      .read4c(read4c),
        .write(write),
        .cs(cs),
        .clk(clk),
        .trig(trig),
        .utrig(utrig),
      .X(X),
      .Y(Y),
      .A(A),
      .B(B),
      .Res(Res),
      .Res_to_c(Res_to_c)
    );

    // Instantiate Matrix Multiplier module
    MATMUL #(N) matmul_inst (
        .A(A),
        .B(B),
      .clk(clk),
      .trigmult(trigmult),
        .Res(Res)
    );

reg [3:0] crntst = 4'b0000;

parameter state_0 = 4'b0000,
          state_1 = 4'b0001,
       state_2 = 4'b0010,
       state_3 = 4'b0011,
       state_4 = 4'b0100,
       state_5 = 4'b0101,
       state_6 = 4'b0110;
       
       
always @(posedge clk)
begin
  case(crntst)
  
    state_0:begin // idle
          reset <= 1'b1;
          read <= 1'b0;
          write <= 1'b0;
          cs <= 1'b1;
          trig <= 1'b0;
          utrig <= 1'b0;
          crntst <= 4'b0001;
          end
    state_1:begin // write X&Y in ram
          reset <= 1'b0;
          read <= 1'b0;
          write <= 1'b1;
          cs <= 1'b1;
          trig <= 1'b0;
          utrig <= 1'b1;
          
          trigmult <= 1'b0;
          crntst <= 4'b0010;
          end
    state_2:begin // load A&B in MatMUL
          reset <= 1'b0;
          read <= 1'b1;
          read4mat <= 1'b1;
          read4c <= 1'b0;
          write <= 1'b0;
          cs <= 1'b1;
          trig <= 1'b0;
          utrig <= 1'b0;
          
          trigmult <= 1'b0;
          crntst <= 4'b0011;
          end
    state_3:begin // halt
          reset <= 1'b0;
          read <= 1'b0;
          read4mat <= 1'b0;
          read4c <= 1'b0;
          write <= 1'b0;
          cs <= 1'b0;
          trig <= 1'b0;
          utrig <= 1'b0;
          
          trigmult <= 1'b1;
          crntst <= 4'b0100;
          end
    state_4:begin // write res of matMUL to ram
          reset <= 1'b0;
          read <= 1'b0;
          read4mat <= 1'b0;
          read4c <= 1'b0;
          write <= 1'b1;
          cs <= 1'b1;
          trig <= 1'b1;
          utrig <= 1'b0;
          
          trigmult <= 1'b0;
          crntst <= 4'b0101;
          end
    state_5:begin // read res in ram to cpu
          reset <= 1'b0;
          read <= 1'b1;
          read4mat <= 1'b0;
          read4c <= 1'b1;
          write <= 1'b0;
          cs <= 1'b1;
          trig <= 1'b0;
          utrig <= 1'b0;
          
          trigmult <= 1'b0;
          crntst <= 4'b0000;
          end
  endcase
end
endmodule

