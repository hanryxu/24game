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
module Num24(clk, rst, JA, START, RESTART, red, green, blue, hsync, vsync);
    // User controls
    input clk;
    input rst;
    input [7:0] JA;
    input START, RESTART;
    // VGA stuff
    output [2:0] red;
    output [2:0] green;
    output [1:0] blue;
    output hsync, vsync;

    // clock generation
    wire clk_debounce;
    clock_gen clock_gen_INS(
                  .clk_in(clk),
                  .clk_debounce(clk_debounce)
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

    reg enable=1;
    wire [3:0] index;
    wire [9:0] m1, m2, m3, m4;
    psuedo_rand rand_index(.clk(clk), .rst(rst), .enable(enable), .out(index));
    valid_sets valid_set(.index(index), .num1(m1), .num2(m2), .num3(m3), .num4(m4));

    // FSM
    wire [9:0] num1, num2, num3, num4;
    wire [3:0] valid;
    FSM FSM_INS(.clk(clk), .rst(rst), .START(START_d), .RESTART(RESTART_d), .decode(decode), .m1(m1), .m2(m2), .m3(m3), .m4(m4), .num1(num1), .num2(num2), .num3(num3), .num4(num4), .valid_output(valid));

    wire [47:0] numbers;
    number_converter number_converter_INS(.num1(num1), .num2(num2), .num3(num3), .num4(num4), .valid(valid), .numbers(numbers));

    // VGA
    vga vga_INS(.clk_100m(clk), .rst(rst), .numbers_concat(numbers), .vga_hsync(hsync), .vga_vsync(vsync), .vga_r(red), .vga_g(green), .vga_b(blue));
endmodule
