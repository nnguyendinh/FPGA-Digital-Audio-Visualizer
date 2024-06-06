module mic_sampler(clk_25, clk_adc, samples, clk_sampling);

	// Inputs		
	input clk_25; // 25Mhz input clock
	input clk_adc;	// 10Mhz ADC clock

	// Outputs
	output reg [17:0] samples [0:15];
	
	// Internal signals
	output clk_sampling;
	wire [11:0] sample;
	
	clockDivider thanks_prem(clk_25, 19'd5000, 1'b0, clk_sampling);

	// ADC
	ADC_10MHz mic(.CLOCK(clk_adc), .CH0(sample), .RESET(0));
	
	always @(posedge clk_sampling) begin
		samples[0] <= (sample << 6);
		samples[1] <= samples[0];
		samples[2] <= samples[1];
		samples[3] <= samples[2];
		samples[4] <= samples[3];
		samples[5] <= samples[4];
		samples[6] <= samples[5];
		samples[7] <= samples[6];
		samples[8] <= samples[7];
		samples[9] <= samples[8];
		samples[10] <= samples[9];
		samples[11] <= samples[10];
		samples[12] <= samples[11];
		samples[13] <= samples[12];
		samples[14] <= samples[13];
		samples[15] <= samples[14];
	end 

endmodule
