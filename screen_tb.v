module screen_tb();
    reg [47:0] numbers_concat;
    reg [9:0] sx_offset, sy_offset;
    wire [9:0] sx_offset, sy_offset;
    number_to_display number_to_display_INS(.numbers_concat(numbers_concat), .sx(sx), .sy(sy), .sx_offset(sx_offset), .sy_offset(sy_offset));

    initial begin
		numbers_concat=47'b1111_1111_1101_1111_1111_1111_1111_1111_1111_1111_1111_1111;
        sx_offset = 220;
        sy_offset = 140;
    end
endmodule
