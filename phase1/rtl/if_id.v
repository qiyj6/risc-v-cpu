`include "defines.v"
module if_id(
	input wire clk,
	input wire rst_n,
	input wire hold_flag_i,
	input wire [31:0] inst_i,
	input wire [31:0] inst_addr_i,
	output reg [31:0] inst_addr_o,
	output reg [31:0] inst_o //???????
);

	dff_s_set #(32) dff1(clk,rst_n,hold_flag_i,`INST_NOP,inst_i,inst_o);
	
	dff_s_set #(32) dff2(clk,rst_n,hold_flag_i,32'b0,inst_addr_i,inst_addr_o);
	
endmodule