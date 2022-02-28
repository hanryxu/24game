// generate 25MHz clock from 100MHz clock on board
module clock_gen_480p(clk, rst, clk_pix);
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
