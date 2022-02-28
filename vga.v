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

    // size of screen with and without blanking
    /* verilator lint_off UNUSED */
    localparam H_RES_FULL = 800;
    localparam V_RES_FULL = 525;
    localparam H_RES      = 640;
    localparam V_RES      = 480;
    /* verilator lint_on UNUSED */

    wire animate;  // high for one clock tick at start of vertical blanking
    assign animate = (sy == V_RES && sx == 0);

    // square 'Q' - origin at top-left
    localparam Q_SIZE = 32;    // square size in pixels
    localparam Q_SPEED = 4;    // pixels moved per frame
    reg [9:0] qx;
	reg [9:0] qy;  // square position

    // update square position once per frame
    always @(posedge clk_pix) begin
        if (animate) begin
            if (qx >= H_RES_FULL - Q_SIZE) begin
                qx <= 0;
                qy <= (qy >= V_RES_FULL - Q_SIZE) ? 0 : qy + Q_SIZE;
            end else begin
                qx <= qx + Q_SPEED;
            end
        end
    end

    // is square at current screen position?
    wire q_draw;

    assign q_draw = (sx >= qx) && (sx < qx + Q_SIZE) && (sy >= qy) && (sy < qy + Q_SIZE);

    // VGA output
    always @(posedge clk_pix) begin
        vga_hsync <= hsync;
        vga_vsync <= vsync;
        vga_r <= !de ? 3'h0 : (q_draw ? 3'h7 : 3'h0);
        vga_g <= !de ? 3'h0 : (q_draw ? 3'h7 : 3'h0);
        vga_b <= !de ? 2'h0 : (q_draw ? 2'h3 : 2'h0);
    end
endmodule