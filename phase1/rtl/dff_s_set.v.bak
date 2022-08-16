module dff_s_set #(
	parameter DW  =  32
)
(

	input clk,
	input rst_n,
	input wire hold_flag_i,
	input wire [DW-1:0] set_data,
	input wire [DW-1:0] data_i,
	output reg [DW-1:0] data_o
);

	always@(posedge clk or negedge rst_n) begin
		if((!rst_n)||(hold_flag_i))
			data_o <= set_data;
		else
			data_o <= data_i;
	end 
	
	
endmodule
	