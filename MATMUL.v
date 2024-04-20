module MATMUL #(parameter N = 2)(
    input [N*N*8-1:0] A,
    input [N*N*8-1:0] B,
    output reg [N*N*8-1:0] Res
);

    // Internal variables
    reg [N*8-1:0] Res_temp [0:N-1][0:N-1];
    reg [N*8-1:0] A_temp [0:N-1][0:N-1];
    reg [N*8-1:0] B_temp [0:N-1][0:N-1];
    integer i, j, k;

    always @* begin
        // Initialize the matrices - convert 1D to 2D arrays
        for (i = 0; i < N; i = i + 1)
            for (j = 0; j < N; j = j + 1)
                A_temp[i][j] = A[(i*N+j)*8 +: 8];

        for (i = 0; i < N; i = i + 1)
            for (j = 0; j < N; j = j + 1)
                B_temp[i][j] = B[(i*N+j)*8 +: 8];

        // Initialize Res_temp to zeros
        for (i = 0; i < N; i = i + 1)
            for (j = 0; j < N; j = j + 1)
                Res_temp[i][j] = 0;

        // Matrix multiplication
        for (i = 0; i < N; i = i + 1)
            for (j = 0; j < N; j = j + 1)
                for (k = 0; k < N; k = k + 1)
                    Res_temp[i][j] = Res_temp[i][j] + (A_temp[i][k] * B_temp[k][j]);

        // Final output assignment - 2D array to 1D array conversion
        for (i = 0; i < N; i = i + 1)
            for (j = 0; j < N; j = j + 1)
                Res[(i*N+j)*8 +: 8] = Res_temp[i][j];
    end

endmodule



module tb;

    // Parameters
    parameter N = 2; // Change N to test different matrix sizes

    // Inputs
    reg [N*N*8-1:0] A;
    reg [N*N*8-1:0] B;

    // Outputs
    wire [N*N*8-1:0] Res;
	 integer i,j;
    // Instantiate the Unit Under Test (UUT)
    MATMUL #(N) uut (
        .A(A), 
        .B(B), 
        .Res(Res)
    );

    // Define clock
    reg clk;
    initial clk = 0;
    always #5 clk = ~clk;

    // Test stimulus
    initial begin
	 
        // Apply Inputs
        A = 0;  B = 0;  #100;
        // Set up sample matrices
        A = {8'd1,8'd2,8'd3,8'd4};
        B = {8'd9,8'd8,8'd7,8'd6};
        #100; // Wait for calculation

        // Display results
        $monitor("Matrix A:");
        for (i = 0; i < N; i = i + 1) begin
            for (j = 0; j < N; j = j + 1)
                $monitor("%d ", A[(i*N+j)*8 +: 8]);
            $monitor("");
        end

        $monitor("Matrix B:");
        for (i = 0; i < N; i = i + 1) begin
            for (j = 0; j < N; j = j + 1)
                $monitor("%d ", B[(i*N+j)*8 +: 8]);
            $monitor("");
        end

        $monitor("Result:");
        for (i = 0; i < N; i = i + 1) begin
            for (j = 0; j < N; j = j + 1)
                $monitor("%d ", Res[(i*N+j)*8 +: 8]);
            $monitor("");
        end

        // End simulation
        $finish;
    end
      
endmodule


////Module for calculating Res = A*B
////Where A,B and C are 2 by 2 matrices.
//module MATMUL(A,B,Res);
//
//    //input and output ports.
//    //The size 32 bits which is 2*2=4 elements,each of which is 8 bits wide.    
//    input [31:0] A;
//    input [31:0] B;
//    output [31:0] Res;
//    //internal variables    
//    reg [31:0] Res;
//    reg [7:0] A1 [0:1][0:1];
//    reg [7:0] B1 [0:1][0:1];
//    reg [7:0] Res1 [0:1][0:1]; 
//    integer i,j,k;
//
//    always@ (A or B)
//    begin
//    //Initialize the matrices-convert 1 D to 3D arrays
//        {A1[0][0],A1[0][1],A1[1][0],A1[1][1]} = A;
//        {B1[0][0],B1[0][1],B1[1][0],B1[1][1]} = B;
//        i = 0;
//        j = 0;
//        k = 0;
//        {Res1[0][0],Res1[0][1],Res1[1][0],Res1[1][1]} = 32'd0; //initialize to zeros.
//        //Matrix multiplication
//        for(i=0;i < 2;i=i+1)
//            for(j=0;j < 2;j=j+1)
//                for(k=0;k < 2;k=k+1)
//                    Res1[i][j] = Res1[i][j] + (A1[i][k] * B1[k][j]);
//        //final output assignment - 3D array to 1D array conversion.            
//        Res = {Res1[0][0],Res1[0][1],Res1[1][0],Res1[1][1]};            
//    end 
//
//endmodule