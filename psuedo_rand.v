`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
// 
// Create Date:    07:14:00 02/27/2022 
// Design Name: 
// Module Name:    psuedo_rand 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Generates a psuedo random 4 bit number.
//						If it doesn't work, it'll get scrapped and I'll cycle through sets in order
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: See link below for credits
// https://vlsicoding.blogspot.com/2014/07/verilog-code-for-4-bit-linear-feedback-shift-register.html
//////////////////////////////////////////////////////////////////////////////////
module psuedo_rand(clk, rst, out);
	output reg [3:0] out;
	input clk, rst;

	wire feedback;

	assign feedback = ~(out[3] ^ out[2]);
	
	always @(posedge clk, posedge rst)
	begin
		if (rst)
			out = 4'b0;
		else
			out = {out[2:0],feedback};
	end

endmodule
