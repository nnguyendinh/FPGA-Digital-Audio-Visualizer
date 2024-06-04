module fft_16point(clk, reset, start, in0, in1, in2, in3, in4, in5, in6, 
					in7, in8, in9, in10, in11, in12, in13, in14, in15, 
					out0, out1, out2, out3, out4, out5, out6, out7, 
					out8, out9, out10, out11, out12, out13, out14, out15,
					done);
	
	// INPUTS
	input clk;
	input reset;
	input start;
	input [35:0] in0;
	input [35:0] in1;
	input [35:0] in2;
	input [35:0] in3;
	input [35:0] in4;
	input [35:0] in5;
	input [35:0] in6;
	input [35:0] in7;
	input [35:0] in8;
	input [35:0] in9;
	input [35:0] in10;
	input [35:0] in11;
	input [35:0] in12;
	input [35:0] in13;
	input [35:0] in14;
	input [35:0] in15;
	
	// OUTPUTS
	output reg [35:0] out0 = 0;
	output reg [35:0] out1 = 0;
	output reg [35:0] out2 = 0;
	output reg [35:0] out3 = 0;
	output reg [35:0] out4 = 0;
	output reg [35:0] out5 = 0;
	output reg [35:0] out6 = 0;
	output reg [35:0] out7 = 0;
	output reg [35:0] out8 = 0;
	output reg [35:0] out9 = 0;
	output reg [35:0] out10 = 0;
	output reg [35:0] out11 = 0;
	output reg [35:0] out12 = 0;
	output reg [35:0] out13 = 0;
	output reg [35:0] out14 = 0;
	output reg [35:0] out15 = 0;
	output reg done = 0;
	
	// STATES
	localparam RESET = 0;
	localparam STAGE_1 	= 1;
	localparam STAGE_2 	= 2;
	localparam STAGE_3 = 3;
	localparam STAGE_4 = 4;
	localparam DONE = 5;
	
	reg [2:0] state = RESET;
	reg [2:0] next_state = RESET;
	
	// TWIDDLE FACTORS
	localparam W_0_16		= 36'b011111111111111111_000000000000000000;
	localparam W_1_16		= 36'b011101100100000111_110011110000010001;
	localparam W_2_16		= 36'b010110101000001010_101001010111110110;
	localparam W_3_16		= 36'b001100001111101111_100010011011111001;
	localparam W_4_16		= 36'b000000000000000000_100000000000000000;
	localparam W_5_16		= 36'b110011110000010001_100010011011111001;
	localparam W_6_16		= 36'b101001010111110110_101001010111110110;
	localparam W_7_16		= 36'b100010011011111001_110011110000010001;

	// INTERMEDIARY
	reg [35:0] fly0_a;
	reg [35:0] fly0_b;
	reg [35:0] fly0_w;
	reg [35:0] d_fly0_sum;
	reg [35:0] d_fly0_diff;
	reg [35:0] fly0_sum;
	reg [35:0] fly0_diff;

	reg [35:0] fly1_a;
	reg [35:0] fly1_b;
	reg [35:0] fly1_w;
	reg [35:0] d_fly1_sum;
	reg [35:0] d_fly1_diff;
	reg [35:0] fly1_sum;
	reg [35:0] fly1_diff;
	
	reg [35:0] fly2_a;
	reg [35:0] fly2_b;
	reg [35:0] fly2_w;
	reg [35:0] d_fly2_sum;
	reg [35:0] d_fly2_diff;
	reg [35:0] fly2_sum;
	reg [35:0] fly2_diff;

	reg [35:0] fly3_a;
	reg [35:0] fly3_b;
	reg [35:0] fly3_w;
	reg [35:0] d_fly3_sum;
	reg [35:0] d_fly3_diff;
	reg [35:0] fly3_sum;
	reg [35:0] fly3_diff;

	reg [35:0] fly4_a;
	reg [35:0] fly4_b;
	reg [35:0] fly4_w;
	reg [35:0] d_fly4_sum;
	reg [35:0] d_fly4_diff;
	reg [35:0] fly4_sum;
	reg [35:0] fly4_diff;

	reg [35:0] fly5_a;
	reg [35:0] fly5_b;
	reg [35:0] fly5_w;
	reg [35:0] d_fly5_sum;
	reg [35:0] d_fly5_diff;
	reg [35:0] fly5_sum;
	reg [35:0] fly5_diff;

	reg [35:0] fly6_a;
	reg [35:0] fly6_b;
	reg [35:0] fly6_w;
	reg [35:0] d_fly6_sum;
	reg [35:0] d_fly6_diff;
	reg [35:0] fly6_sum;
	reg [35:0] fly6_diff;

	reg [35:0] fly7_a;
	reg [35:0] fly7_b;
	reg [35:0] fly7_w;
	reg [35:0] d_fly7_sum;
	reg [35:0] d_fly7_diff;
	reg [35:0] fly7_sum;
	reg [35:0] fly7_diff;
	
	// Butterfly Units
	butterfly fly0(fly0_a, fly0_b, fly0_w, d_fly0_sum, d_fly0_diff);
	butterfly fly1(fly1_a, fly1_b, fly1_w, d_fly1_sum, d_fly1_diff);
  	butterfly fly2(fly2_a, fly2_b, fly2_w, d_fly2_sum, d_fly2_diff);
	butterfly fly3(fly3_a, fly3_b, fly3_w, d_fly3_sum, d_fly3_diff);
	butterfly fly4(fly4_a, fly4_b, fly4_w, d_fly4_sum, d_fly4_diff);
	butterfly fly5(fly5_a, fly5_b, fly5_w, d_fly5_sum, d_fly5_diff);
	butterfly fly6(fly6_a, fly6_b, fly6_w, d_fly6_sum, d_fly6_diff);
	butterfly fly7(fly7_a, fly7_b, fly7_w, d_fly7_sum, d_fly7_diff);
	
	// State register
	always @ (posedge clk, posedge reset) begin
		if (reset) begin
			state 		<= RESET;
			fly0_sum 	<= 0;
			fly0_diff 	<= 0;
			fly1_sum 	<= 0;
			fly1_diff 	<= 0;
			fly2_sum 	<= 0;
			fly2_diff	<= 0;
			fly3_sum 	<= 0;
			fly3_diff	<= 0;
			fly4_sum 	<= 0;
			fly4_diff 	<= 0;
			fly5_sum 	<= 0;
			fly5_diff	<= 0;
			fly6_sum 	<= 0;
			fly6_diff	<= 0;
			fly7_sum 	<= 0;
			fly7_diff 	<= 0;

			done 		<= 0;
		end
		else begin
			if (state == STAGE_1 || state == STAGE_2 || state == STAGE_3 || state == STAGE_4) begin
				fly0_sum	<= d_fly0_sum;
				fly0_diff 	<= d_fly0_diff;
				fly1_sum	<= d_fly1_sum;
				fly1_diff 	<= d_fly1_diff;
				fly2_sum	<= d_fly2_sum;
				fly2_diff 	<= d_fly2_diff;
				fly3_sum	<= d_fly3_sum;
				fly3_diff 	<= d_fly3_diff;
				fly4_sum	<= d_fly4_sum;
				fly4_diff 	<= d_fly4_diff;
				fly5_sum	<= d_fly5_sum;
				fly5_diff 	<= d_fly5_diff;
				fly6_sum	<= d_fly6_sum;
				fly6_diff 	<= d_fly6_diff;
				fly7_sum	<= d_fly7_sum;
				fly7_diff 	<= d_fly7_diff;

				done 		<= 0;
			end
			else if (state == DONE) begin

				out0 		<= fly0_sum;
				out1 		<= fly1_sum;
				out2 		<= fly2_sum;
				out3 		<= fly3_sum;
				out4 		<= fly4_sum;
				out5 		<= fly5_sum;
				out6 		<= fly6_sum;
				out7 		<= fly7_sum;
				out8 		<= fly0_diff;
				out9 		<= fly1_diff;
				out10 		<= fly2_diff;
				out11 		<= fly3_diff;
				out12 		<= fly4_diff;
				out13 		<= fly5_diff;
				out14 		<= fly6_diff;
				out15 		<= fly7_diff;
				// out0 		<= 36'b011111111111111111_000000000000000000;
				// out1 		<= 36'b011111111111111111_000000000000000000;
				// out2 		<= 36'b011101100100000111_000000000000000000;
				// out3 		<= 36'b010110101000001010_000000000000000000;
				// out4 		<= 36'b001100001111101111_000000000000000000;
				// out5 		<= 36'b000000000000000000_000000000000000000;
				// out6 		<= 36'b110011110000010001_000000000000000000;
				// out7 		<= 36'b101001010111110110_000000000000000000;
				// out8 		<= 36'b100010011011111001_000000000000000000;
				// out9 		<= 36'b011111111111111111_000000000000000000;
				// out10 		<= 36'b011111111111111111_000000000000000000;
				// out11 		<= 36'b011111111111111111_000000000000000000;
				// out12 		<= 36'b011111111111111111_000000000000000000;
				// out13 		<= 36'b011111111111111111_000000000000000000;
				// out14 		<= 36'b011111111111111111_000000000000000000;
				// out15 		<= 36'b011111111111111111_000000000000000000;
				done 		<= 1;
			end
			state <= next_state;
		end
	end
	
	// Next state logic
	always_comb begin
		case(state)
			RESET: begin
				fly0_a = 0;
				fly0_b = 0;
				fly0_w = 0;
				fly1_a = 0;
				fly1_b = 0;
				fly1_w = 0;
				fly2_a = 0;
				fly2_b = 0;
				fly2_w = 0;
				fly3_a = 0;
				fly3_b = 0;
				fly3_w = 0;
				fly4_a = 0;
				fly4_b = 0;
				fly4_w = 0;
				fly5_a = 0;
				fly5_b = 0;
				fly5_w = 0;
				fly6_a = 0;
				fly6_b = 0;
				fly6_w = 0;
				fly7_a = 0;
				fly7_b = 0;
				fly7_w = 0;
				
				if (start) begin
					next_state = STAGE_1;
				end
				else begin
					next_state = RESET;
				end
			end
			
			STAGE_1: begin
				fly0_a = in0;
				fly0_b = in8;
				fly0_w = W_0_16;
				fly1_a = in4;
				fly1_b = in12;
				fly1_w = W_0_16;
				fly2_a = in2;
				fly2_b = in10;
				fly2_w = W_0_16;
				fly3_a = in6;
				fly3_b = in14;
				fly3_w = W_0_16;
				fly4_a = in1;
				fly4_b = in9;
				fly4_w = W_0_16;
				fly5_a = in5;
				fly5_b = in13;
				fly5_w = W_0_16;
				fly6_a = in3;
				fly6_b = in11;
				fly6_w = W_0_16;
				fly7_a = in7;
				fly7_b = in15;
				fly7_w = W_0_16;
				
				next_state = STAGE_2;
			end
			
			STAGE_2: begin
				fly0_a = fly0_sum;
				fly0_b = fly1_sum;
				fly0_w = W_0_16;
				fly1_a = fly0_diff;
				fly1_b = fly1_diff;
				fly1_w = W_4_16;
				fly2_a = fly2_sum;
				fly2_b = fly3_sum;
				fly2_w = W_0_16;
				fly3_a = fly2_diff;
				fly3_b = fly3_diff;
				fly3_w = W_4_16;
				fly4_a = fly4_sum;
				fly4_b = fly5_sum;
				fly4_w = W_0_16;
				fly5_a = fly4_diff;
				fly5_b = fly5_diff;
				fly5_w = W_4_16;
				fly6_a = fly6_sum;
				fly6_b = fly7_sum;
				fly6_w = W_0_16;
				fly7_a = fly6_diff;
				fly7_b = fly7_diff;
				fly7_w = W_4_16;
				
				next_state = STAGE_3;
			end

			
			STAGE_3: begin
				fly0_a = fly0_sum;
				fly0_b = fly2_sum;
				fly0_w = W_0_16;
				fly1_a = fly1_sum;
				fly1_b = fly3_sum;
				fly1_w = W_2_16;
				fly2_a = fly0_diff;
				fly2_b = fly2_diff;
				fly2_w = W_4_16;
				fly3_a = fly1_diff;
				fly3_b = fly3_diff;
				fly3_w = W_6_16;
				fly4_a = fly4_sum;
				fly4_b = fly6_sum;
				fly4_w = W_0_16;
				fly5_a = fly5_sum;
				fly5_b = fly7_sum;
				fly5_w = W_2_16;
				fly6_a = fly4_diff;
				fly6_b = fly6_diff;
				fly6_w = W_4_16;
				fly7_a = fly5_diff;
				fly7_b = fly7_diff;
				fly7_w = W_6_16;
				
				next_state = STAGE_4;
			end

			
			STAGE_4: begin
				fly0_a = fly0_sum;
				fly0_b = fly4_sum;
				fly0_w = W_0_16;
				fly1_a = fly1_sum;
				fly1_b = fly5_sum;
				fly1_w = W_1_16;
				fly2_a = fly2_sum;
				fly2_b = fly6_sum;
				fly2_w = W_2_16;
				fly3_a = fly3_sum;
				fly3_b = fly7_sum;
				fly3_w = W_3_16;
				fly4_a = fly0_diff;
				fly4_b = fly4_diff;
				fly4_w = W_4_16;
				fly5_a = fly1_diff;
				fly5_b = fly5_diff;
				fly5_w = W_5_16;
				fly6_a = fly2_diff;
				fly6_b = fly6_diff;
				fly6_w = W_6_16;
				fly7_a = fly3_diff;
				fly7_b = fly7_diff;
				fly7_w = W_7_16;
				
				next_state = DONE;
			end
			
			DONE: begin
				fly0_a = 0;
				fly0_b = 0;
				fly0_w = 0;
				fly1_a = 0;
				fly1_b = 0;
				fly1_w = 0;
				fly2_a = 0;
				fly2_b = 0;
				fly2_w = 0;
				fly3_a = 0;
				fly3_b = 0;
				fly3_w = 0;
				fly4_a = 0;
				fly4_b = 0;
				fly4_w = 0;
				fly5_a = 0;
				fly5_b = 0;
				fly5_w = 0;
				fly6_a = 0;
				fly6_b = 0;
				fly6_w = 0;
				fly7_a = 0;
				fly7_b = 0;
				fly7_w = 0;
				
				if (start) begin
					next_state = STAGE_1;
				end
				else begin
					next_state = DONE;
				end
			end
		endcase
	end
		
endmodule