module screen_tb();
    reg [47:0] numbers_concat;
    reg [9:0] sx, sy;
    wire [2:0] vga_r;
    wire [2:0] vga_g;
    wire [1:0] vga_b;

    screen screen_tb(.sx(sx), .sy(sy), .numbers_concat(numbers_concat), .vga_r(vga_r), .vga_g(vga_g), .vga_b(vga_b));

    initial begin
        numbers_concat=47'b0000_0001_0010_0011_0100_0101_0110_0111_1000_1001_1010_1011;
        sx = 220;
        sy = 140;
    end
endmodule
