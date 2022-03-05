module number_converter_tb();
    reg [9:0] num1, num2, num3, num4;
    reg [3:0] valid;
    wire [47:0] numbers;

    initial
    begin
        $dumpfile("number_converter.vcd");
        $dumpvars(0, number_converter_tb);
    end

    number_converter n_m_INS(.num1(num1), .num2(num2), .num3(num3), .num4(num4), .valid(valid), .numbers(numbers));

    initial begin
        num1 = 0;
        num2 = 0;
        num3 = 0;
        num4 = 0;
        valid = 4'b1111;
        #5 num1 = 123;
        #5 num2 = 456;
        #5 num3 = 189;
        #5 num4 = 14;
        #5 $finish;
    end
endmodule
