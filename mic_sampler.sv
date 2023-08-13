module mic_sampler(clk_25, clk_adc, start, done, s0, s1, s2, s3, s4, s5, s6, 
							s7, s8, s9, s10, s11, s12, s13, s14, s15);

	// Inputs		
	input clk_25; // 25Mhz input clock
	input clk_adc;	// 10Mhz ADC clock
	input start;

	// Outputs
	output reg done = 0;
	output reg [17:0] s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15 = 0;
	
	// Internal signals
	reg collected = 0;
	reg [3:0] index = 3;
	wire [11:0] sample;
	reg [17:0] samples [0:15];

	// States
	localparam IDLE = 1'b0;
	localparam SAMPLING = 1'b1;
	reg state_d = IDLE;
	reg state = IDLE;

	// ADC
	ADC_25Mhz mic(.CLOCK(clk_25), .CH0(sample), .RESET(0));
	
	// Sample 16 times
	always @(posedge clk_adc) begin
		state <= state_d;
		
		// Set collected to 0 when idle
		if (state == IDLE) begin
			collected <= 0;
			index <= 0;
		end

		// Sample 16 times
		else begin
			if (index < 15) begin
				samples[index] <= sample;
				index <= index + 4'b0001;
				collected <= 0; 
			end
			else begin
				collected <= 1;
				index <= 0;
				s0 <= samples[0] << 6;
				s1 <= samples[1] << 6;
				s2 <= samples[2] << 6;
				s3 <= samples[3] << 6;
				s4 <= samples[4] << 6;
				s5 <= samples[5] << 6;
				s6 <= samples[6] << 6;
				s7 <= samples[7] << 6;
				s8 <= samples[8] << 6;
				s9 <= samples[9] << 6;
				s10 <= samples[10] << 6;
				s11 <= samples[11] << 6;
				s12 <= samples[12] << 6;
				s13 <= samples[13] << 6;
				s14 <= samples[14] << 6;
				s15 <= sample << 6;
			end
		end
	end
	
	always @(posedge clk_25) begin
		if (collected) begin
			done <= 1;
		end
		else begin
			done <= 0;
		end
	end

 	// State machine
 	always_comb begin
 		if (state == IDLE) begin
 			if (start) begin
 				state_d = SAMPLING;
 			end
 			else begin
 				state_d = IDLE;
 			end
 		end
 		else begin
 			if (done) begin
 				state_d = IDLE;
 			end
 			else begin
 				state_d = SAMPLING;
 			end
 		end
 	end
	
endmodule
