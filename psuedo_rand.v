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
module psuedo_rand(clk, rst, enable, out);
    input clk, rst;
    input enable;
    output [3:0] out;
	
	 reg enabled = 1'b0;
    reg [3:0] register=4'b1010;

    assign out=register;

    always @(posedge clk) begin
        if (rst)
            register <= 4'b1010;
        if (enable && !enabled) begin // only update if enabled to do so
            register <= {register[2:0], ~(register[3] ^ register[2])};
				enabled <= 1'b1;
		  end else if (enable == 0) begin
				enabled <= 1'b0;
		  end else begin
		  end
    end

endmodule
