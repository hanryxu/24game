`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    02:39:29 02/02/2022
// Design Name:
// Module Name:    clock_gen
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module clock_gen(
        clk_in,
        clk_1hz,
        clk_2hz,
        clk_blink,
        clk_display,
    );
    input clk_in;
    output reg clk_1hz=0;
    output reg clk_2hz=0;
    output reg clk_blink=0;
    output reg clk_display=0; // also used for the debouncer

	// reset values for counters
	 localparam hz_1 = 32'd49_999_999;
	 localparam hz_2 = 32'd24_999_999;
	 localparam blink = 32'd16_666_666; // ~3 hz
	 localparam display = 32'd99_999;
	 
	// Initialize and declare ccounters
	reg [31:0] counter_1hz = 0;
	reg [31:0] counter_2hz = 0;
	reg [31:0] counter_blink = 0;
	reg [31:0] counter_display = 0;
	
	always @(posedge clk_in) begin
		if (counter_1hz == hz_1) begin
			counter_1hz <= 0;
			clk_1hz <= ~clk_1hz;
		end
		else
			counter_1hz <= counter_1hz + 1'b1;
		
		if (counter_2hz == hz_2) begin
			counter_2hz <= 0;
			clk_2hz <= ~clk_2hz;
		end
		else
			counter_2hz <= counter_2hz + 1'b1;
			
		if (counter_blink == blink) begin
			counter_blink <= 0;
			clk_blink <= ~clk_blink;
		end
		else
			counter_blink <= counter_blink + 1'b1;
		
		if (counter_display == display) begin
			counter_display <= 0;
			clk_display <= ~clk_display;
		end
		else
			counter_display <= counter_display + 1'b1;
	end

endmodule
