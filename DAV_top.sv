module DAV_top(
		input rst, 
		input clk, 
        input clk_adc,
		output reg hsync, 
		output reg vsync, 
		output reg [3:0] red, 
		output reg [3:0] green, 
		output reg [3:0] blue
	);

    wire [17:0] s0;
    wire [17:0] s1;
    wire [17:0] s2;
    wire [17:0] s3;
    wire [17:0] s4;
    wire [17:0] s5;
    wire [17:0] s6;
    wire [17:0] s7;
    wire [17:0] s8;
    wire [17:0] s9;
    wire [17:0] s10;
    wire [17:0] s11;
    wire [17:0] s12;
    wire [17:0] s13;
    wire [17:0] s14;
    wire [17:0] s15;

    wire [35:0] f0;
    wire [35:0] f1;
    wire [35:0] f2;
    wire [35:0] f3;
    wire [35:0] f4;
    wire [35:0] f5;
    wire [35:0] f6;
    wire [35:0] f7;
    wire [35:0] f8;
    wire [35:0] f9;
    wire [35:0] f10;
    wire [35:0] f11;
    wire [35:0] f12;
    wire [35:0] f13;
    wire [35:0] f14;
    wire [35:0] f15;

    reg [17:0] b0 = 0;
    reg [17:0] b1 = 0;
    reg [17:0] b2 = 0;
    reg [17:0] b3 = 0;
    reg [17:0] b4 = 0;
    reg [17:0] b5 = 0;
    reg [17:0] b6 = 0;
    reg [17:0] b7 = 0;
    reg [17:0] b8 = 0;
    reg [17:0] b9 = 0;
    reg [17:0] b10 = 0;
    reg [17:0] b11 = 0;
    reg [17:0] b12 = 0;
    reg [17:0] b13 = 0;
    reg [17:0] b14 = 0;
    reg [17:0] b15 = 0;

    localparam IDLE = 0;
	localparam START = 1;
	localparam SAMPLING = 2;
	localparam FFT = 3;
    localparam DONE = 4;

	reg [2:0] state = IDLE;
	reg [2:0] state_d = IDLE;
	
	wire clk_25;
    reg sampling_start = 0;
	wire sampling_done;
    wire fft_done;

	pll clk_generator(clk, clk_25);

    mic_sampler sampler(.clk_25(clk_25), .clk_adc(clk_adc), .start(sampling_start), .done(sampling_done), .s0(s0), 
                        .s1(s1), .s2(s2), .s3(s3), .s4(s4), .s5(s5), .s6(s6), .s7(s7), .s8(s8), 
                        .s9(s9), .s10(s10), .s11(s11), .s12(s12), .s13(s13), .s14(s14), .s15(s15));

    fft_16point fft_generator(.clk(clk_25), .reset(rst), .start(sampling_done), 
                                .in0({s0, 18'd0}), .in1({s1, 18'd0}), .in2({s2, 18'd0}), .in3({s3, 18'd0}), .in4({s4, 18'd0}), .in5({s5, 18'd0}), .in6({s6, 18'd0}), .in7({s7, 18'd0}), 
                                .in8({s8, 18'd0}), .in9({s9, 18'd0}), .in10({s10, 18'd0}), .in11({s11, 18'd0}), .in12({s12, 18'd0}), .in13({s13, 18'd0}), .in14({s14, 18'd0}), .in15({s15, 18'd0}), 
					            .out0(f0), .out1(f1), .out2(f2), .out3(f3), .out4(f4), .out5(f5), .out6(f6), .out7(f7), 
					            .out8(f8), .out9(f9), .out10(f10), .out11(f11), .out12(f12), .out13(f13), .out14(f14), .out15(f15),
					            .done(fft_done));

	vga display(.vgaclk(clk_25), .rst(rst), .hsync(hsync), .vsync(vsync), .red(red), .green(green), .blue(blue), 
            .bar0(b0), .bar1(b1), .bar2(b2), .bar3(b3), .bar4(b4), .bar5(b5), .bar6(b6), .bar7(b7), 
            .bar8(b8), .bar9(b9), .bar10(b10), .bar11(b11), .bar12(b12), .bar13(b13), .bar14(b14), .bar15(b15));

	always @(posedge clk_25) begin
        state <= state_d;

        if (rst) begin
            sampling_start <= 0;
            state <= IDLE;
        end
        else if (state == IDLE) begin
            sampling_start <= 0;
        end
        else if (state == START) begin
            sampling_start <= 1;
        end
        else if (state == SAMPLING) begin
            sampling_start <= 0;
        end
        else if (state == FFT) begin
            sampling_start <= 0;
        end
        else if (state == DONE) begin
            sampling_start <= 0;
            b0 <= f0[35:18];
            b1 <= f1[35:18];
            b2 <= f2[35:18];
            b3 <= f3[35:18];
            b4 <= f4[35:18];
            b5 <= f5[35:18];
            b6 <= f6[35:18];
            b7 <= f7[35:18];
            b8 <= f8[35:18];
            b9 <= f9[35:18];
            b10 <= f10[35:18];
            b11 <= f11[35:18];
            b12 <= f12[35:18];
            b13 <= f13[35:18];
            b14 <= f14[35:18];
            b15 <= f15[35:18];
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
                state_d = SAMPLING;
            end
            SAMPLING: begin
                if (sampling_done) begin
                    state_d = FFT;
                end
                else    
                    state_d = SAMPLING;
            end
            // FFT state not included in this test
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
