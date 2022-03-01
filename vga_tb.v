`timescale 1ns / 1ps

module vga_tb();

    parameter CLK_PERIOD = 10;  // 10 ns == 100 MHz

    reg rst;
    reg clk_100m;

    reg [47:0] numbers_concat;

    wire hsync, vsync;
    wire [2:0] red;
    wire [2:0] green;
    wire [1:0] blue;

    vga vga_INS(.clk_100m(clk_100m), .rst(rst), .vga_hsync(hsync), .vga_vsync(vsync), .vga_r(red), .vga_g(green), .vga_b(blue));

    // generate clock
    always #(CLK_PERIOD / 2) clk_100m = ~clk_100m;

    initial begin
        rst = 1;
        clk_100m = 1;
        numbers_concat=47'b0000_0001_0010_0011_0100_0101_0110_0111_1000_1001_1010_1011;

        #100 rst = 0;
        #20_000_000 $finish;  // 18 ms (one frame is 16.7 ms)
    end
endmodule
