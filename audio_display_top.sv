module audio_display_top(
		input rst, 
		input clk, 
      input clk_adc,
		input start,
		output reg hsync, 
		output reg vsync, 
		output reg [3:0] red, 
		output reg [3:0] green, 
		output reg [3:0] blue,
		output [9:0] leds
	);

    wire [17:0] samples [15:0];

    reg [17:0] bars [15:0];

	localparam IDLE = 0;
	localparam START = 1;
	localparam FFT = 2;
	localparam DONE = 3;

	reg [2:0] state = IDLE;
	reg [2:0] state_d = IDLE;
	
	wire clk_25;
	wire clk_sampling;
	wire sampling_done;

	pll clk_generator(clk, clk_25);
	
	assign leds[9:1] = bars[0][9:1];
	assign leds[0] = clk_sampling;

	mic_sampler sampler(.clk_25(clk_25), .clk_adc(clk_adc), .samples(samples), .clk_sampling(clk_sampling));

	vga display(.vgaclk(clk_25), .rst(rst), .hsync(hsync), .vsync(vsync), .red(red), .green(green), .blue(blue), .bars(bars));

	always @(posedge clk_25) begin
        state <= state_d;

        if (rst) begin
            state <= IDLE;
        end
		  
        else if (state == DONE) begin
            bars[0] <= samples[0];
            bars[1] <= samples[1];
            bars[2] <= samples[2];
            bars[3] <= samples[3];
            bars[4] <= samples[4];
            bars[5] <= samples[5];
            bars[6] <= samples[6];
            bars[7] <= samples[7];
            bars[8] <= samples[8];
            bars[9] <= samples[9];
            bars[10] <= samples[10];
            bars[11] <= samples[11];
            bars[12] <= samples[12];
            bars[13] <= samples[13];
            bars[14] <= samples[14];
            bars[15] <= samples[15];
        end
    end

    always_comb begin

        case(state)
            IDLE: begin
                if (vsync) begin
                    state_d = START;
                end
                else begin
                    state_d = IDLE;
                end
            end
            START: begin
                state_d = DONE;
            end
            // FFT state not included in this test
            FFT: begin
                state_d = IDLE;
            end
            DONE: begin
                if (vsync == 0) begin
                    state_d = IDLE;
                end
                else begin
                    state_d = DONE;
                end
            end
        endcase
    end

endmodule
