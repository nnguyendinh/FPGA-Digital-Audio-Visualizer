//Timescale specifies the clock frequency/period
`timescale 1 ns/1 ns

module fft_4point_tb(out0, out1, out2, out3, out0_16, out1_16, out2_16, out3_16, fly1_sum, fly1_diff, fly2_sum, fly2_diff, clk, reset, start);
output reg clk;
output reg reset;
output reg start;
reg [31:0] in0;
reg [31:0] in1;
reg [31:0] in2;
reg [31:0] in3;

output [31:0] out0;
output [31:0] out1;
output [31:0] out2;
output [31:0] out3;
output [15:0] out0_16;
output [15:0] out1_16;
output [15:0] out2_16;
output [15:0] out3_16;

output [31:0] fly1_sum;
output [31:0] fly1_diff;
output [31:0] fly2_sum;
output [31:0] fly2_diff;


wire done;
wire done_16;


initial begin
	clk = 0;
	reset = 0;
	start = 1;
	in0 = 32'h00000000;
	in1 = 32'h00010000;
	in2 = 32'h00020000;
	in3 = 32'h00030000;
end

always begin
	#10
	clk = ~clk;
end

always @(posedge done) begin
$display("Finished for 32 bit!");
$display("Fr 0: real: %d + imaginary %d", $signed(out0[31:16]), $signed(out0[15:0]));
$display("Fr 1: real: %d + imaginary %d", $signed(out1[31:16]), $signed(out1[15:0]));
$display("Fr 2: real: %d + imaginary %d", $signed(out2[31:16]), $signed(out2[15:0]));
$display("Fr 3: real: %d + imaginary %d", $signed(out3[31:16]), $signed(out3[15:0]));
//$display("Finished for 16 bit!");
//$display("Fr 0: imaginary: %d + real %d", $signed(out0_16[15:8]), $signed(out0_16[7:0]));
//$display("Fr 1: imaginary: %d + real %d", $signed(out1_16[15:8]), $signed(out1_16[7:0]));
//$display("Fr 2: imaginary: %d + real %d", $signed(out2_16[15:8]), $signed(out2_16[7:0]));
//$display("Fr 3: imaginary: %d + real %d", $signed(out3_16[15:8]), $signed(out3_16[7:0]));
end
fft_4point_32bit UUT1(.clk(clk), .reset(reset), .start(start), .in0(in0), .in1(in1), .in2(in2), .in3(in3),
	.out0(out0), .out1(out1), .out2(out2), .out3(out3), .done(done), .fly1_sum(fly1_sum), .fly1_diff(fly1_diff), .fly2_sum(fly2_sum), .fly2_diff(fly2_diff));
//fft_4point_16bit UUT2(.clk(clk), .reset(reset), .start(start), .in0(in0[31:16]), .in1(in1[31:16]), .in2(in2[31:16]), .in3(in3[31:16]), 
//	.out0(out0_16), .out1(out1_16), .out2(out2_16), .out3(out3_16), .done(done_16));
endmodule
