// output 640x480
module vga (clk_100m, rst, numbers_concat, vga_hsync, vga_vsync, vga_r, vga_g, vga_b);
    input  clk_100m;     // 100 MHz clock
    input  rst;      // reset button (active low)
    input [47:0] numbers_concat;
    output reg vga_hsync;    // horizontal sync
    output reg vga_vsync;    // vertical sync
    output reg [2:0] vga_r;  // 3-bit VGA red
    output reg [2:0] vga_g;  // 3-bit VGA green
    output reg [1:0] vga_b;  // 2-bit VGA blue

    // wire [47:0] numbers_concat=47'b0000_0001_0010_0011_0100_0101_0110_0111_1000_1001_1010_1011; // for testing vga only
    // generate pixel clock
    wire clk_pix;
    clock_gen_display clock_pix_inst (
                          .clk(clk_100m),
                          .rst(rst),
                          .clk_pix(clk_pix)
                      );

    // display sync signals and coordinates
    wire [9:0] sx, sy;
    wire hsync, vsync, de;
    simple_480p display_inst (
                    .clk_pix(clk_pix),
                    .rst(rst),  // wait for clock lock
                    .sx(sx),
                    .sy(sy),
                    .hsync(hsync),
                    .vsync(vsync),
                    .de(de)
                );

    // to align with clock
    wire [2:0] vga_r_wire;
    wire [2:0] vga_g_wire;
    wire [1:0] vga_b_wire;

    // based on sx and sy coordinates, determine rgb values using `screen`
    screen screen_INS(.sx(sx), .sy(sy), .numbers_concat(numbers_concat), .vga_r(vga_r_wire), .vga_g(vga_g_wire), .vga_b(vga_b_wire));

    // VGA output
    always @(posedge clk_pix) begin
        vga_hsync <= hsync;
        vga_vsync <= vsync;
        vga_r <= vga_r_wire;
        vga_g <= vga_g_wire;
        vga_b <= vga_b_wire;
    end
endmodule
