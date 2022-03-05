// Reference
// Project F: FPGA Graphics - Simple 1920x1080p60 Display
// (C)2021 Will Green, open source hardware released under the MIT License
// Learn more at https://projectf.io


// generate 25MHz clock from 100MHz clock on board
module simple_480p (clk_pix, rst, sx, sy, hsync, vsync, de);
    input  clk_pix;   // pixel clock
    input  rst;       // reset
    output [9:0] sx;  // horizontal screen position
    output [9:0] sy;  // vertical screen position
    output hsync;     // horizontal sync
    output vsync;     // vertical sync
    output de;         // data enable (low in blanking interval)

    reg [9:0] sx_cnt;
    reg [9:0] sy_cnt;

    // horizontal timings
    localparam HA_END = 639;           // end of active pixels
    localparam HS_STA = HA_END + 16;   // sync starts after front porch
    localparam HS_END = HS_STA + 96;   // sync ends
    localparam LINE   = 799;           // last pixel on line (after back porch)

    // vertical timings
    localparam VA_END = 479;           // end of active pixels
    localparam VS_STA = VA_END + 10;   // sync starts after front porch
    localparam VS_END = VS_STA + 2;    // sync ends
    localparam SCREEN = 524;           // last line on screen (after back porch)

    assign hsync = ~(sx >= HS_STA && sx < HS_END);  // invert: negative polarity
    assign vsync = ~(sy >= VS_STA && sy < VS_END);  // invert: negative polarity
    assign de = (sx <= HA_END && sy <= VA_END);

    // calculate horizontal and vertical screen position
    always @(posedge clk_pix) begin
        if(rst) begin
            sx_cnt <= 10'b0;
            sy_cnt <= 10'b0;
        end else begin
            if (sx_cnt == LINE) begin  // last pixel on line?
                sx_cnt <= 10'b0;
                sy_cnt <= (sy_cnt == SCREEN) ? 10'b0 : sy_cnt + 1'b1;  // last line on screen?
            end else begin
                sx_cnt <= sx_cnt + 1'b1;
            end
        end
    end

    assign sx=sx_cnt;
    assign sy=sy_cnt;
endmodule
