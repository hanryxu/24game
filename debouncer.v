module debouncer(clk_in, but, but_out);
    input wire clk_in;
    input wire but;
    output wire but_out;

    reg but_ff;
    always @ (posedge clk_in) begin
        if (but == 0)
            but_ff <= 0;
        else
            but_ff <= 1;
    end

    assign but_out = but_ff;

endmodule
