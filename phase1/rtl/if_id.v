`include "defines.v"
module if_id(
	input wire clk,
	input wire rst_n,
	input wire [31:0] inst_i,
	input wire [31:0] inst_addr_i,
	output reg [31:0] inst_addr_o,
	output reg [31:0] inst_o //???????
);

	always @ (posedge clk or negedge rst_n)begin

		if(!rst_n) begin
			inst_o <= `INST_NOP;
		end 
		else
			inst_o <= inst_i;
	end	
	
	always @ (posedge clk or negedge rst_n)begin
		if(!rst_n) begin
			inst_addr_o <= 32'd0;
		end 
		else
			inst_addr_o <= inst_addr_i;
	end	

endmodule