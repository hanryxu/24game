`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:20:08 02/26/2022 
// Design Name: 
// Module Name:    Num24 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: top module
//
//////////////////////////////////////////////////////////////////////////////////
module Num24(clk, JA, START, RESTART, red, green, blue, hsync, vsync);
	// User controls
	input clk, JA, START, RESTART;
	// VGA stuff
	output wire [2:0] red;
	output wire [2:0] green;
	output wire [1:0] blue;
	output wire hsync, vsync;
	
	// clock generation
	// TODO: delete 1 hz, 2 hz clock, and clk_blink, add clk_pix
	wire clk_1Hz;
   wire clk_2Hz;
   wire clk_blink;
   wire clk_debounce;
	
   clock_gen clock_gen_INS(
                  .clk_in(clk),
                  .clk_1hz(clk_1Hz),
                  .clk_2hz(clk_2Hz),
                  .clk_blink(clk_blink),
                  .clk_display(clk_debounce)
              );
	
	// Number pad logic
	wire [3:0] decode; // binary rep of hexadecimal digits --> F = 4'b1111
	PmodKYPD num_pad(.clk(clk), .JA(JA), .Decode(decode));
	
	// Button debouncing
	wire START_d;
	debouncer debounce_START(.clk_in(clk_debounce), .but(START),
											.but_out(START_d));
	wire RESTART_d;
	debouncer debounce_RESTART(.clk_in(clk_debounce), .but(RESTART),
											.but_out(RESTART_d));
											
	// FSM
	
	// VGA Stuff
	
endmodule
