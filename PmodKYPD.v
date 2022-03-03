`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Joyce Tung
// 
// Create Date:    00:21:19 02/26/2022 
// Design Name: 
// Module Name:    PmodKYPD 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Adapted from Diligent's example verilog code for PmodKYPD
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//		Original Source: https://digilent.com/reference/pmod/pmodkypd/start
//////////////////////////////////////////////////////////////////////////////////
module PmodKYPD( clk, JA, Decode);
	input clk;					// 100Mhz onboard clock
	input [7:0] JA;			// Port JA on Nexys3, JA[3:0] is Columns, JA[7:4] is rows

	output wire [3:0] Decode;

	Decoder C0(
			.clk(clk),
			.Row(JA[7:4]),
			.Col(JA[3:0]),
			.DecodeOut(Decode)
	);
endmodule
