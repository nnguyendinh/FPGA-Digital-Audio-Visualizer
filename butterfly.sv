module butterfly(a, b, w, sum, diff);
	
	parameter WIDTH = 36;
	
	// INPUTS
	input signed [WIDTH-1:0] a;
	input signed [WIDTH-1:0] b;
	input signed [WIDTH-1:0] w;
	
	// OUTPUTS
	output [WIDTH-1:0] sum;
	output [WIDTH-1:0] diff;
	
	// SPLIT INTO REAL & IMAGINARY
	reg [(WIDTH/2)-1:0] w_real;	// [15:0]
	reg [(WIDTH/2)-1:0] w_im;
	reg [(WIDTH/2)-1:0] b_real;
	reg [(WIDTH/2)-1:0] b_im;
	reg [(WIDTH/2)-1:0] a_real;
	reg [(WIDTH/2)-1:0] a_im;
	
	// PRODUCTS
	reg [WIDTH-1:0] product1;		// [31:0]
	reg [WIDTH-1:0] product2;		
	reg [WIDTH-1:0] product3;
	reg [WIDTH-1:0] product4;
	
	// TRUNCATED PRODUCTS
	reg [(WIDTH/2)-1:0] result1;	// [15:0]
	reg [(WIDTH/2)-1:0] result2;
	reg [(WIDTH/2)-1:0] result3;
	reg [(WIDTH/2)-1:0] result4;
	
	// OUTPUTS
	reg [(WIDTH/2)-1:0] WxB_real;
	reg [(WIDTH/2)-1:0] WxB_im;
	
	assign w_real 	= w[WIDTH-1:(WIDTH/2)];	// w[31:16]
	assign w_im 	= w[(WIDTH/2)-1:0];
	assign b_real 	= b[WIDTH-1:(WIDTH/2)];
	assign b_im 	= b[(WIDTH/2)-1:0];
	assign a_real 	= a[WIDTH-1:(WIDTH/2)];
	assign a_im 	= a[(WIDTH/2)-1:0];
	
	//W * B = (W_real + j * W_im) * (B_real + j * B_im)
	//W * B = (W_real * B_real - W_im * B_im) + j * (B_real * W_im + W_real * B_im)
	//				product 1			product 2				product 3		product 4
	
	assign product1 	= w_real * b_real;
	assign result1 	= product1[WIDTH - 2:(WIDTH/2)-1];

	assign product2 	= w_im * b_im;
	assign result2 	= product2[WIDTH - 2:(WIDTH/2)-1];
	
	assign product3 	= w_im * b_real;
	assign result3 	= product3[WIDTH - 2:(WIDTH/2)-1];
	
	assign product4 	= w_real * b_im;
	assign result4 	= product4[WIDTH - 2:(WIDTH/2)-1];
	
	assign WxB_real 	= result1 - result2;
	assign WxB_im 		= result3 + result4;
	
	assign sum			= {a_real + WxB_real, a_im + WxB_im};
	assign diff 		= {a_real - WxB_real, a_im - WxB_im};
	
endmodule