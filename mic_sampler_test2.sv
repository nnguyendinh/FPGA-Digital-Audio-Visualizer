module mic_sampler_test2(clk, clk_adc, leds);
	input clk, clk_adc;
	output reg [9:0] leds;

   wire clk_25;
	wire done;
	wire [17:0] s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15;

	pll clock_gen(.inclk0(clk), .c0(clk_25));
	 
	mic_sampler sampler(.clk_25(clk_25), .clk_adc(clk_adc), .start(1'b1), .done(done), .s0(s0), .s1(s1), .s2(s2), .s3(s3), .s4(s4), .s5(s5), .s6(s6), 
							.s7(s7), .s8(s8), .s9(s9), .s10(s10), .s11(s11), .s12(s12), .s13(s13), .s14(s14), .s15(s15));

	always @(posedge done) begin
		leds <= {s9[17], s8[17], s7[17], s6[17], s5[17],s4[17], s3[17], s2[17], s1[17], s0[17]};
   end

endmodule
