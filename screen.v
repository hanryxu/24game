module screen(sx, sy, numbers_concat, vga_r, vga_g, vga_b);
    input [9:0] sx, sy;
    // Port numbers must not be declared to be an array
    //     -- From Verilog IEEE 1364-2001
    input [47:0] numbers_concat; // 12 numbers to display, each with 4 bits
    // number 0123456789 is stored as
    // 0000 0001 0010 0011 0100 0101 0110 0111 1000 1001
    output reg [2:0] vga_r;  // 3-bit VGA red
    output reg [2:0] vga_g;  // 3-bit VGA green
    output reg [1:0] vga_b;   // 2-bit VGA blue

    // based on sx and sy coordinates, determine which number to display
    wire [3:0] number;
    wire [9:0] sx_offset, sy_offset;

    number_to_display number_to_display_INS(.numbers_concat(numbers_concat), .sx(sx), .sy(sy), .number(number), .sx_offset(sx_offset), .sy_offset(sy_offset));

    // based on number and the two offsets, determine whether to display pixel

    wire if_display;
endmodule

module number_to_display(numbers_concat, sx, sy, number, sx_offset, sy_offset);
    input [47:0] numbers_concat; // 12 numbers to display, each with 4 bits
    input [9:0] sx, sy;
    output [9:0] sx_offset, sy_offset;
    output [3:0] number;

    reg [3:0] the_number;
    reg [9:0] sx_offset_reg, sy_offset_reg;
    always @(*) begin
        case (1)
            (sx>=20 && sx<=100 && sy>=20 && sy<=160) : begin
                the_number[3:0] <= numbers_concat[47:44];
                sx_offset_reg <= sx - 20;
                sy_offset_reg <= sy - 20;
            end
            (sx>=120 && sx<=200 && sy>=20 && sy<=160) : begin
                the_number <= numbers_concat[43:40];
                sx_offset_reg <= sx - 120;
                sy_offset_reg <= sy - 20;
            end
            (sx>=220 && sx<=300 && sy>=20 && sy<=160) : begin
                the_number <= numbers_concat[39:36];
                sx_offset_reg <= sx - 220;
                sy_offset_reg <= sy - 20;
            end
            (sx>=340 && sx<=420 && sy>=20 && sy<=160) : begin
                the_number <= numbers_concat[35:32];
                sx_offset_reg <= sx - 340;
                sy_offset_reg <= sy - 20;
            end
            (sx>=440 && sx<=520 && sy>=20 && sy<=160) : begin
                the_number <= numbers_concat[31:28];
                sx_offset_reg <= sx - 440;
                sy_offset_reg <= sy - 20;
            end
            (sx>=540 && sx<=620 && sy>=20 && sy<=160) : begin
                the_number <= numbers_concat[27:24];
                sx_offset_reg <= sx - 540;
                sy_offset_reg <= sy - 20;
            end
            (sx>=20 && sx<=100 && sy>=200 && sy<=340) : begin
                the_number <= numbers_concat[23:20];
                sx_offset_reg <= sx - 20;
                sy_offset_reg <= sy - 200;
            end
            (sx>=120 && sx<=200 && sy>=200 && sy<=340) : begin
                the_number <= numbers_concat[19:16];
                sx_offset_reg <= sx - 120;
                sy_offset_reg <= sy - 200;
            end
            (sx>=220 && sx<=300 && sy>=200 && sy<=340) : begin
                the_number <= numbers_concat[15:12];
                sx_offset_reg <= sx - 220;
                sy_offset_reg <= sy - 200;
            end
            (sx>=340 && sx<=420 && sy>=200 && sy<=340) : begin
                the_number <= numbers_concat[11:8];
                sx_offset_reg <= sx - 340;
                sy_offset_reg <= sy - 200;
            end
            (sx>=440 && sx<=520 && sy>=200 && sy<=340) : begin
                the_number <= numbers_concat[7:4];
                sx_offset_reg <= sx - 440;
                sy_offset_reg <= sy - 200;
            end
            (sx>=540 && sx<=620 && sy>=200 && sy<=340) : begin
                the_number <= numbers_concat[3:0];
                sx_offset_reg <= sx - 540;
                sy_offset_reg <= sy - 200;
            end

            default : begin
                the_number <= 0;
                sx_offset_reg <= 0;
                sy_offset_reg <= 0;
            end
        endcase
    end

    assign number = the_number;
    assign sx_offset = sx_offset_reg;
    assign sy_offset = sy_offset_reg;
endmodule

module illuminate(sx_offset, sy_offset, number, if_display);
    input [9:0] sx_offset, sy_offset;
    input [3:0] number;
    output if_display;

    // based on sx and sy coordinates, determine which number to display
    wire [3:0] number;
    wire [9:0] sx_offset, sy_offset;

    illuminate_number illuminate_number_INS(.sx_offset(sx_offset), .sy_offset(sy_offset), .number(number), .vga_r(vga_r), .vga_g(vga_g), .vga_b(vga_b));
