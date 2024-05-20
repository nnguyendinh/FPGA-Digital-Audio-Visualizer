//Timescale specifies the clock frequency/period
`timescale 1 ns/1 ns

module fft_16point_tb(out0, out1, out2, out3, out4, out5, out6, out7, 
							out8, out9, out10, out11, out12, out13, out14, out15,
							 fly1_sum, fly1_diff, fly2_sum, fly2_diff, clk, reset, start);
output reg clk;
output reg reset;
output reg start;
output [35:0] in0;
output [35:0] in1;
output [35:0] in2;
output [35:0] in3;
output [35:0] in4;
output [35:0] in5;
output [35:0] in6;
output [35:0] in7;
output [35:0] in8;
output [35:0] in9;
output [35:0] in10;
output [35:0] in11;
output [35:0] in12;
output [35:0] in13;
output [35:0] in14;
output [35:0] in15;

output [35:0] out0;
output [35:0] out1;
output [35:0] out2;
output [35:0] out3;
output [35:0] out4;
output [35:0] out5;
output [35:0] out6;
output [35:0] out7;
output [35:0] out8;
output [35:0] out9;
output [35:0] out10;
output [35:0] out11;
output [35:0] out12;
output [35:0] out13;
output [35:0] out14;
output [35:0] out15;

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
$display("Finished for 36 bit!");
$display("Fr 0: real: %d + imaginary %d", $signed(out0[35:18]), $signed(out0[17:0]));
$display("Fr 1: real: %d + imaginary %d", $signed(out1[35:18]), $signed(out1[17:0]));
$display("Fr 2: real: %d + imaginary %d", $signed(out2[35:18]), $signed(out2[17:0]));
$display("Fr 3: real: %d + imaginary %d", $signed(out3[35:18]), $signed(out3[17:0]));
end
fft_16point UUT(.clk(clk), .reset(reset), .start(start), .in0(in0), .in1(in1), .in2(in2), .in3(in3),
	.out0(out0), .out1(out1), .out2(out2), .out3(out3), .done(done), .fly1_sum(fly1_sum), .fly1_diff(fly1_diff), .fly2_sum(fly2_sum), .fly2_diff(fly2_diff));
endmodule
