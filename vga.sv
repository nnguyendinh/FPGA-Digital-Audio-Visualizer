module vga(
		input vgaclk,           //input pixel clock: how fast should this be?
		input rst,              //synchronous reset
		  input [17:0] bar0,             //input bar0: bin 0 intensity
		  input [17:0] bar1,             //input bar1: bin 1 intensity
		  input [17:0] bar2,             //input bar2: bin 2 intensity
		  input [17:0] bar3,             //input bar3: bin 3 intensity
		  input [17:0] bar4,             //input bar4: bin 4 intensity
		  input [17:0] bar5,             //input bar5: bin 5 intensity
		  input [17:0] bar6,             //input bar6: bin 6 intensity
		  input [17:0] bar7,             //input bar7: bin 7 intensity
		  input [17:0] bar8,             //input bar8: bin 8 intensity
		  input [17:0] bar9,             //input bar9: bin 9 intensity
		  input [17:0] bar10,            //input bar10: bin 10 intensity
		  input [17:0] bar11,            //input bar11: bin 11 intensity
		  input [17:0] bar12,            //input bar12: bin 12 intensity
		  input [17:0] bar13,            //input bar13: bin 13 intensity
		  input [17:0] bar14,            //input bar14: bin 14 intensity
		  input [17:0] bar15,            //input bar15: bin 15 intensity
			output hsync,			//horizontal sync out
		output vsync,			//vertical sync out
		output reg [3:0] red,	//red vga output
		output reg [3:0] green, //green vga output
		output reg [3:0] blue	//blue vga output
   );

    wire [17:0] bars [15:0];

    assign bars[0] = bar0;
    assign bars[1] = bar1;
    assign bars[2] = bar2;
    assign bars[3] = bar3;
    assign bars[4] = bar4;
    assign bars[5] = bar5;
    assign bars[6] = bar6;
    assign bars[7] = bar7;
    assign bars[8] = bar8;
    assign bars[9] = bar9;
    assign bars[10] = bar10;
    assign bars[11] = bar11;
    assign bars[12] = bar12;
    assign bars[13] = bar13;
    assign bars[14] = bar14;
    assign bars[15] = bar15;
	
	//	DONE: Video protocol constants
    // You can find these described in the VGA specification for 640x480
	localparam HPIXELS = 640;  // horizontal pixels per line
	localparam HPULSE = 96; 	// hsync pulse length
	localparam HBP = 48; 	    // end of horizontal back porch
	localparam HFP = 16; 	    // beginning of horizontal front porch
	
	localparam VLINES = 480;   // scanlines per frame (aka the # of vertical pixels)
	localparam VPULSE = 2; 	// vsync pulse length
	localparam VBP = 33; 		// end of vertical back porch
	localparam VFP = 10; 	    // beginning of vertical front porch
	
	// registers for storing the horizontal & vertical counters
	reg [9:0] hc;
	reg [9:0] vc;


    //Counter block: change hc and vc correspondingly to the current state.
	always @(posedge vgaclk) begin
		 //reset condition
		if (rst == 1) begin
			hc <= 0;
			vc <= 0;
		end
		else begin
			//DONE: Implement logic to move counters properly!
			if (hc >= HPIXELS + HPULSE + HBP + HFP - 1) begin
				hc <= 0;
				if (vc >= VLINES + VPULSE + VBP + VFP - 1) begin
					vc <= 0;
				end
				else begin
					vc <= vc + 1'b1;
				end
			end
			else begin
				hc <= hc + 1'b1;
			end
			
		end
	end

	assign hsync = (hc >= HPIXELS + HFP && hc < HPIXELS + HFP + HPULSE) ? 0 : 1;	//DONE
	assign vsync = (vc >= VLINES + VFP && vc < VLINES + VFP + VPULSE) ? 0 : 1;	//DONE
	
    //RGB output block: set red, green, blue outputs here.
	always_comb begin
		// check if we're within vertical active video range
		if (hc <= HPIXELS && vc <= VLINES)
		begin
            if (VLINES - vc < (bars[hc/40]) / 512) begin
                red <= hc / 40;
                green <= ((hc / 40) + (vc / 30))/2;
                blue <= vc / 30;
            end
            else begin
                red <= 4'b0000;
                green <= 4'b0000;
                blue <= 4'b0000;
            end

		end
		else begin
			red <= 4'b0000;
			green <= 4'b0000;
			blue <= 4'b0000;
		end
	end

endmodule
