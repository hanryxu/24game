module FSM(clk, START, RESTART, decode, num1, num2, num3, num4);
    input clk, START, RESTART; // START = new game
    input [3:0] decode;
    output [9:0] num1, num2, num3, num4;

    wire [3:0] index;
    reg [9:0] num[0:3];
    reg [3:0] valid;
    reg [9:0] num1_old, num2_old, num3_old, num4_old;
    wire [9:0] m1, m2, m3, m4;
    wire [5:0] signal;
    reg [5:0] last_signal;
    reg [2:0] state;
    reg [3:0] last_state;
    reg [1:0] select_1;
    reg [1:0] select_2;
    wire [1:0] select_smaller;
    wire [1:0] select_larger;
    reg [1:0] op;
    wire [9:0] cal_num1, cal_num2;
    wire [9:0] result_add, result_sub, result_mul, result_div;
    wire [9:0] result;
    wire rst;
    reg win;
    reg lose;

    assign num1=num[0];
    assign num2=num[1];
    assign num3=num[2];
    assign num4=num[3];

    assign signal={START, RESTART, decode};
    assign rst=START||RESTART;

    assign select_smaller = select_1 < select_2 ? select_1 : select_2;
    assign select_larger = select_1 > select_2 ? select_1 : select_2;

    assign cal_num1 = num[select_1];
    assign cal_num2 = num[select_2];

    assign result_add=cal_num1+cal_num2;
    assign result_sub=cal_num1-cal_num2;
    assign result_mul=cal_num1*cal_num2;
    assign result_div=cal_num1/cal_num2;

    assign result=(op==2'b00 ? result_add : (op==2'b01 ? result_sub : (op==2'b10 ? result_mul : result_div)));

    psuedo_rand rand_index(.clk(clk), .rst(rst), .enable(enable), .out(index));
    valid_sets valid_set(.index(index), .num1(m1), .num2(m2), .num3(m3), .num4(m4));

    always @(posedge clk) begin
        last_signal<=signal;
        if(last_signal==signal) begin
        end else
        begin
            if(valid==4'b1000) begin
            end else begin
                if((START==0&&last_signal[5]==1)||(RESTART==0&&last_signal[4]==1)||decode==0&&last_signal[3:0]!=0) begin
                end
                else
                begin
                    if(START==1&&last_signal[5]==0) begin
                        state <= 3'b000;
                        num[0] <= m1;
                        num[1] <= m2;
                        num[2] <= m3;
                        num[3] <= m4;
                        num1_old <= m1;
                        num2_old <= m2;
                        num3_old <= m3;
                        num4_old <= m4;
                        valid <= 4'b1111;
                    end else
                    begin
                        if(RESTART==1&&last_signal[4]==0) begin
                            state <= 3'b000;
                            num[0] <= num1_old;
                            num[1] <= num2_old;
                            num[2] <= num3_old;
                            num[3] <= num4_old;
                            valid <= 4'b1111;
                        end
                        else
                        begin if(valid==4'b1000) begin
                                if(num[0]==24) begin
                                    win <= 1;
                                end
                                else begin
                                    lose <= 1;
                                end
                            end
                            else
                            begin
                                case(state)
                                    3'b000: begin
                                        if(decode<=4'b0100) begin
                                            select_1[1:0] <= decode[1:0]-1;
                                            state<=3'b100;
                                        end else begin
                                            op[1:0]=decode-4'b1010;
                                            state<=3'b001;
                                        end
                                    end
                                    3'b001: begin
                                        if(decode<=4'b0100) begin
                                            select_1[1:0] <= decode[1:0]-1;
                                            state<=3'b101;
                                        end else begin
                                            op[1:0]=decode-4'b1010;
                                            state<=3'b001;
                                        end
                                    end
                                    3'b100: begin
                                        if(decode<=4'b0100) begin
                                            select_2[1:0] <= decode[1:0]-1;
                                            state<=3'b110;
                                        end else begin
                                            op[1:0]=decode-4'b1010;
                                            state<=3'b101;
                                        end
                                    end
                                    3'b101: begin
                                        if(decode<=4'b0100) begin
                                            select_2[1:0] <= decode[1:0]-1;
                                            state<=3'b111;
                                        end else begin
                                            op[1:0]=decode-4'b1010;
                                            state<=3'b101;
                                        end
                                    end
                                    3'b110: begin
                                        if(decode<=4'b0100) begin
                                            select_1[1:0] <= decode[1:0]-1;
                                            state<=3'b100;
                                        end else begin
                                            op[1:0]=decode-4'b1010;
                                            state<=3'b111;
                                        end
                                    end
                                    3'b111: begin
                                        num[select_smaller] <= result;
                                        valid[select_larger] <= 1'b0;
                                        if(decode<=4'b0100) begin
                                            select_1[1:0] <= decode[1:0]-1;
                                            state<=3'b100;
                                        end else begin
                                            op[1:0]=decode-4'b1010;
                                            state<=3'b001;
                                        end
                                    end
                                    default: begin
                                        state <= 3'b000;
                                    end
                                endcase
                            end
                        end
                    end
                end
            end
        end
    end
endmodule
