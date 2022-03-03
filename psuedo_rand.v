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

    reg [3:0] register=4'b1010;

    assign out=register;

    always @(clk) begin
        if (rst)
            register <= 4'b1010;
        if (enable) // only update if enabled to do so
            register <= {register[2:0], ~(register[3] ^ register[2])};
    end

endmodule
