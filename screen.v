module screen(clk_display, screen_bits);
    output reg [24:0] screen_bits[0:639][0:479];
    // 24 bits: red green blue, 23-16 red, 15-8 green, 7-0 blue

    reg [11:0] sx;
    reg [11:0] sy;

    // refresh display using the same rate of pixel clock
    always @(posedge clk_display) begin
        if (sx == 639) begin
            sx = 0;
            if (sy == 479) begin
                sy = 0;
            end else begin
                sy = sy + 1;
            end
        end else begin
            sx = sx + 1;
        end
    end

    // display the screen, just update the current bit
    always @(posedge clk_display) begin
        if(sx>=320) begin
            screen_bits[sx][sy] = 24'hffffff;
        end else begin
            screen_bits[sx][sy] = 24'b1;
        end
    end
endmodule
