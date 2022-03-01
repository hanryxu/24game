module seven_segment_sim(sx_offset, sy_offset, number, if_display);
    input [9:0] sx_offset, sy_offset;
    input [3:0] number;
    output if_display;

    wire if_a, if_b, if_c, if_d, if_e, if_f, if_g;
    assign if_a = (sx_offset >= 0 && sx_offset < 80 && sy_offset >= 0 && sy_offset < 20);
    assign if_b = {sx_offset >= 60 && sx_offset < 80 && sy_offset >= 0 && sy_offset < 80};
    assign if_c = {sx_offset >= 60 && sx_offset < 80 && sy_offset >= 60 && sy_offset < 140};
    assign if_d = {sx_offset >= 0 && sx_offset < 80 && sy_offset >= 120 && sy_offset < 140};
    assign if_e = {sx_offset >= 0 && sx_offset < 20 && sy_offset >= 60 && sy_offset < 140};
    assign if_f = {sx_offset >= 0 && sx_offset < 20 && sy_offset >= 0 && sy_offset < 80};
    assign if_g = {sx_offset >= 0 && sx_offset < 80 && sy_offset >= 60 && sy_offset < 80};

    wire if_0, if_1, if_2, if_3, if_4, if_5, if_6, if_7, if_8, if_9;
    assign if_0 = if_a || if_b || if_c || if_d || if_e || if_f;
    assign if_1 = if_b || if_c;
    assign if_2 = if_a || if_b || if_g || if_e || if_d;
    assign if_3 = if_a || if_b || if_g || if_c || if_d;
    assign if_4 = if_f || if_g || if_b || if_c;
    assign if_5 = if_a || if_f || if_g || if_c || if_d;
    assign if_6 = if_a || if_f || if_g || if_c || if_d || if_e;
    assign if_7 = if_a || if_b || if_c;
    assign if_8 = if_a || if_b || if_c || if_d || if_e || if_f || if_g;
    assign if_9 = if_a || if_b || if_c || if_d || if_f || if_g;

    assign if_display = (number == 0 && if_0) || (number == 1 && if_1) || (number == 2 && if_2)
           || (number == 3 && if_3) || (number == 4 && if_4) || (number == 5 && if_5)
           || (number == 6 && if_6) || (number == 7 && if_7) || (number == 8 && if_8)
           || (number == 9 && if_9);
endmodule
