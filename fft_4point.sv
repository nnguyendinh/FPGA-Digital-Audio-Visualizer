module fft_4point_32bit(clk, reset, start, in0, in1, in2, in3, out0, out1, out2, out3, done, fly1_sum, fly1_diff, fly2_sum, fly2_diff);
	
	// INPUTS
	input clk;
	input reset;
	input start;
	input [31:0] in0;
	input [31:0] in1;
	input [31:0] in2;
	input [31:0] in3;
	
	// OUTPUTS
	output reg [31:0] out0;
	output reg [31:0] out1;
	output reg [31:0] out2;
	output reg [31:0] out3;
	output reg done;
	
	// STATES
	localparam RESET 		= 0;
	localparam STAGE_1 	= 1;
	localparam STAGE_2 	= 2;
	localparam DONE 		= 3;
	
	reg [1:0] state 		= RESET;
	reg [1:0] next_state = RESET;
	
	// TWIDDLE FACTORS
	localparam W_0_2		= 32'h7fff0000;
	localparam W_0_4		= 32'h7fff0000;
	localparam W_1_4		= 32'h00008000;
	
	// INTERMEDIARY
	reg [31:0] fly1_a;
	reg [31:0] fly1_b;
	reg [31:0] fly1_w;
	reg [31:0] d_fly1_sum;
	reg [31:0] d_fly1_diff;
	output reg [31:0] fly1_sum;
	output reg [31:0] fly1_diff;
	
	reg [31:0] fly2_a;
	reg [31:0] fly2_b;
	reg [31:0] fly2_w;
	reg [31:0] d_fly2_sum;
	reg [31:0] d_fly2_diff;
	output reg [31:0] fly2_sum;
	output reg [31:0] fly2_diff;
	
	// Butterfly Units
	butterfly fly1(fly1_a, fly1_b, fly1_w, d_fly1_sum, d_fly1_diff);
   butterfly fly2(fly2_a, fly2_b, fly2_w, d_fly2_sum, d_fly2_diff);
	
	// State register
	always @ (posedge clk, posedge reset) begin
		if (reset) begin
			state 		<= RESET;
			fly1_sum 	<= 0;
			fly1_diff 	<= 0;
			fly2_sum 	<= 0;
			fly2_diff	<= 0;
		end
		else begin
			if (state == STAGE_1 || state == STAGE_2) begin
				fly1_sum		<= d_fly1_sum;
				fly1_diff 	<= d_fly1_diff;
				fly2_sum		<= d_fly2_sum;
				fly2_diff 	<= d_fly2_diff;
			end
			state <= next_state;
		end
	end
	
	// Next state logic
	always_comb begin
		case(state)
			RESET: begin
				fly1_a = 0;
				fly1_b = 0;
				fly1_w = 0;
				fly2_a = 0;
				fly2_b = 0;
				fly2_w = 0;
				
				out0 = 0;
				out1 = 0;
				out2 = 0;
				out3 = 0;
				done = 0;
				
				if (start) begin
					next_state = STAGE_1;
				end
				else begin
					next_state = RESET;
				end
			end
			
			STAGE_1: begin
				fly1_a = in0;
				fly1_b = in2;
				fly1_w = W_0_2;
				fly2_a = in1;
				fly2_b = in3;
				fly2_w = W_0_2;
				
				out0 = 0;
				out1 = 0;
				out2 = 0;
				out3 = 0;
				done = 0;
				
				next_state = STAGE_2;
			end
			
			STAGE_2: begin
				fly1_a = fly1_sum;
				fly1_b = fly2_sum;
				fly1_w = W_0_4;
				fly2_a = fly1_diff;
				fly2_b = fly2_diff;
				fly2_w = W_1_4;
				
				out0 = 0;
				out1 = 0;
				out2 = 0;
				out3 = 0;
				done = 0;
				
				next_state = DONE;
			end
			
			DONE: begin
				fly1_a = 0;
				fly1_b = 0;
				fly1_w = 0;
				fly2_a = 0;
				fly2_b = 0;
				fly2_w = 0;
				
				out0 = fly1_sum;
				out1 = fly2_sum;
				out2 = fly1_diff;
				out3 = fly2_diff;
				done = 1;
				
				if (start) begin
					next_state = DONE;
				end
				else begin
					next_state = RESET;
				end
			end
		endcase
	end
		
endmodule