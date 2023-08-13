module mic_samples_test(clk, clk_adc, rst, leds);
	input clk, rst, clk_adc;
	output [9:0] leds;
	wire clk_25;
	
	wire [11:0] sample;
	
	pll clock_gen(.inclk0(clk), .c0(clk_25));
	
	ADC_25Mhz mic(.CLOCK(clk_25), .CH0(sample), .RESET(rst));
	
	always @(posedge clk_adc) begin
		leds <= sample[11:2];
	end
		
endmodule