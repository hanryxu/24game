module FSM_tb();
    initial
    begin
        $dumpfile("FSM.vcd");
        $dumpvars(0, FSM_tb);
    end
    wire [9:0] num1, num2, num3, num4;
    reg clk;
    reg rst;
    reg START, RESTART;
    reg [3:0] decode;

    reg [3:0] a=9;
    reg [3:0] b=8;
    wire [3:0] c;

    assign c=a/b;

    FSM FSM_INS(.clk(clk), .rst(rst), .START(START), .RESTART(RESTART), .decode(decode), .num1(num1), .num2(num2), .num3(num3), .num4(num4));

    initial begin
        clk=0;
        START=0;
        RESTART=0;
        decode=4'b0000;
        // #50 rst = 1;
        // #50 rst = 0;
        #100 START = 1;
        // 3 4 8 13
        #400 START = 0;
        #50 decode=4'b0000;
        #400 decode=4'b0100;	// 4
        #50 decode=4'b0000;
        #100 decode=4'b0010;	// 2
        #50 decode=4'b0000;
        #100 decode=4'b1011;	// 11
        #50 decode=4'b0000;
        #100 decode=4'b0011;	// 3
        #50 decode=4'b0000;
        #100 decode=4'b0010;	// 2
        #50 decode=4'b0000;
        #100 decode=4'b1100;	// 12
        #50 decode=4'b0000;
        #100 decode=4'b0010;	// 2
        #50 decode=4'b0000;
        #100 decode=4'b0001;	// 1
        #50 decode=4'b0000;
        #100 decode=4'b1101;	// 13
        #50 decode=4'b0000;
        #100 START = 1;
        // 8 8 11 12
        #400 START = 0;
        #50 decode=4'b0000;
        #400 decode=4'b0001;	// 1
        #50 decode=4'b0000;
        #100 decode=4'b0010;	// 2
        #50 decode=4'b0000;
        #100 decode=4'b1101;	// 13
        #50 decode=4'b0000;
        #100 decode=4'b0001;	// 1
        #50 decode=4'b0000;
        #100 decode=4'b0011;	// 3
        #50 decode=4'b0000;
        #100 decode=4'b1010;	// 10
        #50 decode=4'b0000;
        #100 decode=4'b0001;	// 1
        #50 decode=4'b0000;
        #100 decode=4'b0100;	// 4
        #50 decode=4'b0000;
        #100 decode=4'b1010;	// 10
        #50 decode=4'b0000;
        #100 $finish;
    end
    always #5 clk = ~clk;
endmodule
