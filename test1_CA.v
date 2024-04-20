module test1_CA(
    input [7:0] A[3:0][3:0], // Input matrix A, assuming 4x4 matrix with 8-bit elements
    input [7:0] B[3:0][3:0], // Input matrix B, assuming 4x4 matrix with 8-bit elements
    output reg [15:0] result[3:0][3:0] // Output matrix, assuming 4x4 matrix with 16-bit elements
);

integer i, j, k;

always @(*) begin
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 4; j = j + 1) begin
            result[i][j] = 0; // Initialize result matrix element to 0
            for (k = 0; k < 4; k = k + 1) begin
                result[i][j] = result[i][j] + (A[i][k] * B[k][j]); // Perform matrix multiplication
            end
        end
    end
end

endmodule



//module test1_CA (
//    input clk,           // Clock input
//    input reset,         // Reset input
//    input [255:0] a,   // Input vector A
//    input [255:0] b,   // Input vector B
//    output reg [511:0] result // Output vector result
//);
//    always @(posedge clk or posedge reset) begin
//			if (reset) 
//				begin
//					result <= 14'b0; // Clear output vector
//				end 
//			else 
//				begin
//					result <= a * b; // Perform multiplication
//            end
//    end
//endmodule
