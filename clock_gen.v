`timescale 1ns / 1ps
module clock_gen(
        clk_in,
        clk_debounce,
    );
    input clk_in;
    output reg clk_debounce=0;

    // reset values for counters
    localparam debounce = 32'd99_999;

    // Initialize and declare ccounters
    reg [31:0] counter_debounce = 0;

    always @(posedge clk_in) begin
        if (counter_debounce == debounce) begin
            counter_debounce <= 0;
            clk_debounce <= ~clk_debounce;
        end
        else
            counter_debounce <= counter_debounce + 1'b1;
    end

endmodule

// generate 25MHz clock from 100MHz clock on board
module clock_gen_display(clk, rst, clk_pix);
    input clk;
    input rst;
    output clk_pix;

    reg clk_display=0;
    reg [1:0] counter=0;
    always @(posedge clk) begin
        counter <= counter + 1;
        if (counter == 1) begin
            counter <= 0;
            clk_display = ~clk_display;
        end
    end

    assign clk_pix = clk_display;
endmodule