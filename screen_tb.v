module screen_tb();
    reg [47:0] numbers_concat;
    reg [9:0] sx, sy;
    wire [2:0] vga_r;
    wire [2:0] vga_g;
    wire [1:0] vga_b;

    screen screen_tb(.sx(sx), .sy(sy), .numbers_concat(numbers_concat), .vga_r(vga_r), .vga_g(vga_g), .vga_b(vga_b));

    initial begin
        numbers_concat=47'b0000_0001_0010_0011_0100_0101_0110_0111_1000_1001_1010_1011;
        sx = 40;
        sy = 90;

        #10 sx = 140;
        #20 sx = 240;
        #30 sx = 340;
        #40 sx = 440;
        #50 sx = 540;

        #60 sy = 240;
        #60 sx = 30;
        #70 sx = 130;
        #80 sx = 230;
        #90 sx = 360;
        #100 sx = 500;
        #110 sx = 540;
    end
endmodule
