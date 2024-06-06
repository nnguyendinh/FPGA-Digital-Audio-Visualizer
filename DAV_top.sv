module DAV_top(
		input rst, 
		input clk, 
        input clk_adc,
		output reg hsync, 
		output reg vsync, 
		output reg [3:0] red, 
		output reg [3:0] green, 
		output reg [3:0] blue,
		output [9:0] leds
	);

    wire [17:0] samples [15:0];

    // Pad samples with 0s at the end
    wire [35:0] samples_padded [15:0];
    assign samples_padded[0] = {samples[0], 18'd0};
    assign samples_padded[1] = {samples[1], 18'd0};
    assign samples_padded[2] = {samples[2], 18'd0};
    assign samples_padded[3] = {samples[3], 18'd0};
    assign samples_padded[4] = {samples[4], 18'd0};
    assign samples_padded[5] = {samples[5], 18'd0};
    assign samples_padded[6] = {samples[6], 18'd0};
    assign samples_padded[7] = {samples[7], 18'd0};
    assign samples_padded[8] = {samples[8], 18'd0};
    assign samples_padded[9] = {samples[9], 18'd0};
    assign samples_padded[10] = {samples[10], 18'd0};
    assign samples_padded[11] = {samples[11], 18'd0};
    assign samples_padded[12] = {samples[12], 18'd0};
    assign samples_padded[13] = {samples[13], 18'd0};
    assign samples_padded[14] = {samples[14], 18'd0};
    assign samples_padded[15] = {samples[15], 18'd0};

    wire [35:0] freqs [15:0];

    reg [17:0] bars [15:0];

    localparam IDLE = 0;
	localparam START = 1;
	localparam FFT = 2;
    localparam DONE = 3;

	reg [2:0] state = IDLE;
	reg [2:0] state_d = IDLE;
	
	wire clk_25;
	reg fft_start = 0;
    wire fft_done;
	wire clk_sampling;
	
	assign leds[9:1] = bars[0] [9:1];

	pll clk_generator(clk, clk_25);

	mic_sampler sampler(.clk_25(clk_25), .clk_adc(clk_adc), .samples(samples), .clk_sampling(clk_sampling));

    fft_16point fft_generator(.clk(clk_25), .reset(rst), .start(fft_start), .inputs(samples_padded), .outputs(freqs), .done(fft_done));

	vga display(.vgaclk(clk_25), .rst(rst), .hsync(hsync), .vsync(vsync), .red(red), .green(green), .blue(blue), .bars(bars));

	always @(posedge clk_25) begin
        state <= state_d;

        if (rst) begin
            state <= IDLE;
        end

        else if (state == START) begin
            fft_start <= 0;
        end

        else if (state == FFT) begin
            fft_start <= 1;
        end
   
        else if (state == DONE) begin
            fft_start <= 0;

            for (integer i = 0; i < 16; i = i + 1) begin
                bars[i] <= freqs[i] [35:18];
            end

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
                state_d = FFT;
            end
            
            FFT: begin
                if (fft_done) begin
                    state_d = DONE;
                end
                else begin
                    state_d = FFT;
                end 
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
