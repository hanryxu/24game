`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Joyce Tung
// 
// Create Date:    00:20:25 02/26/2022 
// Design Name: 
// Module Name:    FSM 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Given the decoded inputs from the numberpad,
//					 START/RESTART buttons, output the four numbers displayed,
//					 how many are valid, or win/lose. Also responsible for updating
//					 numbers as the user acts.
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module FSM(clk, START, RESTART, decode, num1, num2, num3, num4, how_many, win);
	input clk, START, RESTART, decode;
	output [3:0] num1; output [3:0] num2; output [3:0] num3; output [3:0] num4;
	output wire [1:0] how_many; // if 1 number is left, how_many == 00, and num is num1
	output wire win; // 1 if win, 0 otherwise (lose/not finished)
	
	assign win = (how_many == 0 && num1 == 24);
	
	// initialize num1, num2, num3, num4
	wire rst;
	reg [2:0] state = 3'b111;
	assign rst = (state == 3'b111); // only on if state is R
	reg [3:0] index;
	rand_index psuedo_rand(.clk(clk), .rst(rst), .out(index));
	valid_set valid_sets(.index(index), .num1(num1), .num2(num2), .num3(num3), .num4(num4));
	
	// assign wire and an internal register for state, which should be 3 initially
	assign how_many = state;
	reg [3:0] in1; reg [3:0] in2; reg [3:0] op; // in1 is 0 if num1, etc. + = 0, - = 1, * = 2, / = 3

endmodule