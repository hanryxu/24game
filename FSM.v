module FSM(clk, rst, START, RESTART, decode, m1, m2, m3, m4, num1, num2, num3, num4, valid_output, select_1, select_2);
    input clk, START, RESTART; // START = new game
	input rst;	// rst: reset random number generator
    input [3:0] decode;
    input [9:0] m1, m2, m3, m4;
    output [9:0] num1, num2, num3, num4;
	output [3:0] valid_output;

    wire [3:0] index;
    reg [9:0] num[0:3];
    reg [3:0] valid;
    reg [9:0] num1_old, num2_old, num3_old, num4_old;
    wire [5:0] signal;
    reg [5:0] last_signal;
    reg [2:0] state;
    reg [3:0] last_state;
    output reg [1:0] select_1;
    output reg [1:0] select_2;
    wire [1:0] select_smaller;
    wire [1:0] select_larger;
    reg [1:0] op;
    wire [9:0] cal_num1, cal_num2;
    wire [9:0] result_add, result_sub, result_mul, result_div;
    wire [9:0] result;
    reg win;
    reg lose;

    assign num1=num[0];
    assign num2=num[1];
    assign num3=num[2];
    assign num4=num[3];
	assign valid_output=valid;

    assign signal={START, RESTART, decode};

    assign select_smaller = select_1 < select_2 ? select_1 : select_2;
    assign select_larger = select_1 > select_2 ? select_1 : select_2;

    assign cal_num1 = num[select_1];
    assign cal_num2 = num[select_2];

    assign result_add=cal_num1+cal_num2;
    assign result_sub=cal_num1-cal_num2;
    assign result_mul=cal_num1*cal_num2;
    assign result_div=cal_num1/cal_num2;

    assign result=(op==2'b00 ? result_add : (op==2'b01 ? result_sub : (op==2'b10 ? result_mul : result_div)));

    always @(posedge clk) begin
        last_signal<=signal;
        if(last_signal==signal) begin
        end else
        begin
            if(valid==4'b1000) begin
            end else begin
                if((START==0&&last_signal[5]==1)||(RESTART==0&&last_signal[4]==1)) begin
                end
                else
                begin
                    if(START==1&&last_signal[5]==0) begin
                        state <= 3'b000;
                        num[0] <= m1;
                        num[1] <= m2;
                        num[2] <= m3;
                        num[3] <= m4;
                        num1_old[9:0] <= m1[9:0];
                        num2_old[9:0] <= m2[9:0];
                        num3_old[9:0] <= m3[9:0];
                        num4_old[9:0] <= m4[9:0];
                        valid <= 4'b1111;
                    end else
                    begin
                        if(RESTART==1&&last_signal[4]==0) begin
                            state <= 3'b000;
                            num[0][9:0] <= num1_old[9:0];
                            num[1][9:0] <= num2_old[9:0];
                            num[2][9:0] <= num3_old[9:0];
                            num[3][9:0] <= num4_old[9:0];
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
                                        if(decode>=4'b0001 && decode<=4'b0100) begin
                                            select_1[1:0] <= decode[1:0]-1;
                                            state<=3'b100;
                                        end else begin if(decode>=4'b1010&& decode<=4'b1101) begin
                                                op[1:0]<=decode-4'b1010;
                                                state<=3'b001;
                                            end else begin
                                            end
                                        end
                                    end
                                    3'b001: begin
                                        if(decode>=4'b0001 && decode<=4'b0100) begin
                                            select_1[1:0] <= decode[1:0]-1;
                                            state<=3'b101;
                                        end else begin if(decode>=4'b1010&& decode<=4'b1101) begin
                                                op[1:0]<=decode-4'b1010;
                                                state<=3'b001;
                                            end else begin
                                            end
                                        end
                                    end
                                    3'b100: begin
                                        if(decode>=4'b0001 && decode<=4'b0100) begin
                                            select_2[1:0] <= decode[1:0]-1;
                                            state<=3'b110;
                                        end else begin if(decode>=4'b1010&& decode<=4'b1101) begin
                                                op[1:0]<=decode-4'b1010;
                                                state<=3'b101;
                                            end else begin
                                            end
                                        end
                                    end
                                    3'b101: begin
                                        if(decode>=4'b0001 && decode<=4'b0100) begin
                                            select_2[1:0] <= decode[1:0]-1;
                                            state<=3'b111;
                                        end else begin if(decode>=4'b1010&& decode<=4'b1101) begin
                                                op[1:0]<=decode-4'b1010;
                                                state<=3'b101;
                                            end else begin
                                            end
                                        end
                                    end
                                    3'b110: begin
                                        if(decode>=4'b0001 && decode<=4'b0100) begin
                                            select_1[1:0] <= decode[1:0]-1;
                                            state<=3'b100;
                                        end else begin if(decode>=4'b1010&& decode<=4'b1101) begin
                                                op[1:0]<=decode-4'b1010;
                                                state<=3'b111;
                                            end else begin
                                            end
                                        end
                                    end
                                    3'b111: begin
                                        num[select_smaller] <= result;
                                        valid[select_larger] <= 1'b0;
                                        state <= 3'b000;
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
