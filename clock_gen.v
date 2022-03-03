`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    02:39:29 02/02/2022
// Design Name:
// Module Name:    clock_gen
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
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
