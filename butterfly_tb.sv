`timescale 1 ns / 1 ns //Tells the simulator how long 1 "tick" is

// The testbench is defined simiarly to any other module!
module butterfly_tb(sum, diff);
  
	output [31:0] sum;
	output [31:0] diff;

	wire [31:0] w_0 = 32'h7fff0000;	// 1 + j0
	wire [31:0] w_1 = 32'h00008000; // 0 - j1
	wire [31:0] w_2 = 32'h80000000; // -1 + j0
	wire [31:0] w_3 = 32'h00007fff; // 0 + j1
	wire [31:0] a = 32'h00310041;
	wire [31:0] b = 32'h00120092;
  
	wire [15:0] a_real;
	wire [15:0] a_im;
	wire [15:0] WxB_real;
	wire [15:0] WxB_im;
	
	// Instantiate the module we're testing (and you're writing!)
	butterfly butt1(a, b, w_0, sum, diff, a_real, a_im, WxB_real, WxB_im);

	// Run this once at startup
	initial begin
  
		#1000
		$display("a_real=%d, a_im=%d, WxB_real=%d, WxB_im=%d", a_real, a_im, WxB_real, WxB_im);
		
		$display("f0 = %d", sum);
		$display("f1 = %d", diff);

		$stop;

	end
	
endmodule