`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Joyce Tung
// 
// Create Date:    01:33:40 03/03/2022 
// Design Name: 
// Module Name:    number_converter 
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
module number_converter(num1, num2, num3, num4, valid, numbers);
	input [9:0] num1; input [9:0] num2; input [9:0] num3; input [9:0] num4;
	input reg [3:0] valid;
	output wire [47:0] numbers;
	assign numbers [11:0] = {num1 / 100, (num1 / 10) % 10, num1 % 10};
	assign numbers [23:12] = {num2 / 100, (num2 / 10) % 10, num2 % 10};
	assign numbers [35:24] = {num3 / 100, (num3 / 10) % 10, num3 % 10};
	assign numbers [47:36] = {num4 / 100, (num4 / 10) % 10, num4 % 10};
endmodule
