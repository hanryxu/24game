`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Joyce Tung
// 
// Create Date:    00:20:25 02/26/2022 
// Design Name: 
// Module Name:    FSM 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Given the decoded inputs from the numberpad,
//					 START/RESTART buttons, output the four numbers displayed,
//					 how many are valid, or win/lose. Also responsible for updating
//					 numbers as the user acts.
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module FSM(clk, START, RESTART, decode, num1, num2, num3, num4, how_many, win);
	input clk, START, RESTART; // START = new game
	input [3:0] decode;
	output reg[9:0] num1; output reg[9:0] num2; output reg[9:0] num3; output reg[9:0] num4;
	wire [9:0] m1; wire [9:0] m2; wire [9:0] m3; wire [9:0] m4;
	output wire [1:0] how_many; // if 1 number is left, how_many == 00, and num is num1
	output wire win; // 1 if win, 0 otherwise (lose/not finished)
	
	assign win = (how_many == 0 && result == 24);
	
	// initialize num1, num2, num3, num4
	wire rst;
	reg [2:0] state; //discard initialization so code will synthesize 
	assign rst = (state == 3'b111); // only on if state is R
	wire [3:0] index;
	reg [7:0] result; //store the current result of all operations so far
	wire enable;
	assign enable = (state == 3'b111);
	psuedo_rand rand_index(.clk(clk), .rst(rst), .enable(enable), .out(index));
	valid_sets valid_set(.index(index), .num1(m1), .num2(m2), .num3(m3), .num4(m4));
	
	// assign wire and an internal register for state, which should be 3 initially
	// I'll eliminate this, and replace w/ a 4 bit string
	reg [3:0] valid = 4'b0000;
	assign how_many = (state == 3'b100) ? 0 : state;
	reg [9:0] in1; reg [9:0] in2; reg [1:0] op; // in1 stores num1 if 0, etc. + = 0, - = 1, * = 2, / = 3
	reg update2 = 0; // 1 if updating in2, 0 if updating in1
	reg opReady = 0; // 1 if ready to select operator for operation
	reg proceed = 0; // 1 if ready to proceed w/ operation
	always @(posedge clk) begin
		if (START) begin
			state <= 3'b111; // state R
			valid = 4'b0000;
		end else if (RESTART) begin
			if (state == 3'b111) begin
				state <= 3'b111;
				valid = 4'b0000;
			end else begin
				state <= 3'b011;
				valid = 4'b1111;
			end
		 end
		// assign num1, num2, num3, num4 to corr m if state == R
		else if (state == 3'b111) begin
			num1 = m1; num2 = m2; num3 = m3; num4 = m4;
			state <= 3'b011;
			valid = 4'b1111;
		end
		else if (state == 3'b11) begin
			case (decode)
				4'b0001: begin // 1
					if (valid[0] == 1) begin // if n1 can be selected for operating
						if (update2) begin
							in2 = num1;
							update2 = 0;
							opReady = 1;
						end else begin
							in1 = num1;
							update2 = 1;
							opReady = 0; // can't be ready if in2 isn't chosen
						end
						valid[0] = 0;
					end
				end
				4'b0010: begin // 2
					if (valid[1] == 1) begin // if n2 can be selected for operating
						if (update2) begin
							in2 = num2;
							update2 = 0;
							opReady = 1;
						end else begin
							in1 = num2;
							update2 = 1;
							opReady = 0;
						end
						valid[1] = 0;
					end
				end
				4'b0011: begin // 3
					if (valid[2] == 1) begin // if n3 can be selected for operating
						if (update2) begin
							in2 = num3;
							update2 = 0;
							opReady = 1;
						end else begin
							in1 = num3;
							update2 = 1;
							opReady = 0;
						end
						valid[2] = 0;
					end
				end
				4'b0100: begin // 4
					if (valid[3] == 1) begin // if n4 can be selected for operating
						if (update2) begin
							in2 = num4;
							update2 = 0;
							opReady = 1;
						end else begin
							in1 = num4;
							update2 = 1;
							opReady = 0;
						end
						valid[3] = 0;
					end
				end
				4'b1010: begin // A = add
					if (opReady) begin
						op = 2'b00;
						proceed = 1;
					end
				end
				4'b1011: begin // B = subtract
					if (opReady) begin
						op = 2'b01;
						proceed = 1;
					end
				end
				4'b1100: begin // C = divide
					if (opReady) begin
						op = 2'b10;
						proceed = 1;
					end
				end
				4'b1101: begin // D = multiply
					if (opReady) begin
						op = 2'b11;
						proceed = 1;
					end
				end
				default: begin // do nothing
				end
			 endcase
		end
		else begin
		    case (decode)
				4'b0001: begin // 1
					if (valid[0] == 1) begin // if n1 can be selected for operating
						in1 = num1;
						opReady = 1;
						valid[0] = 0;
					end
				end
				4'b0010: begin // 2
					if (valid[1] == 1) begin // if n2 can be selected for operating
						in1 = num2;
						opReady = 1;
						valid[1] = 0;
					end
				end
				4'b0011: begin // 3
					if (valid[2] == 1) begin // if n3 can be selected for operating
							in1 = num3;
							opReady = 1;
						valid[2] = 0;
					end
				end
				4'b0100: begin // 4
					if (valid[3] == 1) begin // if n4 can be selected for operating
					  in1 = num3;
					  valid[3] = 0;
				   end
				end
				4'b1010: begin // A = add
					if (opReady) begin
						op = 2'b00;
						proceed = 1;
					end
				end
				4'b1011: begin // B = subtract
					if (opReady) begin
						op = 2'b01;
						proceed = 1;
					end
				end
				4'b1100: begin // C = divide
					if (opReady) begin
						op = 2'b10;
						proceed = 1;
					end
				end
				4'b1101: begin // D = multiply
					if (opReady) begin
						op = 2'b11;
						proceed = 1;
					end
				end
				default: begin // do nothing
				end
			 endcase
		end
			// now proceed w/ the operation, if it's ready
			if (proceed) begin
				// reset all booleans to false
				proceed = 0;
				opReady = 0;
				update2 = 0;
				// Perform op, put result in one of the ops
				case (op)
					3'b00: begin
					  if (state == 3'b11) begin
					    result = in1 + in2;
					  end
					  else begin
					    result = result + in1;
					  end
					end
					3'b01: begin
					  if (state == 3'b11) begin
					    result = in1 - in2;
					  end
					  else begin
					    result = result - in1;
					  end
					end
					3'b10: begin
					  if (state == 3'b11) begin
					    result = in1 * in2;
					  end
					  else begin
					    result = result * in1;
					  end
					end
					3'b11: begin
					  if (state == 3'b11) begin
					    result = in1 / in2;
					  end
					  else begin
					    result = result / in1;
					  end
					end
				endcase
				state <= state - 1;
			end
		end
endmodule