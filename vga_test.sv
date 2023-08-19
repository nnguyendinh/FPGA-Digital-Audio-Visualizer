module vga_test(
		input rst, 
		input clk, 
		output reg hsync, 
		output reg vsync, 
		output reg [3:0] red, 
		output reg [3:0] green, 
		output reg [3:0] blue
	);

    reg [17:0] bar0 = 18'h0000F;
    reg [17:0] bar1 = 18'h000F0;
    reg [17:0] bar2 = 18'h00F00;
    reg [17:0] bar3 = 18'h0F000;
    reg [17:0] bar4 = 18'h30000;
    reg [17:0] bar5 = 18'h03000;
    reg [17:0] bar6 = 18'h00300;
    reg [17:0] bar7 = 18'h3FFFF;
    reg [17:0] bar8 = 18'h00300;
    reg [17:0] bar9 = 18'h03000;
    reg [17:0] bar10 = 18'h30000;
    reg [17:0] bar11 = 18'h0F000;
    reg [17:0] bar12 = 18'h00F00;
    reg [17:0] bar13 = 18'h3FFFF;
    reg [17:0] bar14 = 18'h0000F;
    reg [17:0] bar15 = 18'h0000F;
	
	reg vgaClock;

	pll vga_generator(clk, vgaClock);

	vga display(.vgaclk(vgaClock), .rst(reset), .hsync(hsync), .vsync(vsync), .red(red), .green(green), .blue(blue), .bar0(bar0), 
            .bar1(bar1), .bar2(bar2), .bar3(bar3), .bar4(bar4), .bar5(bar5), .bar6(bar6), .bar7(bar7), .bar8(bar8), .bar9(bar9), 
            .bar10(bar10), .bar11(bar11), .bar12(bar12), .bar13(bar13), .bar14(bar14), .bar15(bar15));
	
endmodule