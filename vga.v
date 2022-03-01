// output 640x480
module vga (clk_100m, rst, vga_hsync, vga_vsync, vga_r, vga_g, vga_b);
    input  clk_100m;     // 100 MHz clock
    input  rst;      // reset button (active low)
    output reg vga_hsync;    // horizontal sync
    output reg vga_vsync;    // vertical sync
    output reg [2:0] vga_r;  // 3-bit VGA red
    output reg [2:0] vga_g;  // 3-bit VGA green
    output reg [1:0] vga_b;   // 2-bit VGA blue

    // generate pixel clock
    wire clk_pix;
    clock_gen_480p clock_pix_inst (
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

    // based on sx and sy coordinates, determine which number to display
    // we have a total of 12 numbers

    // VGA output
    always @(posedge clk_pix) begin
        vga_hsync <= hsync;
        vga_vsync <= vsync;
        vga_r <= !de ? 3'h0 : (q_draw ? 3'h7 : 3'h0);
        vga_g <= !de ? 3'h0 : (q_draw ? 3'h7 : 3'h0);
        vga_b <= !de ? 2'h0 : (q_draw ? 2'h3 : 2'h0);
    end
endmodule