`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Joyce Tung
// 
// Create Date:    01:31:33 02/26/2022 
// Design Name: 
// Module Name:    valid_sets 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Given an index from 0-15, chooses a set of four numbers
//					 that has a solution for num24. This guarantees no unsolvable
//					 set of numbers is given. Given time, I will double the size of this set.
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module valid_sets(index, num1, num2, num3, num4);
	input wire [3:0] index;
	output wire [9:0] num1;
	output wire [9:0]	num2;
	output wire [9:0] num3;
	output wire [9:0] num4;
	always @(index) begin
		case(index)
			4'b0000: begin
				num1 = 2; num2 = 4; num3 = 8; num4 = 11;
			end
			4'b0001: begin
				num1 = 2; num2 = 6; num3 = 12; num4 = 13;
			end
			4'b0010: begin
				num1 = 3; num2 = 5; num3 = 7; num4 = 13;
			end
			4'b0011: begin
				num1 = 3; num2 = 6; num3 = 6; num4 = 11;
			end
			4'b0100: begin
				num1 = 1; num2 = 3; num3 = 7; num4 = 12;
			end
			4'b0101: begin
				num1 = 7; num2 = 8; num3 = 9; num4 = 10;
			end
			4'b0110: begin
				num1 = 2; num2 = 6; num3 = 11; num4 = 12;
			end
			4'b0111: begin
				num1 = 3; num2 = 4; num3 = 8; num4 = 13;
			end
			4'b1000: begin
				num1 = 3; num2 = 6; num3 = 10; num4 = 10;
			end
			4'b1001: begin
				num1 = 4; num2 = 4; num3 = 9; num4 = 12;
			end
			4'b1010: begin
				num1 = 4; num2 = 6; num3 = 7; num4 = 9;
			end
			4'b1011: begin
				num1 = 5; num2 = 6; num3 = 11; num4 = 13;
			end
			4'b1100: begin
				num1 = 8; num2 = 8; num3 = 11; num4 = 12;
			end
			4'b1101: begin
				num1 = 11; num2 = 12; num3 = 12; num4 = 13;
			end
			4'b1111: begin
				num1 = 7; num2 = 8; num3 = 10; num4 = 13;
			end
			default: begin // easy problem to bait
				num1 = 7; num2 = 8; num3 = 10; num4 = 13;
			end
		endcase
	end
endmodule
