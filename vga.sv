module vga(
		input vgaclk,           //input pixel clock: how fast should this be?
		input rst,              //synchronous reset
		input [17:0] bars [15:0], //input bars: 16 bins of intensity
		output hsync,			//horizontal sync out
		output vsync,			//vertical sync out
		output reg [3:0] red,	//red vga output
		output reg [3:0] green, //green vga output
		output reg [3:0] blue	//blue vga output
   );
	
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
