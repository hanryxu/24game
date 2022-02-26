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
module Num24(clk, JA, btnr, btnl, red, green, blue, hsync, vsync);
	// User controls
	input clk, JA, btnr, btrnl;
	// VGA stuff
	output wire [2:0] red;
	output wire [2:0] green;
	output wire [1:0] blue;
	output wire hsync, vsync;
endmodule
