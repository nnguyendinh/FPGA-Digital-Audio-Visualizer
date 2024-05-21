module mic_sampler(clk_25, clk_adc, s0, s1, s2, s3, s4, s5, s6, 
							s7, s8, s9, s10, s11, s12, s13, s14, s15, clk_sampling);

	// Inputs		
	input clk_25; // 25Mhz input clock
	input clk_adc;	// 10Mhz ADC clock

	// Outputs
	output reg [17:0] s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15 = 0;
	
	// Internal signals
	output clk_sampling;
	reg collected = 0;
	reg [3:0] index = 3;
	wire [11:0] sample;
	reg [17:0] samples [0:15];

	// States
	localparam IDLE = 1'b0;
	localparam SAMPLING = 1'b1;
	reg state_d = IDLE;
	reg state = IDLE;

	assign done = 1'b1;
	
	clockDivider thanks_prem(clk_25, 19'd5000, 1'b0, clk_sampling);

	// ADC
	ADC_10MHz mic(.CLOCK(clk_adc), .CH0(sample), .RESET(0));
	
	always @(posedge clk_sampling) begin
		s0 <= (sample << 6);
		s1 <= s0;
		s2 <= s1;
		s3 <= s2;
		s4 <= s3;
		s5 <= s4;
		s6 <= s5;
		s7 <= s6;
		s8 <= s7;
		s9 <= s8;
		s10 <= s9;
		s11 <= s10;
		s12 <= s11;
		s13 <= s12;
		s14 <= s13;
		s15 <= s14;
	end 

endmodule
