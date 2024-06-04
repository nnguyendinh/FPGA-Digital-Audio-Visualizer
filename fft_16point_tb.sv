//Timescale specifies the clock frequency/period
`timescale 1 ns/1 ns

module fft_16point_tb(out0, out1, out2, out3, out4, out5, out6, out7, 
							out8, out9, out10, out11, out12, out13, out14, out15,
							clk, reset, start, done);
output reg clk;
output reg reset;
output reg start;
reg [35:0] in0;
reg [35:0] in1;
reg [35:0] in2;
reg [35:0] in3;
reg [35:0] in4;
reg [35:0] in5;
reg [35:0] in6;
reg [35:0] in7;
reg [35:0] in8;
reg [35:0] in9;
reg [35:0] in10;
reg [35:0] in11;
reg [35:0] in12;
reg [35:0] in13;
reg [35:0] in14;
reg [35:0] in15;

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

output wire done;
// wire done_16;

initial begin
	clk = 0;
	reset = 0;
	start = 1;

	in0 = {18'd100, 18'b0};
	in1 = {18'd100, 18'b0};
	in2 = {18'd100, 18'b0};
	in3 = {18'd100, 18'b0};
	in4 = {18'd200, 18'b0};
	in5 = {18'd200, 18'b0};
	in6 = {18'd200, 18'b0};
	in7 = {18'd200, 18'b0};
	in8 = {18'd300, 18'b0};
	in9 = {18'd300, 18'b0};
	in10 = {18'd300, 18'b0};
	in11 = {18'd300, 18'b0};
	in12 = {18'd400, 18'b0};
	in13 = {18'd400, 18'b0};
	in14 = {18'd400, 18'b0};
	in15 = {18'd400, 18'b0};

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
$display("Fr 4: real: %d + imaginary %d", $signed(out4[35:18]), $signed(out4[17:0]));
$display("Fr 5: real: %d + imaginary %d", $signed(out5[35:18]), $signed(out5[17:0]));
$display("Fr 6: real: %d + imaginary %d", $signed(out6[35:18]), $signed(out6[17:0]));
$display("Fr 7: real: %d + imaginary %d", $signed(out7[35:18]), $signed(out7[17:0]));
$display("Fr 8: real: %d + imaginary %d", $signed(out8[35:18]), $signed(out8[17:0]));
$display("Fr 9: real: %d + imaginary %d", $signed(out9[35:18]), $signed(out9[17:0]));
$display("Fr 10: real: %d + imaginary %d", $signed(out10[35:18]), $signed(out10[17:0]));
$display("Fr 11: real: %d + imaginary %d", $signed(out11[35:18]), $signed(out11[17:0]));
$display("Fr 12: real: %d + imaginary %d", $signed(out12[35:18]), $signed(out12[17:0]));
$display("Fr 13: real: %d + imaginary %d", $signed(out13[35:18]), $signed(out13[17:0]));
$display("Fr 14: real: %d + imaginary %d", $signed(out14[35:18]), $signed(out14[17:0]));
$display("Fr 15: real: %d + imaginary %d", $signed(out15[35:18]), $signed(out15[17:0]));
// Stop the simulation
//$stop;
end
fft_16point UUT(.clk(clk), .reset(reset), .start(start), .in0(in0), .in1(in1), .in2(in2), .in3(in3), .in4(in4), .in5(in5), .in6(in6), .in7(in7), .in8(in8), .in9(in9), .in10(in10), .in11(in11), .in12(in12), .in13(in13), .in14(in14), .in15(in15),
	.out0(out0), .out1(out1), .out2(out2), .out3(out3), .out4(out4), .out5(out5), .out6(out6), .out7(out7), .out8(out8), .out9(out9), .out10(out10), .out11(out11), .out12(out12), .out13(out13), .out14(out14), .out15(out15), 
	.done(done));
endmodule
