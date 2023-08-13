module mic_sampler_test(clk, clk_adc, rst, leds);
	input clk, clk_adc, rst;
	output reg [9:0] leds;

   wire clk_25;
   reg start;
	wire done;
	wire [17:0] s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15;

   pll clock_gen(.inclk0(clk), .c0(clk_25));

	mic_sampler sampler(.clk_25(clk_25), .clk_adc(clk_adc), .start(1'b1), .done(done), .s0(s0), 
								.s1(s1), .s2(s2), .s3(s3), .s4(s4), .s5(s5), .s6(s6), .s7(s7), .s8(s8), 
								.s9(s9), .s10(s10), .s11(s11), .s12(s12), .s13(s13), .s14(s14), .s15(s15));

	localparam START = 0;
	localparam WAITING = 1;
	localparam DONE = 2;
	localparam IDLE = 3;
	reg [1:0] state = START;
	reg [1:0] state_d = START;

	always @(posedge clk_25) begin
        state <= state_d;

        if (rst) begin
            start <= 0;
            state <= IDLE;
        end
        else if (state == START) begin
            start <= 1;
        end

        else if (state == WAITING) begin
            start <= 0;
        end

        else if (state == DONE) begin
            start <= 0;
				leds 	<= {s15[17], s14[17], s13[17], s12[17], s11[17], s10[17], s9[17], s8[17], s7[17], s6[17]};
        end
    end

    always_comb begin
        if (state == START) begin
            state_d = WAITING;
        end
        else if (state == WAITING) begin
            if (done) begin
                state_d = DONE;
            end
            else begin
                state_d = WAITING;
            end
        end
        else if (state == DONE) begin
            state_d = IDLE;
        end
        else begin
            if (1) begin
                state_d = START;
            end
            else begin
                state_d = IDLE;
            end
        end
    end

endmodule
