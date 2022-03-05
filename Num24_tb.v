module Num24_tb();
    initial
    begin
        $dumpfile("Num24_tb.vcd");
        $dumpvars(0, Num24_tb);
    end
    reg clk, rst, START, RESTART;
    reg [7:0] JA;
    wire hsync, vsync;
    wire [2:0] red;
    wire [2:0] green;
    wire [1:0] blue;

    Num24(clk, rst, JA, START, RESTART, red, green, blue, hsync, vsync);

    initial begin
		// seems that it's hard to simulate JA, so I give up here
		// please see vga_tb.v for screen simulation, and FSM_tb.v for game simulation
    end
endmodule
