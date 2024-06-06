module vga_test(
		input rst, 
		input clk, 
		output reg hsync, 
		output reg vsync, 
		output reg [3:0] red, 
		output reg [3:0] green, 
		output reg [3:0] blue
	);

    reg [17:0] bars [15:0];

    bar[0] = 18'h0000F;
    bar[1] = 18'h000F0;
    bar[2] = 18'h00F00;
    bar[3] = 18'h0F000;
    bar[4] = 18'h30000;
    bar[5] = 18'h03000;
    bar[6] = 18'h00300;
    bar[7] = 18'h3FFFF;
    bar[8] = 18'h00300;
    bar[9] = 18'h03000;
    bar[10] = 18'h30000;
    bar[11] = 18'h0F000;
    bar[12] = 18'h00F00;
    bar[13] = 18'h3FFFF;
    bar[14] = 18'h0000F;
    bar[15] = 18'h0000F;
	
	reg vgaClock;

	pll vga_generator(clk, vgaClock);

	vga display(.vgaclk(vgaClock), .rst(rst), .hsync(hsync), .vsync(vsync), .red(red), .green(green), .blue(blue), .bars(bars));
	
endmodule