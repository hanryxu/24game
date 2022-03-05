module FSM(clk, rst, START, RESTART, decode, m1, m2, m3, m4, num1, num2, num3, num4, valid_output, s1, s2);
    input clk, START, RESTART; // START = new game
	input rst;	// rst: reset random number generator
    input [3:0] decode;
    input [9:0] m1, m2, m3, m4;
    output [9:0] num1, num2, num3, num4;
	output [3:0] valid_output;
	output [2:0] s1, s2;
	// MSB is select_1 is actually being selected
	assign s1 = {valid[select_1] && state[2] == 1, select_1};
	assign s2 = {valid[select_2] && state[1] == 1, select_2};
	
    wire [3:0] index;
    reg [9:0] num[0:3];
    reg [3:0] valid=4'b1111;
    reg [9:0] num1_old, num2_old, num3_old, num4_old;
    wire [5:0] signal;
    reg [5:0] last_signal;
    reg [2:0] state;
    reg [3:0] last_state;
    reg [1:0] select_1; 
	 // wire [1:0] select_1_i;	// work around about wrong selection
    reg [1:0] select_2;
	 // wire [1:0] select_2_i;
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
	 
	 //assign select_1_i = 5 - select_1;
	 //assign select_2_i = 5 - select_2;

    //assign select_smaller = select_1_i < select_2_i ? select_1_i : select_2_i;
    //assign select_larger = select_1_i > select_2_i ? select_1_i : select_2_i;

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
					if(num[0]==24) begin
						win <= 1;
				   end else begin
						lose <= 1;
				   end
            end else begin
					  if(START==1) begin
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
							if(RESTART==1) begin // may want to check if there are values to go back to
								 state <= 3'b000;
								 num[0][9:0] <= num1_old[9:0];
								 num[1][9:0] <= num2_old[9:0];
								 num[2][9:0] <= num3_old[9:0];
								 num[3][9:0] <= num4_old[9:0];
								 valid <= 4'b1111;
							end else begin
								case(state) // b2 b1 b0, b0 = operator selected, b1 = operand2, b2 = operand1
									3'b000: begin
										 if (decode>=4'b0001 && decode<=4'b0100) begin
											  select_1 <= decode - 1;
											  state<=3'b100;
										 end else begin 
											  if(decode >= 4'b1010&& decode <= 4'b1101) begin
													op <= decode - 4'b1010;
													state<=3'b001;
											  end else begin
											  end
										 end
									end
									3'b001: begin
										 if(decode>=4'b0001 && decode<=4'b0100) begin
											  select_1 <= decode - 1;
											  state<=3'b101;
										 end else begin if(decode>=4'b1010&& decode<=4'b1101) begin
													op <= decode - 4'b1010;
													state<=3'b001;
											  end else begin
											  end
										 end
									end
									3'b100: begin
										 if(decode>=4'b0001 && decode<=4'b0100) begin
											  select_2 <= decode - 1;
											  state<=3'b110;
										 end else begin if(decode>=4'b1010&& decode<=4'b1101) begin
													op <= decode - 4'b1010;
													state<=3'b101;
											  end else begin
											  end
										 end
									end
									3'b101: begin
										 if(decode>=4'b0001 && decode<=4'b0100) begin
											  select_2 <= decode - 1;
											  state<=3'b111;
										 end else begin 
											  if(decode>=4'b1010&& decode<=4'b1101) begin // override operator
													op <= decode - 4'b1010;
													state<=3'b101;
											  end else begin
											  end
										 end
									end
									3'b110: begin
										 if(decode>=4'b0001 && decode<=4'b0100) begin // override select1, clear select2
											  select_1 <= decode - 1;
											  state<=3'b100;
										 end else begin if(decode>=4'b1010&& decode<=4'b1101) begin
													op <= decode - 4'b1010;
													state<=3'b111;
											  end else begin
											  end
										 end
									end
									3'b111: begin // operation is ready to go
										 num[select_smaller] <= result;
										 valid[select_larger] <= 1'b0;
										 state <= 3'b000;
									end
									default: begin // if we end up end up in a weird state, restart
										 state <= 3'b000;
									end
							  endcase
							end
					  end
				 end
			end
    end
endmodule
