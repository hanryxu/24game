module screen(sx, sy, numbers_concat, vga_r, vga_g, vga_b, s1, s2, win, lose); // sel1, sel2, state = 110
    input [9:0] sx, sy;
    input [2:0] s1, s2;
    input win , lose;
    // Port numbers must not be declared to be an array
    //     -- From Verilog IEEE 1364-2001
    input [47:0] numbers_concat; // 12 numbers to display, each with 4 bits
    // number 0123456789 is stored as
    // 0000 0001 0010 0011 0100 0101 0110 0111 1000 1001
    output [2:0] vga_r;  // 3-bit VGA red
    output [2:0] vga_g;  // 3-bit VGA green
    output [1:0] vga_b;   // 2-bit VGA blue

    // based on sx and sy coordinates, determine which number to display
    wire [3:0] number;
    wire [2:0] num_pos;
    wire [9:0] sx_offset, sy_offset;

    number_to_display number_to_display_INS(.numbers_concat(numbers_concat), .sx(sx), .sy(sy), .number(number), .sx_offset(sx_offset), .sy_offset(sy_offset), .num_pos(num_pos)
                                            , .win(win), .lose(lose));

    // based on number and the two offsets, determine whether to display pixel

    wire if_display;

    seven_segment_sim seven_segment_sim_INS(.sx_offset(sx_offset), .sy_offset(sy_offset), .number(number), .if_display(if_display));

    // based on if_display and color (not specified yet), determine pixel color
    // num_pos == 3'b100, s1 = 3'b100
    assign vga_r = if_display ? (((num_pos == s1[1:0] && s1[2] == 1) || (num_pos==s2[1:0] && s2[2] == 1)) ? 3'b111 :3'b111) : 3'b0;
    assign vga_g = if_display ? (((num_pos == s1[1:0] && s1[2] == 1) || (num_pos==s2[1:0] && s2[2] == 1)) ? 3'b000 :3'b111) : 3'b0;
    assign vga_b = if_display ? (((num_pos == s1[1:0] && s1[2] == 1) || (num_pos==s2[1:0] && s2[2] == 1)) ? 2'b00 : 2'b11) : 2'b0;
endmodule

module number_to_display(numbers_concat, sx, sy, number, sx_offset, sy_offset, num_pos, win, lose);
    input [47:0] numbers_concat; // 12 numbers to display, each with 4 bits
    input [9:0] sx, sy;
    input win , lose;
    output [9:0] sx_offset, sy_offset;
    output [3:0] number;

    reg [3:0] the_number; // Value
    output reg [1:0] num_pos; // position
    reg [9:0] sx_offset_reg, sy_offset_reg;
    always @(*) begin
        case (1)
            (sx>=20 && sx<100 && sy>=20 && sy<160) : begin
                the_number[3:0] <= numbers_concat[47:44];
                sx_offset_reg <= sx - 20;
                sy_offset_reg <= sy - 20;
                num_pos <= 3'b000;
            end
            (sx>=120 && sx<200 && sy>=20 && sy<160) : begin
                the_number[3:0] <= numbers_concat[43:40];
                sx_offset_reg <= sx - 120;
                sy_offset_reg <= sy - 20;
                num_pos <= 3'b000;
            end
            (sx>=220 && sx<300 && sy>=20 && sy<160) : begin
                the_number[3:0] <= numbers_concat[39:36];
                sx_offset_reg <= sx - 220;
                sy_offset_reg <= sy - 20;
                num_pos <= 3'b000;
            end
            (sx>=340 && sx<420 && sy>=20 && sy<160) : begin
                the_number[3:0] <= numbers_concat[35:32];
                sx_offset_reg <= sx - 340;
                sy_offset_reg <= sy - 20;
                num_pos <= 3'b001;
            end
            (sx>=440 && sx<520 && sy>=20 && sy<160) : begin
                the_number[3:0] <= numbers_concat[31:28];
                sx_offset_reg <= sx - 440;
                sy_offset_reg <= sy - 20;
                num_pos <= 3'b001;
            end
            (sx>=540 && sx<620 && sy>=20 && sy<160) : begin
                the_number[3:0] <= numbers_concat[27:24];
                sx_offset_reg <= sx - 540;
                sy_offset_reg <= sy - 20;
                num_pos <= 3'b001;
            end
            (sx>=20 && sx<100 && sy>=200 && sy<340) : begin
                the_number[3:0] <= numbers_concat[23:20];
                sx_offset_reg <= sx - 20;
                sy_offset_reg <= sy - 200;
                num_pos <= 3'b010;
            end
            (sx>=120 && sx<200 && sy>=200 && sy<340) : begin
                the_number[3:0] <= numbers_concat[19:16];
                sx_offset_reg <= sx - 120;
                sy_offset_reg <= sy - 200;
                num_pos <= 3'b010;
            end
            (sx>=220 && sx<300 && sy>=200 && sy<340) : begin
                the_number[3:0] <= numbers_concat[15:12];
                sx_offset_reg <= sx - 220;
                sy_offset_reg <= sy - 200;
                num_pos <= 3'b010;
            end
            (sx>=340 && sx<420 && sy>=200 && sy<340) : begin
                the_number[3:0] <= numbers_concat[11:8];
                sx_offset_reg <= sx - 340;
                sy_offset_reg <= sy - 200;
                num_pos <= 3'b011;
            end
            (sx>=440 && sx<520 && sy>=200 && sy<340) : begin
                the_number[3:0] <= numbers_concat[7:4];
                sx_offset_reg <= sx - 440;
                sy_offset_reg <= sy - 200;
                num_pos <= 3'b011;
            end
            (sx>=540 && sx<620 && sy>=200 && sy<340) : begin
                the_number[3:0] <= numbers_concat[3:0];
                sx_offset_reg <= sx - 540;
                sy_offset_reg <= sy - 200;
                num_pos <= 3'b011;
            end
            (sx>=120 && sx<200 && sy >= 340 && sy < 480) : begin
                the_number[3:0] <= (win) ? 11 : ((lose) ? 10 : 15);
                sx_offset_reg <= sx - 120;
                sy_offset_reg <= sy - 340;
                num_pos <= 3'b100;
            end
            default : begin
                the_number[3:0] <= 4'b1111;  // set to invalid number, turning off the display
                sx_offset_reg <= 0;
                sy_offset_reg <= 0;
                num_pos <= 3'b000;
            end
        endcase
    end

    assign number = the_number;
    assign sx_offset = sx_offset_reg;
    assign sy_offset = sy_offset_reg;
endmodule
